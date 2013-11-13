//
//  TTRoutines.h
//  Teemo
//
//  Created by Wu Kevin on 11/8/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif


UIImage *TTCreateImage(NSString *name);

void TTDisplayMessage(NSString *message);
  
NSString *TTFormatDate(NSDate *date);


#ifdef __cplusplus
}
#endif
