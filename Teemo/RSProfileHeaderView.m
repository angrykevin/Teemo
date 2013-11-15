//
//  RSProfileHeaderView.m
//  Teemo
//
//  Created by Wu Kevin on 11/15/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSProfileHeaderView.h"
#import <SDWebImage/UIButton+WebCache.h>

@implementation RSProfileHeaderView

- (id)init
{
  self = [super init];
  if (self) {
    
    self.backgroundColor = [UIColor clearColor];
    
    
    _photoButton = [[UIButton alloc] init];
    _photoButton.layer.cornerRadius = 4.0;
    _photoButton.clipsToBounds = YES;
    [self addSubview:_photoButton];
    
    _jidLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14.0]
                             textColor:[UIColor darkGrayColor]
                       backgroundColor:[UIColor clearColor]
                         textAlignment:NSTextAlignmentLeft
                         lineBreakMode:NSLineBreakByTruncatingTail
             adjustsFontSizeToFitWidth:NO
                         numberOfLines:1];
    [self addSubview:_jidLabel];
    
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  _photoButton.frame = CGRectMake(20.0, self.height - 10.0 - 80.0, 80.0, 80.0);
  
  _jidLabel.frame = CGRectMake(_photoButton.rightX + 10.0, self.height - 10.0 - 30.0,
                               190.0, 30.0);
}

- (CGSize)sizeThatFits:(CGSize)size
{
  return CGSizeMake(320.0, 110.0);
}

- (void)dealloc
{
  [_photoButton cancelCurrentImageLoad];
}


- (void)loadPhoto:(NSString *)photo
{
  [_photoButton cancelCurrentImageLoad];
  
  if ( [photo length] > 0 ) {
    [_photoButton setImageWithURL:[NSURL URLWithString:photo]
                         forState:UIControlStateNormal];
  } else {
    _photoButton.normalImage = nil;
  }
}

@end
