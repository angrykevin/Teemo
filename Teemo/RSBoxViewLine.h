//
//  RSBoxViewLine.h
//  Teemo
//
//  Created by Wu Kevin on 11/8/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RSBoxViewLine : UIView {
  UIImageView *_backgroundImageView;
  
  UIImageView *_imageView;
  UILabel *_label;
  TBTextField *_textField;
}

@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UILabel *label;
@property (nonatomic, strong, readonly) TBTextField *textField;

@end
