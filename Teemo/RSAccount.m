//
//  RSAccount.m
//  Teemo
//
//  Created by Wu Kevin on 11/13/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSAccount.h"

BOOL RSHasAccount()
{
  NSString *pspt = RSAccountPassport();
  NSString *pswd = RSAccountPassword();
  
  return ( TKIsStringWithText(pspt) && TKIsStringWithText(pswd) );
}

NSString *RSAccountPassport()
{
  return [[TKSettings sharedObject] objectForKey:RSSavedPassportKey];
}

NSString *RSAccountPassword()
{
  return [[TKSettings sharedObject] objectForKey:RSSavedPasswordKey];
}

void RSSaveAccountPassport(NSString *pspt)
{
  [[TKSettings sharedObject] setObject:pspt forKey:RSSavedPassportKey];
  [[TKSettings sharedObject] synchronize];
}

void RSSaveAccountPassword(NSString *pswd)
{
  [[TKSettings sharedObject] setObject:pswd forKey:RSSavedPasswordKey];
  [[TKSettings sharedObject] synchronize];
}
