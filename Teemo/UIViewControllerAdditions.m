//
//  UIViewControllerAdditions.m
//  XieHou
//
//  Created by Wu Kevin on 8/27/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "UIViewControllerAdditions.h"

@implementation UIViewController (Container)

- (void)containerAddChildViewController:(UIViewController *)childViewController
{
  
  [self addChildViewController:childViewController];
  [self.view addSubview:childViewController.view];
  [childViewController didMoveToParentViewController:self];
  
}

- (void)containerRemoveChildViewController:(UIViewController *)childViewController
{
  
  [childViewController willMoveToParentViewController:nil];
  [childViewController.view removeFromSuperview];
  [childViewController removeFromParentViewController];
  
}

@end

