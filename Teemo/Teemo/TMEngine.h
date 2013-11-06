//
//  TMEngine.h
//  TestGlx
//
//  Created by Wu Kevin on 11/5/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TMConfig.h"

#include <gloox/client.h>

using namespace gloox;


@interface TMEngine : NSObject {
  Client *_client;
  
  
  
  BOOL _cancelled;
}

- (void)setUpWithUID:(NSString *)uid password:(NSString *)password;
- (BOOL)connect;
- (void)disConnect;

- (Client *)client;

@end
