//
//  TMEngine.m
//  Teemo
//
//  Created by Wu Kevin on 11/5/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "TMEngine.h"

#import "TMConfig.h"
#import "TMMacro.h"
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
  _client->registerConnectionListener( _connectionHandler );
  
  _presenceHandler = new TMPresenceHandler;
  _client->registerPresenceHandler( _presenceHandler );
  
  _vcardManager = new VCardManager( _client );
  _vcardHandler = new TMVCardHandler;
  
  _rosterHandler = new TMRosterHandler;
  _client->rosterManager()->registerRosterListener( _rosterHandler );
  
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

- (void)removeAllObservers
{
  _connectionHandler->removeAllObservers();
}


- (NSArray *)toBuddies
{
  NSMutableString *subscriptionTypeString = [[NSMutableString alloc] init];
  [subscriptionTypeString appendFormat:@"%d", S10nTo];
  [subscriptionTypeString appendFormat:@",%d", S10nToIn];
  [subscriptionTypeString appendFormat:@",%d", S10nBoth];
  
  NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_buddy WHERE subscription IN (%@);", subscriptionTypeString];
  return [_database executeQuery:sql];
}

- (NSArray *)fromBuddies
{
  NSMutableString *subscriptionTypeString = [[NSMutableString alloc] init];
  [subscriptionTypeString appendFormat:@"%d", S10nFrom];
  [subscriptionTypeString appendFormat:@",%d", S10nFromOut];
  [subscriptionTypeString appendFormat:@",%d", S10nBoth];
  
  NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_buddy WHERE subscription IN (%@);", subscriptionTypeString];
  return [_database executeQuery:sql];
}

- (NSArray *)inBuddies
{
  NSMutableString *subscriptionTypeString = [[NSMutableString alloc] init];
  [subscriptionTypeString appendFormat:@"%d", S10nNoneIn];
  [subscriptionTypeString appendFormat:@",%d", S10nNoneOutIn];
  [subscriptionTypeString appendFormat:@",%d", S10nToIn];
  
  NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_buddy WHERE subscription IN (%@);", subscriptionTypeString];
  return [_database executeQuery:sql];
}

- (NSArray *)outBuddies
{
  NSMutableString *subscriptionTypeString = [[NSMutableString alloc] init];
  [subscriptionTypeString appendFormat:@"%d", S10nNoneOut];
  [subscriptionTypeString appendFormat:@",%d", S10nNoneOutIn];
  [subscriptionTypeString appendFormat:@",%d", S10nFromOut];
  
  NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_buddy WHERE subscription IN (%@);", subscriptionTypeString];
  return [_database executeQuery:sql];
}



- (BOOL)isCurrentUser:(NSString *)jid
{
  return ( ([jid length]>0) && [jid isEqualToString:TMJIDFromPassport(_passport)] );
}




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
  if ( _database == nil ) {
    _database = [[TKDatabase alloc] init];
    _database.path = TKPathForDocumentsResource(@"imdb.db");
    [_database open];
  }
  return _database;
}


- (Client *)client
{
  return _client;
}

- (VCardManager *)vcardManager
{
  return _vcardManager;
}

- (RosterManager *)rosterManager
{
  return _client->rosterManager();
}


- (TMConnectionHandler *)connectionHandler
{
  return _connectionHandler;
}

- (TMPresenceHandler *)presenceHandler
{
  return _presenceHandler;
}

- (TMVCardHandler *)vcardHandler
{
  return _vcardHandler;
}

- (TMRosterHandler *)rosterHandler
{
  return _rosterHandler;
}






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
