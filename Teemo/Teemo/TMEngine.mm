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

#include <gloox/message.h>


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
  
  _vcardManager = new VCardManager( _client );
  _vcardHandler = new TMVCardHandler;
  _vcardHandler->setEngine((__bridge void *)self);
  
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
    _vcardManager->fetchVCard(JID(CPPSTR(jid)), _vcardHandler);
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
    _vcardManager->storeVCard(tmp, _vcardHandler);
  }
  
}



- (void)addBuddy:(NSString *)jid message:(NSString *)message
{
  if ( [jid length]<=0 ) {
    return;
  }
  
  if ( [self rosterManager] ) {
    [self rosterManager]->subscribe(JID(CPPSTR(jid)));
  }
  
  if ( _client ) {
    if ( [message length]>0 ) {
      Message msg(Message::Chat, JID(CPPSTR(jid)), CPPSTR(message));
      _client->send(msg);
    }
  }
  
}

- (void)removeBuddy:(NSString *)jid
{
  if ( [jid length]<=0 ) {
    return;
  }
  
  if ( [self rosterManager] ) {
    [self rosterManager]->remove(JID(CPPSTR(jid)));
    [self rosterManager]->unsubscribe(JID(CPPSTR(jid)));
  }
  
}

- (void)authorizeBuddy:(NSString *)jid
{
  if ( [jid length]<=0 ) {
    return;
  }
  
  if ( [self rosterManager] ) {
    [self rosterManager]->ackSubscriptionRequest(JID(CPPSTR(jid)), YES);
  }
}

- (void)declineBuddy:(NSString *)jid
{
  if ( [jid length]<=0 ) {
    return;
  }
  
  if ( [self rosterManager] ) {
    [self rosterManager]->ackSubscriptionRequest(JID(CPPSTR(jid)), YES);
  }
}


- (void)sendTextMessage:(NSString *)jid message:(NSString *)message
{
  if ( ([jid length]<=0) || ([message length]<=0)) {
    return;
  }
  
  if ( _client ) {
    Message msg(Message::Chat, JID(CPPSTR(jid)), CPPSTR(message));
    _client->send(msg);
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

- (VCardManager *)vcardManager
{
  return _vcardManager;
}


- (TMConnectionHandler *)connectionHandler
{
  return _connectionHandler;
}

- (TMRosterHandler *)rosterHandler
{
  return _rosterHandler;
}

- (TMVCardHandler *)vcardHandler
{
  return _vcardHandler;
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
