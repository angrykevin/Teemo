//
//  RSEditProfileViewController.m
//  Teemo
//
//  Created by Wu Kevin on 11/15/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSEditProfileViewController.h"


@implementation RSEditProfileViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [_navigationView showBackButton];
  [_navigationView showRightButton];
  _navigationView.rightButton.normalTitle = NSLocalizedString(@"Done", @"");
  _navigationView.titleLabel.text = NSLocalizedString(@"Edit", @"");
  
  
  _scrollView = [[UIScrollView alloc] init];
  _scrollView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5];
  [_contentView addSubview:_scrollView];
  
  
  _backgroundView = [[UIView alloc] init];
  _backgroundView.backgroundColor = [UIColor whiteColor];
  _backgroundView.layer.cornerRadius = 4.0;
  _backgroundView.clipsToBounds = YES;
  [_scrollView addSubview:_backgroundView];
  
  _textField = [[UITextField alloc] init];
  _textField.delegate = self;
  [_textField addTarget:self
                 action:@selector(editingChanged:)
       forControlEvents:UIControlEventEditingChanged];
  _textField.font = [UIFont systemFontOfSize:14.0];
  _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  _textField.borderStyle = UITextBorderStyleNone;
  [_scrollView addSubview:_textField];
  if ( [_value length] > _maxLength ) {
    _value = [_value substringToIndex:_maxLength];
  }
  _textField.text = _value;
  
  
  _hintLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12.0]
                            textColor:[UIColor darkGrayColor]
                      backgroundColor:[UIColor clearColor]
                        textAlignment:NSTextAlignmentRight
                        lineBreakMode:NSLineBreakByTruncatingTail
            adjustsFontSizeToFitWidth:NO
                        numberOfLines:1];
  [_scrollView addSubview:_hintLabel];
  _hintLabel.text = [NSString stringWithFormat:@"%d/%d", [_value length], _maxLength];
  
  
  UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
  gestureRecognizer.cancelsTouchesInView = NO;
  [_scrollView addGestureRecognizer:gestureRecognizer];
  
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  [_textField becomeFirstResponder];
  
}

- (void)layoutViews
{
  [super layoutViews];
  
  _scrollView.frame = _contentView.bounds;
  [_scrollView makeVerticalScrollable];
  
  _backgroundView.frame = CGRectMake(10.0, 50.0, 300.0, 40.0);
  _textField.frame = CGRectInset(_backgroundView.frame, 5.0, 2.0);
  
  _hintLabel.frame = CGRectMake(15.0, _backgroundView.bottomY, 290.0, 30.0);
  
}

- (void)rightButtonClicked:(id)sender
{
  if ( _completeBlock ) {
    _completeBlock( _value );
  }
  
  [_textField resignFirstResponder];
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)editingChanged:(id)sender
{
  TKPRINTMETHOD();
  _value = [_textField.text copy];
  
  _hintLabel.text = [NSString stringWithFormat:@"%d/%d", [_value length], _maxLength];
  
}

- (void)tap:(UITapGestureRecognizer *)gestureRecognizer
{
  [_textField resignFirstResponder];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  if ( range.length == 1 ) {
    return YES;
  }
  
  NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
  
  if ( [result length] <= _maxLength ) {
    return YES;
  }
  return NO;
}

@end
