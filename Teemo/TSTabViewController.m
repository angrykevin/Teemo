//
//  TSTabViewController.m
//  Teemo
//
//  Created by Wu Kevin on 1/22/14.
//  Copyright (c) 2014 xbcx. All rights reserved.
//

#import "TSTabViewController.h"
#import "TSViewController.h"


@implementation TSTabViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  TSViewController *vc1 = [[TSViewController alloc] init];
  TSViewController *vc2 = [[TSViewController alloc] init];
  TSViewController *vc3 = [[TSViewController alloc] init];
  
  UINavigationController *nv1 = [[UINavigationController alloc] initWithRootViewController:vc1];
  UINavigationController *nv2 = [[UINavigationController alloc] initWithRootViewController:vc2];
  UINavigationController *nv3 = [[UINavigationController alloc] initWithRootViewController:vc3];
  
  nv1.navigationBarHidden = YES;
  nv2.navigationBarHidden = YES;
  nv3.navigationBarHidden = YES;
  
  _viewControllers = [[NSArray alloc] initWithObjects:nv1, nv2, nv3, nil];
  
  
  
  TBTabViewItem *it1 = [TBTabViewItem itemWithNormalTitle:NSLocalizedString(@"Chatlog", @"")
                                         highlightedTitle:NSLocalizedString(@"Chatlog", @"")
                                         normalTitleColor:[UIColor whiteColor]
                                    highlightedTitleColor:[UIColor whiteColor]
                                              normalImage:TBCreateImage(@"tabbar_chatlog_n.png")
                                         highlightedImage:TBCreateImage(@"tabbar_chatlog_h.png")
                                    normalBackgroundImage:nil
                               highlightedBackgroundImage:nil];
  
  TBTabViewItem *it2 = [TBTabViewItem itemWithNormalTitle:NSLocalizedString(@"Buddies", @"")
                                         highlightedTitle:NSLocalizedString(@"Buddies", @"")
                                         normalTitleColor:[UIColor whiteColor]
                                    highlightedTitleColor:[UIColor whiteColor]
                                              normalImage:TBCreateImage(@"tabbar_buddies_n.png")
                                         highlightedImage:TBCreateImage(@"tabbar_buddies_h.png")
                                    normalBackgroundImage:nil
                               highlightedBackgroundImage:nil];
  
  TBTabViewItem *it3 = [TBTabViewItem itemWithNormalTitle:NSLocalizedString(@"Setting", @"")
                                         highlightedTitle:NSLocalizedString(@"Setting", @"")
                                         normalTitleColor:[UIColor whiteColor]
                                    highlightedTitleColor:[UIColor whiteColor]
                                              normalImage:TBCreateImage(@"tabbar_setting_n.png")
                                         highlightedImage:TBCreateImage(@"tabbar_setting_h.png")
                                    normalBackgroundImage:nil
                               highlightedBackgroundImage:nil];
  
  
  
  [self setUpWithItems:@[ it1, it2, it3 ] viewControllers:@[ vc1, vc2, vc3 ]];
  
}

@end
