//
//  RSRoutines.mm
//  Teemo
//
//  Created by Wu Kevin on 12/30/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSRoutines.h"
#import "Toolbox.h"
#import "Teemo.h"


BOOL RSHasAccount()
{
  return ( TKIsStringWithText(RSAccountPassport()) && TKIsStringWithText(RSAccountPassword()) );
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
}

void RSSaveAccountPassword(NSString *pswd)
{
  [[TKSettings sharedObject] setObject:pswd forKey:RSSavedPasswordKey];
}

void RSSynchronizeAccountInfo()
{
  [[TKSettings sharedObject] synchronize];
}




UIImage *RSAvatarImageForPresence(UIImage *image, int presence)
{
  UIImage *avatarImage = (image == nil) ? RSDefaultAvatarImage() : image;
  
  if ( (presence == Presence::Available) || (presence == Presence::Chat) ) {
    return avatarImage;
  } else if ( (presence == Presence::Away) || (presence == Presence::XA) ) {
    return avatarImage;
  } else if ( presence == Presence::DND ) {
    return avatarImage;
  } else {
    return [avatarImage grayscale];
  }
}

UIImage *RSAvatarStatusImageForPresence(int presence)
{
  if ( (presence == Presence::Available) || (presence == Presence::Chat) ) {
    return TBCreateImage(@"status_online.png");
  } else if ( (presence == Presence::Away) || (presence == Presence::XA) ) {
    return TBCreateImage(@"status_away.png");
  } else if ( presence == Presence::DND ) {
    return TBCreateImage(@"status_dnd.png");
  }
  return nil;
}

UIImage *RSDefaultAvatarImage()
{
  static UIImage *DefaultAvatarImage = nil;
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    DefaultAvatarImage = TBCreateImage(@"default_avatar.png");
  });
  return DefaultAvatarImage;
}
