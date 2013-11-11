//
//  TMEngine.h
//  Teemo
//
//  Created by Wu Kevin on 11/5/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TMConfig.h"

#include <gloox/client.h>
#include <gloox/vcardmanager.h>

#import "TMConnectionListener.h"

using namespace gloox;


@interface TMEngine : NSObject {
  Client *_client;
  TMConnectionListener *_connectionListener;
  
  
  VCardManager *_vcardManager;
  
  
  
  BOOL _cancelled;
}

+ (TMEngine *)sharedEngine;
+ (void)storeEngine:(TMEngine *)engine;


- (void)setUpWithUID:(NSString *)uid password:(NSString *)password;
- (BOOL)connect;
- (void)disConnect;

- (Client *)client;
- (TMConnectionListener *)connectionListener;

@end
