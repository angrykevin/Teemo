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
#include <gloox/client.h>

#include "TMConnectionHandler.h"
#include "TMRosterHandler.h"
#include "TMVCardHandler.h"
#include "TMMessageHandler.h"


using namespace gloox;
using namespace std;



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



- (void)setupWithPassport:(NSString *)passport password:(NSString *)password
{
  NSAssert([passport length]>0, @"passport error");
  NSAssert([password length]>0, @"password error");
  
  _passport = [passport copy];
  _password = [password copy];
  _context = [[TMAccountContext alloc] initWithPassport:_passport];
  
  _cancelled = NO;
  
  string jid = CPPSTR(TMJIDFromPassport(passport));
  string pwd = CPPSTR(password);
  string svr = CPPSTR(TMXMPPServerHost);
  int prt = [TMXMPPServerPort intValue];
  
  Client *client = new Client( JID( jid ), pwd );
  client->setServer( svr );
  client->setPort( prt );
  client->setResource( CPPSTR(TMXMPPClientResource) );
  _client = client;
  
  TMConnectionHandler *connectionHandler = new TMConnectionHandler;
  connectionHandler->setEngine((__bridge void *)self);
  client->registerConnectionListener(connectionHandler);
  _connectionHandler = connectionHandler;
  
  TMRosterHandler *rosterHandler = new TMRosterHandler;
  rosterHandler->setEngine((__bridge void *)self);
  client->rosterManager()->registerRosterListener(rosterHandler);
  _rosterHandler = rosterHandler;
  
  VCardManager *vcardManager = new VCardManager( client );
  TMVCardHandler *vcardHandler = new TMVCardHandler;
  vcardHandler->setEngine((__bridge void *)self);
  _vcardHandler = vcardHandler;
  _vcardManager = vcardManager;
  
  TMMessageSessionHandler *messageSessionHandler = new TMMessageSessionHandler;
  messageSessionHandler->setEngine((__bridge void *)self);
  client->registerMessageSessionHandler(messageSessionHandler);
  _messageSessionHandler = messageSessionHandler;
  
  _messageHandlerDictionary = [[NSMutableDictionary alloc] init];
  
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
    
    return [[self database] executeQuery:sql];
    
  }
  return nil;
}


- (void)requestVCard:(NSString *)jid
{
  if ( [jid length]<=0 ) {
    return;
  }
  
  if ( _vcardManager ) {
    VCardManager *vcardManager = (VCardManager *)_vcardManager;
    VCardHandler *vcardHandler = (VCardHandler *)_vcardHandler;
    vcardManager->fetchVCard(JID(CPPSTR(jid)), vcardHandler);
  }
}

- (void)storeVCard:(NSDictionary *)vcard
{
  if ( [vcard count]<=0 ) {
    return;
  }
  
  NSString *value = nil;
  
  value = [vcard objectForKey:@"nickname"];
  NSString *nickname = ([value length]>0) ? value : @"";
  
  value = [vcard objectForKey:@"familyname"];
  NSString *familyname = ([value length]>0) ? value : @"";
  
  value = [vcard objectForKey:@"givenname"];
  NSString *givenname = ([value length]>0) ? value : @"";
  
  value = [vcard objectForKey:@"photo"];
  NSString *photo = ([value length]>0) ? value : @"";
  
  value = [vcard objectForKey:@"birthday"];
  NSString *birthday = ([value length]>0) ? value : @"";
  
  value = [vcard objectForKey:@"desc"];
  NSString *desc = ([value length]>0) ? value : @"";
  
  value = [vcard objectForKey:@"homepage"];
  NSString *homepage = ([value length]>0) ? value : @"";
  
  value = [vcard objectForKey:@"note"];
  NSString *note = ([value length]>0) ? value : @"";
  
  
  VCard *tmp = new VCard;
  tmp->setNickname(CPPSTR(nickname));
  tmp->setName(CPPSTR(familyname), CPPSTR(givenname));
  tmp->setPhotoUri(CPPSTR(photo));
  tmp->setBday(CPPSTR(birthday));
  tmp->setDesc(CPPSTR(desc));
  tmp->setUrl(CPPSTR(homepage));
  tmp->setNote(CPPSTR(note));
  
  if ( _vcardManager) {
    VCardManager *vcardManager = (VCardManager *)_vcardManager;
    VCardHandler *vcardHandler = (VCardHandler *)_vcardHandler;
    vcardManager->storeVCard(tmp, vcardHandler);
  }
  
}



- (void)addBuddy:(NSString *)jid message:(NSString *)message
{
  if ( [jid length]<=0 ) {
    return;
  }
  
  if ( [self rosterManager] ) {
    RosterManager *rosterManager = (RosterManager *)[self rosterManager];
    rosterManager->subscribe(JID(CPPSTR(jid)));
  }
  
  if ( _client ) {
    if ( [message length]>0 ) {
      Client *client = (Client *)_client;
      Message msg(Message::Chat, JID(CPPSTR(jid)), CPPSTR(message));
      client->send(msg);
    }
  }
  
}

- (void)removeBuddy:(NSString *)jid
{
  if ( [jid length]<=0 ) {
    return;
  }
  
  if ( [self rosterManager] ) {
    RosterManager *rosterManager = (RosterManager *)[self rosterManager];
    rosterManager->remove(JID(CPPSTR(jid)));
    rosterManager->unsubscribe(JID(CPPSTR(jid)));
  }
  
}

- (void)authorizeBuddy:(NSString *)jid
{
  if ( [jid length]<=0 ) {
    return;
  }
  
  if ( [self rosterManager] ) {
    RosterManager *rosterManager = (RosterManager *)[self rosterManager];
    rosterManager->ackSubscriptionRequest(JID(CPPSTR(jid)), YES);
  }
}

- (void)declineBuddy:(NSString *)jid
{
  if ( [jid length]<=0 ) {
    return;
  }
  
  if ( [self rosterManager] ) {
    RosterManager *rosterManager = (RosterManager *)[self rosterManager];
    rosterManager->ackSubscriptionRequest(JID(CPPSTR(jid)), YES);
  }
}


- (void)sendTextMessage:(NSString *)jid message:(NSString *)message
{
  if ( ([jid length]<=0) || ([message length]<=0)) {
    return;
  }
  
  if ( _client ) {
    Client *client = (Client *)_client;
    Message msg(Message::Chat, JID(CPPSTR(jid)), CPPSTR(message));
    client->send(msg);
  }
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

- (TMAccountContext *)context
{
  return _context;
}

- (TKDatabase *)database
{
  return _context.database;
}


- (void *)client
{
  return _client;
}

- (void *)rosterManager
{
  if ( _client ) {
    Client *client = (Client *)_client;
    return client->rosterManager();
  }
  return NULL;
}

- (void *)vcardManager
{
  return _vcardManager;
}


- (void *)connectionHandler
{
  return _connectionHandler;
}

- (void *)rosterHandler
{
  return _rosterHandler;
}

- (void *)vcardHandler
{
  return _vcardHandler;
}

- (void *)messageSessionHandler
{
  return _messageSessionHandler;
}

- (void *)messageHandlerForJid:(NSString *)jid
{
  NSValue *value = [_messageHandlerDictionary objectForKey:jid];
  if ( value ) {
    return [value pointerValue];
  }
  return NULL;
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
