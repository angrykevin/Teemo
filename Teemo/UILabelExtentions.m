//
//  UILabelExtentions.m
//  Teemo
//
//  Created by Wu Kevin on 9/4/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "UILabelExtentions.h"

@implementation UILabel (Extentions)

+ (id)labelWithFont:(UIFont *)font
          textColor:(UIColor *)textColor
      textAlignment:(NSTextAlignment)textAlignment
      numberOfLines:(NSInteger)numberOfLines
    backgroundColor:(UIColor *)backgroundColor
      lineBreakMode:(NSLineBreakMode)lineBreakMode
{
  UILabel *label = [[UILabel alloc] init];
  label.font = font;
  label.textColor = textColor;
  label.textAlignment = textAlignment;
  label.numberOfLines = numberOfLines;
  label.backgroundColor = backgroundColor;
  label.lineBreakMode = lineBreakMode;
  label.adjustsFontSizeToFitWidth = NO;
  return label;
}

@end
