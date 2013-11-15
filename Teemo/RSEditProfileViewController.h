//
//  RSEditProfileViewController.h
//  Teemo
//
//  Created by Wu Kevin on 11/15/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^RSEditProfileBlock)(id value);

@interface RSEditProfileViewController : TBViewController<
    UITextFieldDelegate
> {
  UIScrollView *_scrollView;
  
  UIView *_backgroundView;
  UITextField *_textField;
  UILabel *_hintLabel;
  
  NSString *_value;
  NSUInteger _maxLength;
  
  RSEditProfileBlock _completeBlock;
}

@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) NSUInteger maxLength;

@property (nonatomic, copy) RSEditProfileBlock completeBlock;

@end
