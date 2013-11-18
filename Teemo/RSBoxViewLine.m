//
//  RSBoxViewLine.m
//  Teemo
//
//  Created by Wu Kevin on 11/8/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSBoxViewLine.h"

@implementation RSBoxViewLine

- (id)init
{
  self = [super init];
  if (self) {
    
    _backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_backgroundImageView];
    
    
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_imageView];
    
    _label = [UILabel labelWithFont:[UIFont boldSystemFontOfSize:14.0]
                          textColor:[UIColor blackColor]
                    backgroundColor:[UIColor clearColor]
                      textAlignment:NSTextAlignmentRight
                      lineBreakMode:NSLineBreakByClipping
          adjustsFontSizeToFitWidth:NO
                      numberOfLines:1];
    [self addSubview:_label];
    
    _textField = [[UITextField alloc] init];
    _textField.font = [UIFont systemFontOfSize:14.0];
    _textField.adjustsFontSizeToFitWidth = NO;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self addSubview:_textField];
    
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  _backgroundImageView.frame = self.bounds;
  
  
  if ( _imageView.image ) {
    _imageView.frame = CGRectMake(10.0, 2.0, 40.0, 40.0);
  } else {
    _imageView.frame = CGRectMake(5.0, 2.0, 0.0, 0.0);
  }
  
  _label.frame = CGRectMake(_imageView.rightX + 5.0, 2.0, 90.0, 40.0);
  _textField.frame = CGRectMake(_label.rightX + 5.0, 2.0,
                                (self.width - 10.0) - (_label.rightX + 5.0), 40.0);
  
}

@end
