//
//  RSViewController.m
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSViewController.h"


@implementation RSViewController

- (id)init
{
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _navigationView = [[RSNavigationView alloc] init];
  _navigationView.leftButton.normalTitle = NSLocalizedString(@"返回", @"");
  [_navigationView.leftButton addTarget:self
                                 action:@selector(leftButtonClicked:)
                       forControlEvents:UIControlEventTouchUpInside];
  [_navigationView.rightButton addTarget:self
                                  action:@selector(rightButtonClicked:)
                        forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_navigationView];
  
  
  _contentView = [[UIView alloc] init];
  _contentView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:_contentView];
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [self layoutViews];
  
}


- (void)layoutViews
{
  [_navigationView sizeToFit];
  _navigationView.frame = CGRectMake(0.0, 20.0, _navigationView.width, _navigationView.height);
  
  _contentView.frame = CGRectMake(0.0, _navigationView.bottomY, self.view.width, self.view.height - _navigationView.bottomY);
  
}


- (void)leftButtonClicked:(id)sender
{
  TKPRINTMETHOD();
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonClicked:(id)sender
{
  TKPRINTMETHOD();
}

@end


@implementation RSNavigationView

- (id)init
{
  self = [super init];
  if (self) {
    
    self.backgroundColor = [UIColor lightGrayColor];
    
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor darkGrayColor];
    button.exclusiveTouch = YES;
    [self addSubview:button];
    _leftButton = button;
    
    
    _titleLabel = [UILabel labelWithFont:[UIFont boldSystemFontOfSize:16.0]
                               textColor:[UIColor blackColor]
                         backgroundColor:[UIColor darkGrayColor]
                           textAlignment:NSTextAlignmentCenter
                           lineBreakMode:NSLineBreakByTruncatingMiddle
               adjustsFontSizeToFitWidth:NO
                           numberOfLines:1];
    [self addSubview:_titleLabel];
    
    
    button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor darkGrayColor];
    button.exclusiveTouch = YES;
    [self addSubview:button];
    _rightButton = button;
    
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  _leftButton.frame = CGRectMake(5.0, 2.0, 50.0, 40.0);
  _titleLabel.frame = CGRectMake(60.0, 2.0, 200.0, 40.0);
  _rightButton.frame = CGRectMake(265.0, 2.0, 50.0, 40.0);
  
}

- (CGSize)sizeThatFits:(CGSize)size
{
  return CGSizeMake(320.0, 44.0);
}

@end
