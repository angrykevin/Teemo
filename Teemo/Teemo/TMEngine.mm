//
//  TMEngine.m
//  Teemo
//
//  Created by Wu Kevin on 11/5/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "TMEngine.h"

#import "TMConfig.h"
#import "TMCommon.h"


static TMEngine *CurrentEngine = nil;


@implementation TMEngine

+ (TMEngine *)sharedEngine
{
  return CurrentEngine;
}

+ (void)storeEngine:(TMEngine *)engine
{
  CurrentEngine = engine;
}

+ (void)clearStoredEngine
{
  CurrentEngine = nil;
}



- (void)setUpWithPassport:(NSString *)passport password:(NSString *)password
{
  NSAssert([passport length]>0, @"passport error");
  NSAssert([password length]>0, @"password error");
  
  _passport = [passport copy];
  _password = [password copy];
  
  _database = TMCreateDatabase();
  
  _cancelled = NO;
  
  string jid = CPPSTR(TMJIDFromPassport(passport));
  string pwd = CPPSTR(password);
  string svr = CPPSTR(TMXMPPServerHost);
  int prt = [TMXMPPServerPort intValue];
  
  _client = new Client( JID( jid ), pwd );
  _client->setServer( svr );
  _client->setPort( prt );
  _client->setResource( CPPSTR(TMXMPPClientResource) );
  
  
  _connectionHandler = new TMConnectionHandler;
  _connectionHandler->setEngine((__bridge void *)self);
  _client->registerConnectionListener(_connectionHandler);
  
  _rosterHandler = new TMRosterHandler;
  _rosterHandler->setEngine((__bridge void *)self);
  _client->rosterManager()->registerRosterListener(_rosterHandler);
  
}

- (BOOL)connect
{
  TKPRINTMETHOD();
  
  if ( _cancelled ) {
    return NO;
  }
  
  [self performSelector:@selector(connectionBody:)
               onThread:[[self class] engineThread]
             withObject:[NSValue valueWithPointer:_client]
          waitUntilDone:NO
                  modes:@[ NSRunLoopCommonModes ]];
  
  
  return YES;
  
}

- (void)disconnect
{
  _cancelled = YES;
  
  _client = NULL;
  
}


- (NSArray *)buddiesForSubscriptions:(NSArray *)subscriptions
{
  if ( [subscriptions count]>0 ) {
    
    NSString *subscriptionString = [subscriptions componentsJoinedByString:@","];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_buddy WHERE subscription IN (%@);", subscriptionString];
    
    return [_database executeQuery:sql];
    
  }
  return nil;
}



#pragma mark - Accessors

- (NSString *)passport
{
  return _passport;
}

- (NSString *)password
{
  return _password;
}


- (TKDatabase *)database
{
  return _database;
}


- (Client *)client
{
  return _client;
}

- (RosterManager *)rosterManager
{
  if ( _client ) {
    return _client->rosterManager();
  }
  return NULL;
}


- (TMConnectionHandler *)connectionHandler
{
  return _connectionHandler;
}

- (TMRosterHandler *)rosterHandler
{
  return _rosterHandler;
}


#pragma mark - TKObserverProtocol

- (NSArray *)observers
{
  if ( _observers == nil ) {
    _observers = TKCreateWeakMutableArray();
  }
  return _observers;
}

- (id)addObserver:(id)observer
{
  if ( _observers == nil ) {
    _observers = TKCreateWeakMutableArray();
  }
  return [_observers addUnidenticalObjectIfNotNil:observer];
}

- (void)removeObserver:(id)observer
{
  [_observers removeObjectIdenticalTo:observer];
}

- (void)removeAllObservers
{
  [_observers removeAllObjects];
}



#pragma mark - Connection routines

- (void)connectionBody:(NSValue *)value
{
  @autoreleasepool {
    
    Client *client = (Client *)[value pointerValue];
    
    if ( client->connect( false ) ) {
      while ( !_cancelled ) {
        client->recv( 1000000 );
      }
      
      client->disconnect();
    }
    
  }
}

+ (NSThread *)engineThread
{
  static NSThread *thread = nil;
  
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    thread = [[NSThread alloc] initWithTarget:self
                                     selector:@selector(threadBody:)
                                       object:nil];
    [thread start];
  });
  
  return thread;
}

+ (void)threadBody:(id)object
{
  while ( YES ) {
    @autoreleasepool {
      [[NSRunLoop currentRunLoop] run];
    }
  }
}

@end
