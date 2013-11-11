//
//  TTRoutines.m
//  Teemo
//
//  Created by Wu Kevin on 11/8/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "TTRoutines.h"

UIImage *TTCreateImage(NSString *name)
{
  NSString *path = TKPathForBundleResource(nil, name);
  return [[UIImage alloc] initWithContentsOfFile:path];
}

void TTDisplayMessage(NSString *message)
{
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ttl"
                                                      message:message
                                                     delegate:nil
                                            cancelButtonTitle:@"ccl"
                                            otherButtonTitles:@"oth", nil];
  [alertView show];
}
