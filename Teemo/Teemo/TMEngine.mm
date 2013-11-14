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


using namespace std;
using namespace gloox;


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
  if ( _cancelled ) {
    return NO;
  }
  
  if ( ! (_client->connect( false )) ) {
    return NO;
  }
  
  [self performSelector:@selector(monitorClient:)
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



- (NSString *)passport
{
  return _passport;
}

- (NSString *)password
{
  return _password;
}


- (Client *)client
{
  return _client;
}

- (VCardManager *)vcardManager
{
  return _vcardManager;
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

- (RosterManager *)rosterManager
{
  return _client->rosterManager();
}




- (void)monitorClient:(NSValue *)value
{
  @autoreleasepool {
    
    Client *client = (Client *)[value pointerValue];
    
    while ( !_cancelled ) {
      client->recv( 1000000 );
    }
    
    client->disconnect();
    
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
