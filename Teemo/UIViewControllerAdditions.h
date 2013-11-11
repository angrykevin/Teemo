//
//  UIViewControllerAdditions.h
//  XieHou
//
//  Created by Wu Kevin on 8/27/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Container)

- (void)presentChildViewController:(UIViewController *)childViewController;

- (void)dismissChildViewController:(UIViewController *)childViewController;

@end
