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

using namespace gloox;
using namespace std;


@interface TMEngine : NSObject<
    TKObserverProtocol
> {
  
  NSString *_passport;
  NSString *_password;
  
  TKDatabase *_database;
  
  Client *_client;
  
  TMConnectionHandler *_connectionHandler;
  
  
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

- (TMConnectionHandler *)connectionHandler;

@end



@protocol TMEngineDelegate <NSObject>

@optional

// ConnectionHandler
- (void)engineConnectionOnConnect:(TMEngine *)engine;
- (void)engine:(TMEngine *)engine connectionOnDisconnect:(ConnectionError)error;
- (void)engine:(TMEngine *)engine connectionOnResourceBind:(NSString *)resource;
- (void)engine:(TMEngine *)engine connectionOnResourceBindError:(const Error *)error;
- (void)engine:(TMEngine *)engine connectionOnSessionCreateError:(const Error *)error;
- (bool)engine:(TMEngine *)engine connectionOnTLSConnect:(const CertInfo &)info;
- (void)engine:(TMEngine *)engine connectionOnStreamEvent:(StreamEvent)event;

@end



