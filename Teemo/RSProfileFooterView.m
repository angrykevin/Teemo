//
//  RSProfileFooterView.m
//  Teemo
//
//  Created by Wu Kevin on 11/15/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSProfileFooterView.h"

@implementation RSProfileFooterView

- (id)init
{
  self = [super init];
  if (self) {
    
    self.backgroundColor = [UIColor clearColor];
    
    _deleteButton = [[UIButton alloc] init];
    _deleteButton.normalTitle = NSLocalizedString(@"Delete", @"");
    _deleteButton.normalBackgroundImage = [TBCreateImage(@"button_large_black.png") resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 5.0, 10.0, 5.0)];
    [self addSubview:_deleteButton];
    
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  _deleteButton.frame = CGRectMake(10.0, 10.0, 300.0, 43.0);
  
}

- (CGSize)sizeThatFits:(CGSize)size
{
  return CGSizeMake(320.0, 63.0);
}

@end
