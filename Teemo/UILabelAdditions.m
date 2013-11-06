//
//  UILabelAdditions.m
//  Teemo
//
//  Created by Wu Kevin on 9/4/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "UILabelAdditions.h"

@implementation UILabel (Initialization)

+ (id)labelWithFont:(UIFont *)font
          textColor:(UIColor *)textColor
    backgroundColor:(UIColor *)backgroundColor
      textAlignment:(NSTextAlignment)textAlignment
      lineBreakMode:(NSLineBreakMode)lineBreakMode
adjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth
      numberOfLines:(NSInteger)numberOfLines
{
  UILabel *label = [[UILabel alloc] init];
  label.font = font;
  label.textColor = textColor;
  label.backgroundColor = backgroundColor;
  label.textAlignment = textAlignment;
  label.lineBreakMode = lineBreakMode;
  label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
  label.numberOfLines = numberOfLines;
  return label;
}

@end
