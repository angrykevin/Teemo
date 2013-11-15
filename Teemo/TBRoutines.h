//
//  TBRoutines.h
//  Teemo
//
//  Created by Wu Kevin on 11/8/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif


UIImage *TBCreateImage(NSString *name);

void TBDisplayMessage(NSString *message);
  
NSString *TBFormatDate(NSDate *date);
  
NSString *TBBuildFullName(NSString *givenname, NSString *familyname);


#ifdef __cplusplus
}
#endif
