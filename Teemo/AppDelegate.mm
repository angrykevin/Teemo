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
  
//  TKDatabase *db = [TKDatabase sharedObject];
//  db.path = TKPathForDocumentsResource(@"im.db");
//  [db open];
//
//  [db executeUpdate:@"CREATE TABLE abc( pk INTEGER PRIMARY KEY, str TEXT );"];
//  
//  [db executeUpdate:@"INSERT INTO abc(str) VALUES(?);", @"bbb"];
//  [db executeUpdate:@"INSERT INTO abc(str) VALUES(?);", @"ddd"];
//  [db executeUpdate:@"INSERT INTO abc(str) VALUES(?);", @""];
//  [db executeUpdate:@"INSERT INTO abc(str) VALUES(?);", @"aaa"];
//  [db executeUpdate:@"INSERT INTO abc(str) VALUES(?);", @"ccc"];
//  [db executeUpdate:@"INSERT INTO abc(str) VALUES(?);", @""];
//  [db executeUpdate:@"INSERT INTO abc(str) VALUES(?);", @"ddd"];
//  [db executeUpdate:@"INSERT INTO abc(str) VALUES(?);", @"ccc"];
//
//  NSArray *array1 = [db executeQuery:@"SELECT DISTINCT str FROM abc ORDER BY str;"];
//  for (int i=0; i<[array1 count]; ++i ) {
//    TKDatabaseRow *row = [array1 objectAtIndex:i];
//    NSLog(@"H%@H", [row stringForName:@"str"]);
//  }
//  
//  NSArray *array2 = [db executeQuery:@"SELECT * FROM abc WHERE str=?;", @""];
//  for (int i=0; i<[array2 count]; ++i ) {
//    TKDatabaseRow *row = [array2 objectAtIndex:i];
//    NSLog(@"H%d %@H", [row intForName:@"pk"], [row stringForName:@"str"]);
//  }
  
//  TKDatabase *db = [TKDatabase sharedObject];
//  db.path = TKPathForDocumentsResource(@"im.db");
//  [db open];
//  
//  [db executeUpdate:@"CREATE TABLE abc( pk INTEGER PRIMARY KEY, str TEXT );"];
//  
//  [db executeUpdate:@"INSERT INTO abc(str) VALUES(?);", @"aa"];
//  [db executeUpdate:@"INSERT INTO abc(str) VALUES(?);", @"bb"];
//  [db executeUpdate:@"INSERT INTO abc(str) VALUES(?);", @"cc"];
//  [db executeUpdate:@"INSERT INTO abc(str) VALUES(?);", @"aa,cc"];
//  [db executeUpdate:@"INSERT INTO abc(str) VALUES(?);", @"cc,bb"];
//  [db executeUpdate:@"INSERT INTO abc(str) VALUES(?);", @"aa,bb,cc"];
//  [db executeUpdate:@"INSERT INTO abc(str) VALUES(?);", @"aaaa"];
//  [db executeUpdate:@"INSERT INTO abc(str) VALUES(?);", @"aaaa,aa"];
//  
//  NSArray *array1 = [db executeQuery:@"SELECT * FROM abc WHERE str LIKE 'bb' OR str LIKE 'bb,%' OR str LIKE '%,bb' OR str LIKE '%,bb,%';"];
//  for (int i=0; i<[array1 count]; ++i ) {
//    TKDatabaseRow *row = [array1 objectAtIndex:i];
//    NSLog(@"H%dH", [row intForName:@"pk"]);
//  }
//  
//  NSArray *array2 = [db executeQuery:@"SELECT * FROM abc WHERE str=?;", @""];
//  for (int i=0; i<[array2 count]; ++i ) {
//    TKDatabaseRow *row = [array2 objectAtIndex:i];
//    NSLog(@"H%d %@H", [row intForName:@"pk"], [row stringForName:@"str"]);
//  }
  
  
  
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
  
  [engine createDatabase];
  [engine setUpDatabase];
  if ( ![pspt isEqualToString:RSAccountPassport()] ) {
    [engine clearDatabase];
  }
  
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
    TBDisplayMessage(@"Sign in failed !");
  }
  
  //TMEngine *engine = [TMEngine sharedEngine];
  //[engine removeAllObservers];
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
