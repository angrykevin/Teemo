//
//  UILabelExtentions.h
//  Teemo
//
//  Created by Wu Kevin on 9/4/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extentions)

+ (id)simpleLabelWithFont:(UIFont *)font
                textColor:(UIColor *)textColor
            textAlignment:(NSTextAlignment)textAlignment;

+ (id)labelWithFont:(UIFont *)font
          textColor:(UIColor *)textColor
      textAlignment:(NSTextAlignment)textAlignment
      numberOfLines:(NSInteger)numberOfLines
    backgroundColor:(UIColor *)backgroundColor
      lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
