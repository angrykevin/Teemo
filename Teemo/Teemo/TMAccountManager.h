//
//  TMAccountManager.h
//  Teemo
//
//  Created by Wu Kevin on 2/10/14.
//  Copyright (c) 2014 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TMAccountItem;


@interface TMAccountManager : NSObject {
  NSArray *_accountList;
}

@property (nonatomic, strong, readonly) NSArray *accountList;

+ (TMAccountManager *)shareObject;

- (void)addAccountWithPassport:(NSString *)pspt password:(NSString *)pswd info:(id)info;
- (void)removeAccountByPassport:(NSString *)pspt;
- (TMAccountItem *)accountForPassport:(NSString *)pspt;
- (BOOL)hasAccount;
- (void)synchronize;

@end


@interface TMAccountItem : NSObject {
  NSString *_passport;
  NSString *_password;
  id _info;
}

@property (nonatomic, copy) NSString *passport;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) id info;

- (BOOL)isComplete;

@end
