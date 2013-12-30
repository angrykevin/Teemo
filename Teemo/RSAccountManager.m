//
//  RSAccountManager.m
//  Teemo
//
//  Created by Wu Kevin on 12/30/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSAccountManager.h"

@implementation RSAccountManager

+ (RSAccountManager *)sharedObject
{
  static RSAccountManager *AccountManager = nil;
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    AccountManager = [[self alloc] init];
  });
  return AccountManager;
}

@end
