//
//  AppDelegate.m
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "AppDelegate.h"
#import "RSSigninViewController.h"
#import "RSMainViewController.h"
#import "RSCommon.h"

#import "Teemo.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  RSDatabaseCreate();
  RSDatabaseSetUpTables();
  
  
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
  
  
  if ( RSHasAccount() ) {
    
    [self signinWithPassport:RSAccountPassport() password:RSAccountPassword()];
    
    RSMainViewController *vc = [[RSMainViewController alloc] init];
    _root = [[UINavigationController alloc] initWithRootViewController:vc];
    _root.navigationBarHidden = YES;
    _window.rootViewController = _root;
    
  } else {
    
    RSSigninViewController *vc = [[RSSigninViewController alloc] init];
    _root = [[UINavigationController alloc] initWithRootViewController:vc];
    _root.navigationBarHidden = YES;
    _window.rootViewController = _root;
    
  }
  
  
  _window.backgroundColor = [UIColor whiteColor];
  [_window makeKeyAndVisible];
  return YES;
}

- (void)signinWithPassport:(NSString *)pspt password:(NSString *)pswd
{
  TMEngine *engine = [TMEngine sharedEngine];
  [engine removeAllObservers];
  [TMEngine clearStoredEngine];
  
  engine = [[TMEngine alloc] init];
  [TMEngine storeEngine:engine];
  [engine setUpWithPassport:pspt password:pswd];
  [engine connectionHandler]->addObserver((__bridge void *)self);
  [engine connect];
}

- (void)signout
{
  
  RSSaveAccountPassport(nil);
  RSSaveAccountPassword(nil);
  
  TMEngine *engine = [TMEngine sharedEngine];
  [engine removeAllObservers];
  [engine disconnect];
  
  if ( !TKIsInstance([_root.viewControllers firstObject], [RSSigninViewController class]) ) {
    RSSigninViewController *vc = [[RSSigninViewController alloc] init];
    CATransition *transition = [CATransition popTransition];
    [_root.view.layer addAnimation:transition forKey:nil];
    [_root setViewControllers:@[ vc ] animated:NO];
  }
  
}



- (void)connectionOnConnect
{
  TKPRINTMETHOD();
  
  TMEngine *engine = [TMEngine sharedEngine];
  
  NSString *passport = RSAccountPassport();
  if ( ![[engine passport] isEqualToString:passport] ) {
    RSDatabaseClearData();
  }
  
  RSSaveAccountPassport( [engine passport] );
  RSSaveAccountPassword( [engine password] );
  
  
  if ( !TKIsInstance([_root.viewControllers firstObject], [RSMainViewController class]) ) {
    RSMainViewController *vc = [[RSMainViewController alloc] init];
    CATransition *transition = [CATransition pushTransition];
    [_root.view.layer addAnimation:transition forKey:nil];
    [_root setViewControllers:@[ vc ] animated:NO];
  }
  
}

- (void)connectionOnDisconnect:(ConnectionError)error
{
  TKPRINTMETHOD();
  
  if ( TKIsInstance([_root.viewControllers firstObject], [RSSigninViewController class]) ) {
    TBDisplayMessage(@"登录失败！");
  }
  
  TMEngine *engine = [TMEngine sharedEngine];
  [engine removeAllObservers];
  [TMEngine clearStoredEngine];
  
}

//- (void)connectionOnResourceBind:(const std::string &)resource
//{
//  TKPRINTMETHOD();
//}
//
//- (void)connectionOnResourceBindError:(const Error *)error
//{
//  TKPRINTMETHOD();
//}
//
//- (void)connectionOnSessionCreateError:(const Error *)error
//{
//  TKPRINTMETHOD();
//}
//
//- (bool)connectionOnTLSConnect:(const CertInfo &)info
//{
//  TKPRINTMETHOD();
//  return true;
//}
//
//- (void)connectionOnStreamEvent:(StreamEvent)event
//{
//  TKPRINTMETHOD();
//}

@end
