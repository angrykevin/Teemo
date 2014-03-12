//
//  TBCommon.h
//  Teemo
//
//  Created by Wu Kevin on 12/19/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void (^TBOperationCompletionHandler)(id result, NSError *error);


#ifdef __cplusplus
extern "C" {
#endif


UIImage *TBCreateImage(NSString *name);
UIColor *TBColorWithRGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);

void TBPresentSystemMessage(NSString *message);

NSString *TBFormatDate(NSDate *date);

NSString *TBBuildFullname(NSString *givenname, NSString *familyname);


#ifdef __cplusplus
}
#endif
