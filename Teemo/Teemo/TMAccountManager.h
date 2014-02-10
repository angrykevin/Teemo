//
//  TMAccountManager.h
//  Teemo
//
//  Created by Wu Kevin on 2/10/14.
//  Copyright (c) 2014 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMAccountManager : NSObject {
  NSMutableArray *_accountList;
}

@property (nonatomic, strong, readonly) NSMutableArray *accountList;

+ (TMAccountManager *)shareObject;


@end


@interface TMAccountItem : NSObject {
  NSString *_passport;
  NSString *_password;
  id _info;
}

@property (nonatomic, copy) NSString *passport;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) id info;

@end
