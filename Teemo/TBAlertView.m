//
//  TBAlertView.m
//  Teemo
//
//  Created by Wu Kevin on 11/15/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "TBAlertView.h"

@implementation TBAlertView

- (id)initWithMessage:(NSString *)message
{
  self = [super initWithTitle:message
                      message:nil
                     delegate:nil
            cancelButtonTitle:nil
            otherButtonTitles:nil];
  if (self) {
    self.delegate = self;
    
    _blockDictionary = [[NSMutableDictionary alloc] init];
    
  }
  return self;
}

- (NSInteger)addButtonWithTitle:(NSString *)title block:(TBAlertViewBlock)block
{
  if ( [title length] > 0 ) {
    
    int index = [self addButtonWithTitle:title];
    
    if ( block ) {
      [_blockDictionary setObject:[block copy] forKey:title];
    }
    
    return index;
    
  }
  
  return -1;
}

- (NSInteger)addCancelButtonWithTitle:(NSString *)title block:(TBAlertViewBlock)block
{
  int index = [self addButtonWithTitle:title block:block];
  
  [self setCancelButtonIndex:index];
  
  return index;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  NSString *title = [self buttonTitleAtIndex:buttonIndex];
  TBAlertViewBlock block = [_blockDictionary objectForKey:title];
  if ( block ) {
    block();
  }
}

@end
