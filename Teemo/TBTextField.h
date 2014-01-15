//
//  TBTextField.h
//  Teemo
//
//  Created by Wu Kevin on 1/15/14.
//  Copyright (c) 2014 xbcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBTextField : UITextField {
  NSUInteger _maxLength;
}

@property (nonatomic, assign) NSUInteger maxLength;

@end
