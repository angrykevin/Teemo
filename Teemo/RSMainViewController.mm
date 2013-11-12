//
//  RSMainViewController.m
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSMainViewController.h"
#import "RSChatlogViewController.h"
#import "RSBuddiesViewController.h"
#import "RSSettingViewController.h"

@implementation RSMainViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  RSChatlogViewController *vc1 = [[RSChatlogViewController alloc] init];
  RSBuddiesViewController *vc2 = [[RSBuddiesViewController alloc] init];
  RSSettingViewController *vc3 = [[RSSettingViewController alloc] init];
  
  _viewControllers = [[NSArray alloc] initWithObjects:vc1, vc2, vc3, nil];
  
  
  
  TTTabViewItem *it1 = [TTTabViewItem itemWithNormalTitle:NSLocalizedString(@"会话", @"")
                                         highlightedTitle:NSLocalizedString(@"会话", @"")
                                         normalTitleColor:[UIColor whiteColor]
                                    highlightedTitleColor:[UIColor whiteColor]
                                              normalImage:TTCreateImage(@"tabbar_chatlog_n.png")
                                         highlightedImage:TTCreateImage(@"tabbar_chatlog_h.png")
                                    normalBackgroundImage:nil
                               highlightedBackgroundImage:nil];
  
  TTTabViewItem *it2 = [TTTabViewItem itemWithNormalTitle:NSLocalizedString(@"好友", @"")
                                         highlightedTitle:NSLocalizedString(@"好友", @"")
                                         normalTitleColor:[UIColor whiteColor]
                                    highlightedTitleColor:[UIColor whiteColor]
                                              normalImage:TTCreateImage(@"tabbar_buddies_n.png")
                                         highlightedImage:TTCreateImage(@"tabbar_buddies_h.png")
                                    normalBackgroundImage:nil
                               highlightedBackgroundImage:nil];
  
  TTTabViewItem *it3 = [TTTabViewItem itemWithNormalTitle:NSLocalizedString(@"设置", @"")
                                         highlightedTitle:NSLocalizedString(@"设置", @"")
                                         normalTitleColor:[UIColor whiteColor]
                                    highlightedTitleColor:[UIColor whiteColor]
                                              normalImage:TTCreateImage(@"tabbar_setting_n.png")
                                         highlightedImage:TTCreateImage(@"tabbar_setting_h.png")
                                    normalBackgroundImage:nil
                               highlightedBackgroundImage:nil];
  
  
  
  [self setUpWithItems:@[ it1, it2, it3 ] viewControllers:@[ vc1, vc2, vc3 ]];
  
}

@end
