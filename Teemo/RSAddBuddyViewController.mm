//
//  RSAddBuddyViewController.mm
//  Teemo
//
//  Created by Wu Kevin on 11/18/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSAddBuddyViewController.h"
#import "Teemo.h"

@implementation RSAddBuddyViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  
  [_navigationView showBackButton];
  [_navigationView showRightButton];
  _navigationView.rightButton.normalTitle = NSLocalizedString(@"Done", @"");
  _navigationView.titleLabel.text = NSLocalizedString(@"Add buddy", @"");
  
  
  _scrollView = [[UIScrollView alloc] init];
  _scrollView.backgroundColor = [UIColor clearColor];
  [_contentView addSubview:_scrollView];
  
  
  _jidLine = [[RSBoxViewLine alloc] init];
  _jidLine.backgroundImageView.image = TBCreateImage(@"box_top.png");
  _jidLine.label.text = NSLocalizedString(@"JID", @"");
  _jidLine.textField.delegate = self;
  _jidLine.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
  _jidLine.textField.returnKeyType = UIReturnKeyNext;
  [_scrollView addSubview:_jidLine];
  
  _messageLine = [[RSBoxViewLine alloc] init];
  _messageLine.backgroundImageView.image = TBCreateImage(@"box_bottom.png");
  _messageLine.label.text = NSLocalizedString(@"Message", @"");
  _messageLine.textField.delegate = self;
  _messageLine.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
  _messageLine.textField.returnKeyType = UIReturnKeyDone;
  [_scrollView addSubview:_messageLine];
  
  
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(tap:)];
  tapGestureRecognizer.cancelsTouchesInView = NO;
  [_scrollView addGestureRecognizer:tapGestureRecognizer];
  
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  [_jidLine.textField becomeFirstResponder];
}

- (void)layoutViews
{
  [super layoutViews];
  
  _scrollView.frame = _contentView.bounds;
  [_scrollView makeVerticalScrollable];
  
  _jidLine.frame = CGRectMake(10.0, 10.0, 300.0, 44.0);
  _messageLine.frame = CGRectMake(10.0, _jidLine.bottomY, 300.0, 44.0);
  
}


- (void)tap:(UITapGestureRecognizer *)recognizer
{
  [TKFindFirstResponderInView(_contentView) resignFirstResponder];
}



- (void)rightButtonClicked:(id)sender
{
  if ( [_jidLine.textField.text length] <= 0 ) {
    TBPresentMessage(NSLocalizedString(@"JID invalid!", @""));
    return;
  }
  
  NSString *jid = _jidLine.textField.text;
  
  NSString *message = _messageLine.textField.text;
  if ( [message length] <= 0 ) {
    message = NSLocalizedString(@"Nice to meet you!", @"");
  }
  
  TMEngine *engine = [TMEngine sharedEngine];
  [engine addBuddy:jid message:message];
  
  TBAlertView *alertView = [[TBAlertView alloc] initWithMessage:NSLocalizedString(@"Request has been send.", @"")];
  [alertView addButtonWithTitle:NSLocalizedString(@"OK", @"") block:^{
    [self.navigationController popViewControllerAnimated:YES];
  }];
  [alertView show];
  
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if ( textField == _jidLine.textField ) {
    [_messageLine.textField becomeFirstResponder];
  } else if ( textField == _messageLine.textField ) {
    [_messageLine.textField resignFirstResponder];
    [self rightButtonClicked:nil];
  }
  return YES;
}

@end
