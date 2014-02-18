//
//  RSBadgeView.m
//  Teemo
//
//  Created by Wu Kevin on 2/17/14.
//  Copyright (c) 2014 xbcx. All rights reserved.
//

#import "RSBadgeView.h"

@implementation RSBadgeView

- (id)init
{
  self = [super init];
  if (self) {
    
    _textLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:8.0]
                              textColor:[UIColor blackColor]
                        backgroundColor:[UIColor clearColor]
                          textAlignment:NSTextAlignmentCenter
                          lineBreakMode:NSLineBreakByTruncatingTail
              adjustsFontSizeToFitWidth:NO
                          numberOfLines:1];
    [self addSubview:_textLabel];
    
    _edgeInsets = UIEdgeInsetsMake(2.0, 4.0, 3.0, 4.0);
    
    
    self.image = [TBCreateImage(@"badge.png") resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 7.0, 3.0, 7.0)];
    
  }
  return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
  if ( [_textLabel.text length]>0 ) {
    CGSize textSize = [_textLabel.text sizeWithFont:_textLabel.font];
    return CGSizeMake( MAX(self.image.size.width, textSize.width+_edgeInsets.left+_edgeInsets.right), self.image.size.height);
  }
  return self.image.size;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  [_textLabel sizeToFit];
  [_textLabel moveToCenterOfSuperview];
  
}

@end
