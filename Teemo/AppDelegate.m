//
//  AppDelegate.m
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "AppDelegate.h"
#import "RSSigninViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
  
  RSSigninViewController *vc = [[RSSigninViewController alloc] init];
  UINavigationController *root = [[UINavigationController alloc] initWithRootViewController:vc];
  root.navigationBarHidden = YES;
  _window.rootViewController = root;
  
  
  TKDatabase *db = [TKDatabase sharedObject];
  db.path = TKPathForDocumentsResource(@"Teemo.db");
  [db open];
  
  if ( ![db hasTableNamed:@"tBuddy"] ) {
    [db executeUpdate:@"CREATE TABLE tBuddy(pk INTEGER);"];
  }
  
  _window.backgroundColor = [UIColor whiteColor];
  [_window makeKeyAndVisible];
  return YES;
}

@end
