//
//  RSDatabase.h
//  Teemo
//
//  Created by Wu Kevin on 11/13/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif


NSString *RSDatabasePath();
void RSDatabaseCreate();
void RSDatabaseSetUpTables();
void RSDatabaseClearData();


#ifdef __cplusplus
}
#endif
