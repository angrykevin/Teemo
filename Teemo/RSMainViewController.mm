//
//  RSMainViewController.mm
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSMainViewController.h"
#import "RSChatlogViewController.h"
#import "RSBuddiesViewController.h"
#import "RSSettingViewController.h"

#import "Teemo.h"
#import "RSBadgeView.h"


@implementation RSMainViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [[TMEngine sharedEngine] addObserver:self];
  
  RSChatlogViewController *vc1 = [[RSChatlogViewController alloc] init];
  RSBuddiesViewController *vc2 = [[RSBuddiesViewController alloc] init];
  RSSettingViewController *vc3 = [[RSSettingViewController alloc] init];
  
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
  
  
  
  [self setupWithItems:@[ it1, it2, it3 ] viewControllers:@[ nv1, nv2, nv3 ]];
  
}

- (void)dealloc
{
  [[TMEngine sharedEngine] removeObserver:self];
}

- (void)showBadgeValue:(NSString *)badge inTabAtIndex:(NSInteger)idx
{
  TBTabViewItem *item = [_tabView.items objectOrNilAtIndex:idx];
  if ( item ) {
    RSBadgeView *badgeView = (RSBadgeView *)[item.button viewWithTag:101];
    
    if ( [badge length]>0 ) {
      
      if ( badgeView == nil ) {
        badgeView = [[RSBadgeView alloc] init];
        badgeView.tag = 101;
        [item.button addSubview:badgeView];
      }
      
      badgeView.textLabel.text = badge;
      [badgeView sizeToFit];
      badgeView.frame = CGRectMake(item.button.width - badgeView.width,
                                   0.0,
                                   badgeView.width,
                                   badgeView.height);
      
    } else {
      if ( badgeView ) {
        [badgeView removeFromSuperview];
      }
    }
    
  }
  
}



- (void)engineHandleRoster:(TMEngine *)engine
{
}

- (void)engine:(TMEngine *)engine handleRosterError:(NSError *)error
{
}

- (void)engine:(TMEngine *)engine handleItemAdded:(NSString *)jid
{
}

- (void)engine:(TMEngine *)engine handleItemRemoved:(NSString *)jid
{
}

- (void)engine:(TMEngine *)engine handleItemUpdated:(NSString *)jid
{
}

- (void)engine:(TMEngine *)engine handleItemSubscribed:(NSString *)jid
{
}

- (void)engine:(TMEngine *)engine handleItemUnsubscribed:(NSString *)jid
{
}

- (void)engine:(TMEngine *)engine handleSubscriptionRequest:(NSString *)jid message:(NSString *)message
{
  [self showBadgeValue:@"1" inTabAtIndex:0];
}

- (void)engine:(TMEngine *)engine handleUnsubscriptionRequest:(NSString *)jid message:(NSString *)message
{
}

- (void)engine:(TMEngine *)engine handlePresence:(NSString *)jid resource:(NSString *)resource
{
}

@end
