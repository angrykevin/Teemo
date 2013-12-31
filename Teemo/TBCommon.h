//
//  TBCommon.h
//  Teemo
//
//  Created by Wu Kevin on 12/19/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^TBOperationCompletionHandler)(id result, NSError *error);


#ifdef __cplusplus
extern "C" {
#endif
  
  
UIImage *TBCreateImage(NSString *name);
  
void TBPresentSystemMessage(NSString *message);
  
NSString *TBFormatDate(NSDate *date);
  
NSString *TBBuildFullname(NSString *givenname, NSString *familyname);
  
  
#ifdef __cplusplus
}
#endif
