//
//  TMCommon.h
//  Teemo
//
//  Created by Wu Kevin on 11/5/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>


#define OBJCSTR(__str) [NSString stringWithUTF8String:__str.c_str()]
#define CPPSTR(__str) string([__str UTF8String])


#ifdef __cplusplus
extern "C" {
#endif


NSString *TMJIDFromPassport(NSString *pspt);

void TMInitiateTeemo();

void TMSetupContextForAccount(NSString *pspt);
void TMDeleteContextByAccount(NSString *pspt);
TKDatabase *TMCreateDatabaseForAccount(NSString *pspt);


#ifdef __cplusplus
}
#endif
