//
//  TBTextField.m
//  Teemo
//
//  Created by Wu Kevin on 1/15/14.
//  Copyright (c) 2014 xbcx. All rights reserved.
//

#import "TBTextField.h"

@implementation TBTextField


- (void)setText:(NSString *)text
{
  if ( (_maxLength > 0) && ([text length] > _maxLength) ) {
    [super setText:[text substringToIndex:_maxLength]];
  } else {
    [super setText:text];
  }
  
}


- (NSUInteger)maxLength
{
  return _maxLength;
}

- (void)setMaxLength:(NSUInteger)maxLength
{
  if ( maxLength > 0 ) {
    _maxLength = maxLength;
    [self addTarget:self
             action:@selector(editingChanged:)
   forControlEvents:UIControlEventEditingChanged];
    
    if ( [self.text length] > _maxLength ) {
      [super setText:[self.text substringToIndex:_maxLength]];
    }
    
  } else {
    _maxLength = 0;
    [self removeTarget:self
                action:@selector(editingChanged:)
      forControlEvents:UIControlEventEditingChanged];
  }
  
}


- (void)editingChanged:(UITextField *)textField
{
  if ( [textField.text length] > _maxLength ) {
    textField.text = [textField.text substringToIndex:_maxLength];
  }
}

@end
