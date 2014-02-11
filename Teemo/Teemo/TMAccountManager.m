//
//  TMAccountManager.m
//  Teemo
//
//  Created by Wu Kevin on 2/10/14.
//  Copyright (c) 2014 xbcx. All rights reserved.
//

#import "TMAccountManager.h"

@implementation TMAccountManager

+ (TMAccountManager *)shareObject
{
  static TMAccountManager *AccountManager = nil;
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    AccountManager = [[self alloc] init];
  });
  return AccountManager;
}

- (id)init
{
  self = [super init];
  if (self) {
    
    NSString *path = TKPathForDocumentsResource(@"Teemo/accounts.db");
    NSArray *accountList = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if ( [accountList count] > 0 ) {
      _accountList = [[NSMutableArray alloc] initWithArray:accountList];
    }
    
  }
  return self;
}


- (void)addAccountWithPassport:(NSString *)pspt pswd:(NSString *)pswd info:(id)info
{
  if ( [pspt length] <= 0 ) {
    return;
  }
  
  if ( _accountList == nil ) {
    _accountList = [[NSMutableArray alloc] init];
  }
  
  TMAccountItem *item = [_accountList firstObjectForKeyPath:@"passport" equalToValue:pspt];
  if ( item == nil ) {
    item = [[TMAccountItem alloc] init];
  } else {
    [(NSMutableArray *)_accountList removeObject:item];
  }
  
  item.passport = pspt;
  item.password = pswd;
  item.info = info;
  
  [(NSMutableArray *)_accountList insertObject:item atIndex:0];
  
}

- (void)removeAccountByPassport:(NSString *)pspt
{
  if ( [pspt length] <= 0 ) {
    return;
  }
  
  TMAccountItem *item = [_accountList firstObjectForKeyPath:@"passport" equalToValue:pspt];
  if ( item ) {
    [(NSMutableArray *)_accountList removeObject:item];
  }
  
}

- (TMAccountItem *)accountForPassport:(NSString *)pspt
{
  if ( [pspt length] <= 0 ) {
    return nil;
  }
  
  return [_accountList firstObjectForKeyPath:@"passport" equalToValue:pspt];
}

- (void)synchronize
{
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_accountList];
  if ( [data length] > 0 ) {
    NSString *path = TKPathForDocumentsResource(@"Teemo/accounts.db");
    [data writeToFile:path atomically:YES];
  }
}

@end


@implementation TMAccountItem

@synthesize passport = _passport;
@synthesize password = _password;
@synthesize info = _info;

- (id)initWithCoder:(NSCoder *)decoder
{
  self = [super init];
  if ( self ) {
    _passport = [decoder decodeObjectForKey:@"kPassport"];
    _password = [decoder decodeObjectForKey:@"kPassword"];
    _info = [decoder decodeObjectForKey:@"kInfo"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject:_passport forKey:@"kPassport"];
  [encoder encodeObject:_password forKey:@"kPassword"];
  [encoder encodeObject:_info forKey:@"kInfo"];
}

@end
