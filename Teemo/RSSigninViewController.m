//
//  RSSigninViewController.m
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSSigninViewController.h"
#import "RSMainViewController.h"

//#import "TapKit.h"
//#import "TTCommon.h"
//#import "Teemo.h"


@implementation RSSigninViewController


- (void)viewDidLoad
{
  [super viewDidLoad];
  
  
  _navigationView.titleLabel.text = NSLocalizedString(@"登录", @"");
  
  _scrollView = [[UIScrollView alloc] init];
  _scrollView.backgroundColor = [UIColor clearColor];
  [_contentView addSubview:_scrollView];
  
  
  _titleLabel = [UILabel labelWithFont:[UIFont boldSystemFontOfSize:64.0]
                             textColor:[UIColor brownColor]
                       backgroundColor:[UIColor clearColor]
                         textAlignment:NSTextAlignmentCenter
                         lineBreakMode:NSLineBreakByClipping
             adjustsFontSizeToFitWidth:NO
                         numberOfLines:1];
  _titleLabel.text = @"Teemo";
  [_scrollView addSubview:_titleLabel];
  
  _passportLine = [[RSBoxViewLine alloc] init];
  _passportLine.backgroundImageView.image = TTCreateImage(@"box_top.png");
  _passportLine.label.text = NSLocalizedString(@"帐  号", @"");
  [_scrollView addSubview:_passportLine];
  
  _passwordLine = [[RSBoxViewLine alloc] init];
  _passwordLine.textField.secureTextEntry = YES;
  _passwordLine.backgroundImageView.image = TTCreateImage(@"box_bottom.png");
  _passwordLine.label.text = NSLocalizedString(@"密  码", @"");
  [_scrollView addSubview:_passwordLine];
  
  _signinButton = [[UIButton alloc] init];
  _signinButton.normalTitle = NSLocalizedString(@"登    录", @"");
  _signinButton.normalBackgroundImage = [TTCreateImage(@"button_large_black.png") resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 5.0, 10.0, 5.0)];
  [_signinButton addTarget:self
                    action:@selector(signinButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
  [_scrollView addSubview:_signinButton];
  
  
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(tap:)];
  tapGestureRecognizer.cancelsTouchesInView = NO;
  [_scrollView addGestureRecognizer:tapGestureRecognizer];
  
#ifdef DEBUG
  _passportLine.textField.text = @"roselet1321";
  _passwordLine.textField.text = @"55793219";
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
  _signinButton.frame = CGRectMake(21.0, _passwordLine.bottomY + 10.0, 278.0, 43.0);
  
}



- (void)tap:(UITapGestureRecognizer *)recognizer
{
  //[TKFindFirstResponderInView(_contentView) resignFirstResponder];
}

- (void)signinButtonClicked:(id)sender
{
//  NSString *passport = [_passportLine.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//  //NSString *password = [_passwordLine.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//  
//  if ( !TKIsStringWithText(passport) ) {
//    TTDisplayMessage(@"alksdfjlaskdfj");
//  }
  
//  if ( !TKIsStringWithText(passport) ) {
//  }
  
//  TMEngine *engine = [[TMEngine alloc] init];
}

@end
