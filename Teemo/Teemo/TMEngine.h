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

using namespace gloox;


@interface TMEngine : NSObject {
  Client *_client;
  VCardManager *_vcardManager;
  
  
  
  BOOL _cancelled;
}

- (void)setUpWithUID:(NSString *)uid password:(NSString *)password;
- (BOOL)connect;
- (void)disConnect;

- (Client *)client;

@end
