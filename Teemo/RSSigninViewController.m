//
//  RSSigninViewController.m
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSSigninViewController.h"
#import "RSMainViewController.h"
#import "AppDelegate.h"

@implementation RSSigninViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  
  _navigationView.titleLabel.text = NSLocalizedString(@"Sign in", @"");
  
  _scrollView = [[UIScrollView alloc] init];
  _scrollView.backgroundColor = [UIColor clearColor];
  [_contentView addSubview:_scrollView];
  
  
  _titleLabel = [UILabel labelWithFont:[UIFont boldSystemFontOfSize:64.0]
                                textColor:[UIColor brownColor]
                            textAlignment:NSTextAlignmentCenter
                            lineBreakMode:NSLineBreakByClipping
                            numberOfLines:1
                          backgroundColor:[UIColor clearColor]];
  _titleLabel.text = @"Teemo";
  [_scrollView addSubview:_titleLabel];
  
  _passportLine = [[RSBoxViewLine alloc] init];
  _passportLine.backgroundImageView.image = TBCreateImage(@"box_top.png");
  _passportLine.label.text = NSLocalizedString(@"Passport", @"");
  _passportLine.textField.delegate = self;
  _passportLine.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
  _passportLine.textField.returnKeyType = UIReturnKeyNext;
  [_scrollView addSubview:_passportLine];
  
  _passwordLine = [[RSBoxViewLine alloc] init];
  _passwordLine.backgroundImageView.image = TBCreateImage(@"box_bottom.png");
  _passwordLine.label.text = NSLocalizedString(@"Password", @"");
  _passwordLine.textField.secureTextEntry = YES;
  _passwordLine.textField.delegate = self;
  _passwordLine.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
  _passwordLine.textField.returnKeyType = UIReturnKeyDone;
  [_scrollView addSubview:_passwordLine];
  
  _signinButton = [[UIButton alloc] init];
  _signinButton.normalTitle = NSLocalizedString(@"Sign in", @"");
  _signinButton.normalBackgroundImage = [TBCreateImage(@"button_large_black.png") resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 5.0, 10.0, 5.0)];
  [_signinButton addTarget:self
                    action:@selector(signinButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
  [_scrollView addSubview:_signinButton];
  
  
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(tap:)];
  tapGestureRecognizer.cancelsTouchesInView = NO;
  [_scrollView addGestureRecognizer:tapGestureRecognizer];
  
#ifdef DEBUG
  _passportLine.textField.text = @"alex";
  _passwordLine.textField.text = @"killbill";
#endif
  
}

- (void)layoutViews
{
  [super layoutViews];
  
  _scrollView.frame = _contentView.bounds;
  [_scrollView makeVerticalScrollable];
  
  _titleLabel.frame = CGRectMake(21.0, 10.0, 278.0, 100);
  _passportLine.frame = CGRectMake(21.0, _titleLabel.bottomY + 10.0, 278.0, 44.0);
  _passwordLine.frame = CGRectMake(21.0, _passportLine.bottomY, 278.0, 44.0);
  _signinButton.frame = CGRectMake(21.0, _passwordLine.bottomY + 20.0, 278.0, 43.0);
  
}



- (void)tap:(UITapGestureRecognizer *)recognizer
{
  [TKFindFirstResponderInView(_contentView) resignFirstResponder];
}

- (void)signinButtonClicked:(id)sender
{
  NSString *passport = [_passportLine.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSString *password = [_passwordLine.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
  if ( !TKIsStringWithText(passport) ) {
    TBPresentMessage(@"Passport invalid !");
    return;
  }
  
  if ( !TKIsStringWithText(password) ) {
    TBPresentMessage(@"Password invalid !");
    return;
  }
  
  
  AppDelegate *delegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
  [delegate signinWithPassport:passport password:password];
  
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if ( textField == _passportLine.textField ) {
    [_passwordLine.textField becomeFirstResponder];
  } else if ( textField == _passwordLine.textField ) {
    [_passwordLine.textField resignFirstResponder];
    [self signinButtonClicked:nil];
  }
  return YES;
}

@end
