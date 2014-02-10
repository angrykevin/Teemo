//
//  TMAccountManager.m
//  Teemo
//
//  Created by Wu Kevin on 2/10/14.
//  Copyright (c) 2014 xbcx. All rights reserved.
//

#import "TMAccountManager.h"

@implementation TMAccountManager

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
