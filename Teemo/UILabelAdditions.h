//
//  UILabelAdditions.h
//  Teemo
//
//  Created by Wu Kevin on 9/4/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Initialization)

+ (id)labelWithFont:(UIFont *)font
          textColor:(UIColor *)textColor
    backgroundColor:(UIColor *)backgroundColor
      textAlignment:(NSTextAlignment)textAlignment
      lineBreakMode:(NSLineBreakMode)lineBreakMode
adjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth
      numberOfLines:(NSInteger)numberOfLines;

@end
