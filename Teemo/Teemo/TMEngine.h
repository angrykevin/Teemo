//
//  TMEngine.h
//  Teemo
//
//  Created by Wu Kevin on 11/5/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <gloox/client.h>

#include "TMConnectionHandler.h"
#include "TMPresenceHandler.h"
#include "TMVCardHandler.h"
#include "TMRosterHandler.h"

using namespace gloox;


@interface TMEngine : NSObject {
  
  NSString *_passport;
  NSString *_password;
  
  TKDatabase *_database;
  
  Client *_client;
  VCardManager *_vcardManager;
  //RosterManager *_rosterManager;
  
  TMConnectionHandler *_connectionHandler;
  TMPresenceHandler *_presenceHandler;
  TMVCardHandler *_vcardHandler;
  TMRosterHandler *_rosterHandler;
  
  
  BOOL _cancelled;
}

+ (TMEngine *)sharedEngine;
+ (void)storeEngine:(TMEngine *)engine;
+ (void)clearStoredEngine;


- (void)setUpWithPassport:(NSString *)passport password:(NSString *)password;
- (BOOL)connect;
- (void)disconnect;
- (void)removeAllObservers;

- (void)createDatabase;
- (void)setUpDatabase;
- (void)clearDatabase;


- (NSArray *)toBuddies;
- (NSArray *)fromBuddies;
- (NSArray *)inBuddies;
- (NSArray *)outBuddies;

- (BOOL)isCurrentUser:(NSString *)jid;


- (NSString *)passport;
- (NSString *)password;

- (TKDatabase *)database;

- (Client *)client;
- (VCardManager *)vcardManager;
- (RosterManager *)rosterManager;

- (TMConnectionHandler *)connectionHandler;
- (TMPresenceHandler *)presenceHandler;
- (TMVCardHandler *)vcardHandler;
- (TMRosterHandler *)rosterHandler;

@end
