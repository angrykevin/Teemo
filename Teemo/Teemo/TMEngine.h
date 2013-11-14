//
//  TMEngine.h
//  Teemo
//
//  Created by Wu Kevin on 11/5/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <gloox/client.h>
#include <gloox/vcardmanager.h>

#import "TMConnectionHandler.h"
#import "TMPresenceHandler.h"
#import "TMVCardHandler.h"
#import "TMRosterHandler.h"

using namespace gloox;


@interface TMEngine : NSObject {
  
  NSString *_passport;
  NSString *_password;
  
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



- (NSString *)passport;
- (NSString *)password;

- (Client *)client;
- (VCardManager *)vcardManager;

- (TMConnectionHandler *)connectionHandler;
- (TMPresenceHandler *)presenceHandler;
- (TMVCardHandler *)vcardHandler;
- (RosterManager *)rosterManager;

@end
