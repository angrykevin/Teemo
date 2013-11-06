//
//  TMCommon.m
//  TestGlx
//
//  Created by Wu Kevin on 11/5/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "TMCommon.h"
#import "TMConfig.h"


NSString *TMJIDFromUID(NSString *uid)
{
  if ( [uid length] > 0 ) {
    NSMutableString *jid = [[NSMutableString alloc] init];
    [jid appendString:uid];
    [jid appendString:TMXMPPServerDomain];
    if ( [TMXMPPClientResource length] > 0 ) {
      [jid appendFormat:@"/%@", TMXMPPServerDomain];
    }
    return jid;
  }
  return nil;
}
