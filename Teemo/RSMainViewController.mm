//
//  RSMainViewController.m
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSMainViewController.h"

@implementation RSMainViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIViewController *vc1 = [[UIViewController alloc] init];
  vc1.view.backgroundColor = [UIColor redColor];
  
  UIViewController *vc2 = [[UIViewController alloc] init];
  vc2.view.backgroundColor = [UIColor greenColor];
  
  UIViewController *vc3 = [[UIViewController alloc] init];
  vc3.view.backgroundColor = [UIColor blueColor];
  
  _viewControllers = [[NSArray alloc] initWithObjects:vc1, vc2, vc3, nil];
  
  
  
  TTTabViewItem *item1 = [[TTTabViewItem alloc] init];
  item1.normalTitle = @"11";
  
  TTTabViewItem *item2 = [[TTTabViewItem alloc] init];
  item2.normalTitle = @"22";
  
  TTTabViewItem *item3 = [[TTTabViewItem alloc] init];
  item3.normalTitle = @"33";
  
  
  _tabView = [self tabViewWithItems:@[ item1, item2, item3 ]];
  [self.view addSubview:_tabView];
  
}

@end
