//
//  RSMainViewController.m
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSMainViewController.h"
#import "Teemo.h"

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
  
  
  
  RSTabViewItem *item1 = [[RSTabViewItem alloc] init];
  item1.normalTitle = @"11";
  
  RSTabViewItem *item2 = [[RSTabViewItem alloc] init];
  item2.normalTitle = @"22";
  
  RSTabViewItem *item3 = [[RSTabViewItem alloc] init];
  item3.normalTitle = @"33";
  
  
  _tabView = [self tabViewWithItems:@[ item1, item2, item3 ]];
  [self.view addSubview:_tabView];
  
}

@end
