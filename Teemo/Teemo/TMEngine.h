//
//  TMEngine.h
//  Teemo
//
//  Created by Wu Kevin on 11/5/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <gloox/client.h>

#import "TMAccountContext.h"

#include "TMConnectionHandler.h"
#include "TMRosterHandler.h"
#include "TMVCardHandler.h"
#include "TMMessageHandler.h"


using namespace gloox;
using namespace std;


@interface TMEngine : NSObject<
    TKObserverProtocol
> {
  
  NSString *_passport;
  NSString *_password;
  TMAccountContext *_context;
  //TKDatabase *_database;
  
  Client *_client;
  //RosterManager *_rosterManager;
  VCardManager *_vcardManager;
  
  TMConnectionHandler *_connectionHandler;
  TMRosterHandler *_rosterHandler;
  TMVCardHandler *_vcardHandler;
  TMMessageSessionHandler *_messageSessionHandler;
  NSMutableDictionary *_messageHandlerDictionary;
  
  
  NSMutableArray *_observers;
  
  BOOL _cancelled;
}

+ (TMEngine *)sharedEngine;
+ (void)storeEngine:(TMEngine *)engine;
+ (void)clearStoredEngine;


- (void)setupWithPassport:(NSString *)passport password:(NSString *)password;
- (BOOL)connect;
- (void)disconnect;

- (NSArray *)buddiesForSubscriptions:(NSArray *)subscriptions;

- (void)requestVCard:(NSString *)jid;
- (void)storeVCard:(NSDictionary *)vcard;

- (void)addBuddy:(NSString *)jid message:(NSString *)message;
- (void)removeBuddy:(NSString *)jid;
- (void)authorizeBuddy:(NSString *)jid;
- (void)declineBuddy:(NSString *)jid;

- (void)sendTextMessage:(NSString *)jid message:(NSString *)message;


- (NSString *)passport;
- (NSString *)password;
- (TMAccountContext *)context;
- (TKDatabase *)database;

- (Client *)client;
- (RosterManager *)rosterManager;
- (VCardManager *)vcardManager;

- (TMConnectionHandler *)connectionHandler;
- (TMRosterHandler *)rosterHandler;
- (TMVCardHandler *)vcardHandler;
- (TMMessageSessionHandler *)messageSessionHandler;
- (TMMessageHandler *)messageHandlerForJid:(NSString *)jid;

@end


@interface TMEngine (PrivateMethods)

- (void)addMessageHandler:(TMMessageHandler *)mh forJid:(NSString *)jid;
- (void)removeMessageHandlerForJid:(NSString *)jid;

@end



@protocol TMEngineDelegate <NSObject>

@optional

// ConnectionHandler
- (void)engineConnectionOnConnect:(TMEngine *)engine;
- (void)engine:(TMEngine *)engine connectionOnDisconnect:(NSError *)error;
- (void)engine:(TMEngine *)engine connectionOnResourceBind:(NSString *)resource;
- (void)engine:(TMEngine *)engine connectionOnResourceBindError:(NSError *)error;
- (void)engine:(TMEngine *)engine connectionOnSessionCreateError:(NSError *)error;

// RosterHandler
- (void)engineHandleRoster:(TMEngine *)engine;
- (void)engine:(TMEngine *)engine handleRosterError:(NSError *)error;
- (void)engine:(TMEngine *)engine handleItemAdded:(NSString *)jid;
- (void)engine:(TMEngine *)engine handleItemRemoved:(NSString *)jid;
- (void)engine:(TMEngine *)engine handleItemUpdated:(NSString *)jid;
- (void)engine:(TMEngine *)engine handleItemSubscribed:(NSString *)jid;
- (void)engine:(TMEngine *)engine handleItemUnsubscribed:(NSString *)jid;
- (void)engine:(TMEngine *)engine handleSubscriptionRequest:(NSString *)jid;
- (void)engine:(TMEngine *)engine handleUnsubscriptionRequest:(NSString *)jid;
- (void)engine:(TMEngine *)engine handlePresence:(NSString *)jid;

// VcardHandler
- (void)engine:(TMEngine *)engine handleVCard:(NSString *)jid;
- (void)engine:(TMEngine *)engine handleFetchVCardResult:(NSString *)jid error:(NSError *)error;
- (void)engine:(TMEngine *)engine handleStoreVCardResult:(NSString *)jid error:(NSError *)error;

@end

