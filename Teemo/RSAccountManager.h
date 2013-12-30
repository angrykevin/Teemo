//
//  RSAccountManager.h
//  Teemo
//
//  Created by Wu Kevin on 12/30/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSAccountManager : NSObject {
}

+ (RSAccountManager *)sharedObject;

@property (nonatomic, copy) NSString *passport;
@property (nonatomic, copy) NSString *password;

- (BOOL)hasAccount;
- (void)synchronize;

@end
