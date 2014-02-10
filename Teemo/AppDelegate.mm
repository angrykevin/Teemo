//
//  AppDelegate.mm
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
  
  //@"SELECT * FROM abc WHERE (str LIKE '%@' OR str LIKE '%@,%%' OR str LIKE '%%,%@' OR str LIKE '%%,%@,%%') AND (sub IN (%@));"
  
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
  
  
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
  
  TMSetUpDatabase( [engine database] );
  if ( ![pspt isEqualToString:RSAccountPassport()] ) {
    TMClearDatabase( [engine database] );
  }
  
  [engine setUpWithPassport:pspt password:pswd];
  [engine addObserver:self];
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



- (void)engineConnectionOnConnect:(TMEngine *)engine
{
  TKPRINTMETHOD();
  
  RSSaveAccountPassport( [engine passport] );
  RSSaveAccountPassword( [engine password] );
  
  
  if ( !TKIsInstance([_root.viewControllers firstObject], [RSMainViewController class]) ) {
    RSMainViewController *vc = [[RSMainViewController alloc] init];
    CATransition *transition = [CATransition pushTransition];
    [_root.view.layer addAnimation:transition forKey:nil];
    [_root setViewControllers:@[ vc ] animated:NO];
  }
}

- (void)engine:(TMEngine *)engine connectionOnDisconnect:(ConnectionError)error
{
  TKPRINTMETHOD();
  
  if ( TKIsInstance([_root.viewControllers firstObject], [RSSigninViewController class]) ) {
    TBPresentSystemMessage(@"Sign in failed !");
  }
  
  [engine removeAllObservers];
  [TMEngine clearStoredEngine];
}

@end
