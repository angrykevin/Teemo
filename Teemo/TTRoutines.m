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
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:message
                                                      message:nil
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"确定", @"")
                                            otherButtonTitles:nil];
  [alertView show];
}
