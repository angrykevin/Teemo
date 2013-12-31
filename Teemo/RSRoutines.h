//
//  RSRoutines.h
//  Teemo
//
//  Created by Wu Kevin on 12/30/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifdef __cplusplus
extern "C" {
#endif

#define RSSavedPassportKey @"RSSavedPassportKey"
#define RSSavedPasswordKey @"RSSavedPasswordKey"
  
BOOL RSHasAccount();
NSString *RSAccountPassport();
NSString *RSAccountPassword();
void RSSaveAccountPassport(NSString *pspt);
void RSSaveAccountPassword(NSString *pswd);
void RSSynchronizeAccountInfo();

UIImage *RSAvatarImageForPresence(UIImage *image, int presence);
UIImage *RSAvatarStatusImageForPresence(int presence);
UIImage *RSDefaultAvatarImage();

#ifdef __cplusplus
}
#endif
