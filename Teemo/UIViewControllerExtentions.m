//
//  UIViewControllerExtentions.m
//  Teemo
//
//  Created by Wu Kevin on 8/27/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "UIViewControllerExtentions.h"

@implementation UIViewController (Extentions)

- (void)presentChildViewController:(UIViewController *)childViewController
{
  
  [self addChildViewController:childViewController];
  [self.view addSubview:childViewController.view];
  [childViewController didMoveToParentViewController:self];
  
}

- (void)dismissChildViewController:(UIViewController *)childViewController
{
  
  [childViewController willMoveToParentViewController:nil];
  [childViewController.view removeFromSuperview];
  [childViewController removeFromParentViewController];
  
}

@end

