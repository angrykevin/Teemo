//
//  TMEngine.h
//  Teemo
//
//  Created by Wu Kevin on 11/5/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <gloox/client.h>
#include <gloox/rostermanager.h>

#include "TMConnectionHandler.h"
#include "TMRosterHandler.h"

using namespace gloox;
using namespace std;


@interface TMEngine : NSObject<
    TKObserverProtocol
> {
  
  NSString *_passport;
  NSString *_password;
  
  TKDatabase *_database;
  
  Client *_client;
  //RosterManager *_rosterManager;
  
  TMConnectionHandler *_connectionHandler;
  TMRosterHandler *_rosterHandler;
  
  
  NSMutableArray *_observers;
  
  BOOL _cancelled;
}

+ (TMEngine *)sharedEngine;
+ (void)storeEngine:(TMEngine *)engine;
+ (void)clearStoredEngine;


- (void)setUpWithPassport:(NSString *)passport password:(NSString *)password;
- (BOOL)connect;
- (void)disconnect;

- (NSArray *)buddiesForSubscriptions:(NSArray *)subscriptions;



- (NSString *)passport;
- (NSString *)password;

- (TKDatabase *)database;

- (Client *)client;
- (RosterManager *)rosterManager;

- (TMConnectionHandler *)connectionHandler;
- (TMRosterHandler *)rosterHandler;

@end



@protocol TMEngineDelegate <NSObject>

@optional

// ConnectionHandler
- (void)engineConnectionOnConnect:(TMEngine *)engine;
- (void)engine:(TMEngine *)engine connectionOnDisconnect:(ConnectionError)error;
- (void)engine:(TMEngine *)engine connectionOnResourceBind:(const std::string &)resource;
- (void)engine:(TMEngine *)engine connectionOnResourceBindError:(const Error *)error;
- (void)engine:(TMEngine *)engine connectionOnSessionCreateError:(const Error *)error;
- (bool)engine:(TMEngine *)engine connectionOnTLSConnect:(const CertInfo &)info;
- (void)engine:(TMEngine *)engine connectionOnStreamEvent:(StreamEvent)event;

// Roster
- (void)engine:(TMEngine *)engine handleItemAdded:(const JID &)jid;
- (void)engine:(TMEngine *)engine handleItemSubscribed:(const JID &)jid;
- (void)engine:(TMEngine *)engine handleItemRemoved:(const JID &)jid;
- (void)engine:(TMEngine *)engine handleItemUpdated:(const JID &)jid;
- (void)engine:(TMEngine *)engine handleItemUnsubscribed:(const JID &)jid;
- (void)engine:(TMEngine *)engine handleRoster:(const Roster &)roster;
- (void)engine:(TMEngine *)engine
    handleRosterPresence:(const RosterItem &)item
    resource:(const std::string &)resource
    presence:(Presence::PresenceType)presence
    msg:(const std::string &)msg;
- (void)engine:(TMEngine *)engine
    handleSelfPresence:(const RosterItem &)item
    resource:(const std::string &)resource
    presence:(Presence::PresenceType)presence
    msg:(const std::string &)msg;
- (bool)engine:(TMEngine *)engine handleSubscriptionRequest:(const JID &)jid msg:(const std::string &)msg;
- (bool)engine:(TMEngine *)engine handleUnsubscriptionRequest:(const JID &)jid msg:(const std::string &)msg;
- (void)engine:(TMEngine *)engine handleNonrosterPresence:(const Presence &)presence;
- (void)engine:(TMEngine *)engine handleRosterError:(const IQ &)iq;

@end

