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
  
  UIViewController *vc1 = [[UIViewController alloc] init];
  vc1.view.backgroundColor = [UIColor redColor];
  
  UIViewController *vc2 = [[UIViewController alloc] init];
  vc2.view.backgroundColor = [UIColor greenColor];
  
  UIViewController *vc3 = [[UIViewController alloc] init];
  vc3.view.backgroundColor = [UIColor blueColor];
  
  NSArray *viewControllers = [[NSArray alloc] initWithObjects:vc1, vc2, vc3, nil];
  _viewControllers = viewControllers;
  
  
  
  RSTabViewItem *item1 = [[RSTabViewItem alloc] init];
  item1.normalTitle = @"11";
  
  RSTabViewItem *item2 = [[RSTabViewItem alloc] init];
  item2.normalTitle = @"22";
  
  RSTabViewItem *item3 = [[RSTabViewItem alloc] init];
  item3.normalTitle = @"33";
  
  
  
  _tabView = [[RSTabView alloc] initWithItems:@[ item1, item2, item3 ]];
  
  
  __weak RSMainViewController *weakSelf = self;
  
  _tabView.block = ^(NSUInteger index, RSTabViewItem *item) {
    
    UIViewController *currentVC = [weakSelf.childViewControllers firstObject];
    UIViewController *newVC = [viewControllers objectOrNilAtIndex:index];
    
    if ( currentVC != newVC ) {
      [weakSelf containerAddChildViewController:newVC];
      [weakSelf containerRemoveChildViewController:currentVC];
    }
    
    [weakSelf layoutViews];
    
  };
  
  _tabView.repeatedlyNotify = NO;
  
  [self.view addSubview:_tabView];
  
}

@end
