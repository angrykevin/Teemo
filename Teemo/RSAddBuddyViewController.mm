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
  [_scrollView addSubview:_jidLine];
  
  _displaynameLine = [[RSBoxViewLine alloc] init];
  _displaynameLine.backgroundImageView.image = TBCreateImage(@"box_middle.png");
  _displaynameLine.label.text = NSLocalizedString(@"Displayname", @"");
  _displaynameLine.textField.delegate = self;
  _displaynameLine.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
  [_scrollView addSubview:_displaynameLine];
  
  _groupnameLine = [[RSBoxViewLine alloc] init];
  _groupnameLine.backgroundImageView.image = TBCreateImage(@"box_middle.png");
  _groupnameLine.label.text = NSLocalizedString(@"Groupname", @"");
  _groupnameLine.textField.delegate = self;
  _groupnameLine.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
  [_scrollView addSubview:_groupnameLine];
  
  _messageLine = [[RSBoxViewLine alloc] init];
  _messageLine.backgroundImageView.image = TBCreateImage(@"box_bottom.png");
  _messageLine.label.text = NSLocalizedString(@"Message", @"");
  _messageLine.textField.delegate = self;
  _messageLine.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
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
  _displaynameLine.frame = CGRectMake(10.0, _jidLine.bottomY, 300.0, 44.0);
  _groupnameLine.frame = CGRectMake(10.0, _displaynameLine.bottomY, 300.0, 44.0);
  _messageLine.frame = CGRectMake(10.0, _groupnameLine.bottomY, 300.0, 44.0);
  
}


- (void)tap:(UITapGestureRecognizer *)recognizer
{
  [TKFindFirstResponderInView(_contentView) resignFirstResponder];
}

- (void)rightButtonClicked:(id)sender
{
  if ( [_jidLine.textField.text length] <= 0 ) {
    TBDisplayMessage(NSLocalizedString(@"JID error!", @""));
    return;
  }
  
  NSString *jid = _jidLine.textField.text;
  
  NSString *displayname = _displaynameLine.textField.text;
  if ( [displayname length] <= 0 ) {
    displayname = @"";
  }
  
  NSString *groupname = _groupnameLine.textField.text;
  if ( [groupname length] <= 0 ) {
    groupname = @"";
  }
  
  NSString *message = _messageLine.textField.text;
  if ( [message length] <= 0 ) {
    message = @"";
  }
  
  TMEngine *engine = [TMEngine sharedEngine];
  RosterManager *manager = [engine rosterManager];
  manager->subscribe(JID( CPPSTR(jid) ),
                     CPPSTR(displayname),
                     StringList(1, CPPSTR(groupname)),
                     CPPSTR(message));
  
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  if ( range.length == 1 ) {
    return YES;
  }
  
  NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
  
  if ( [result length] <= 50 ) {
    return YES;
  }
  return NO;
}

@end
