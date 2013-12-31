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
  
  
  NSString *address = @"http://maps.googleapis.com/maps/api/geocode/json?sensor=true&language=zh-CN&latlng=30.636640%2C103.974868";
  _connection = [[TKURLConnectionOperation alloc] initWithAddress:address
                                                  timeoutInterval:0.0
                                                      cachePolicy:0];
  [_connection startAsynchronous];
  
//  tmp.append( string("aa") );
//  tmp.append( string(",") );
//  tmp.append( string("bb") );
//  tmp.append( string(",") );
//  tmp.append( string("cc") );
  
  
//  StringList *list = NULL;
//  printf("%d", list->size());
//  list.push_back( string("aa") );
//  list.push_back( string("bb") );
////  list.push_back( string("cc") );
////  list.push_back( string("dd") );
//  
//  string groupname = list.front();
//  
//  if ( list.size() > 1 ) {
//    StringList::const_iterator it = list.begin();
//    ++it;
//    for ( ; it!=list.end(); ++it ) {
//      groupname.append( string(",") );
//      groupname.append( *it );
//    }
//  }
//  
//  printf("H%sH", groupname.c_str());
  
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
//  [db executeUpdate:@"CREATE TABLE abc( pk INTEGER PRIMARY KEY, str TEXT, sub INTEGER );"];
//  
//  [db executeUpdate:@"INSERT INTO abc(str,sub) VALUES(?,?);", @"aa", @1];
//  [db executeUpdate:@"INSERT INTO abc(str,sub) VALUES(?,?);", @"", @1];
//  [db executeUpdate:@"INSERT INTO abc(str,sub) VALUES(?,?);", @"bb", @2];
//  [db executeUpdate:@"INSERT INTO abc(str,sub) VALUES(?,?);", @"cc", @2];
//  [db executeUpdate:@"INSERT INTO abc(str,sub) VALUES(?,?);", @"aa,cc", @3];
//  [db executeUpdate:@"INSERT INTO abc(str,sub) VALUES(?,?);", @"cc,bb", @2];
//  [db executeUpdate:@"INSERT INTO abc(str,sub) VALUES(?,?);", @"aa,bb,cc", @1];
//  [db executeUpdate:@"INSERT INTO abc(str,sub) VALUES(?,?);", @"aaaa", @2];
//  [db executeUpdate:@"INSERT INTO abc(str,sub) VALUES(?,?);", @"aaaa,aa", @3];
//  
//  NSString *sql = [NSString stringWithFormat:@"SELECT * FROM abc WHERE (str LIKE '%@' OR str LIKE '%@,%%' OR str LIKE '%%,%@' OR str LIKE '%%,%@,%%') AND (sub IN (%@));", @"aa", @"aa", @"aa", @"aa", @"1,2"];
//  NSArray *array1 = [db executeQuery:sql];
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
  
  
//  NSArray *ary = @[ @"b", @"a", @"d", @"c" ];
//  
//  NSArray *tmp = [ary sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//    return [obj1 compare:obj2];
////    NSNumber *n1 = obj1;
////    NSNumber *n2 = obj2;
////    if ( [n1 intValue] < [n2 intValue] ) {
////      return NSOrderedAscending;
////    } else if ( [n1 intValue] > [n2 intValue] ) {
////      return NSOrderedDescending;
////    }
////    return NSOrderedSame;
//  }];
//  NSLog(@"%@", tmp);
  
  
  
  
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
  
  TMSetUpDatabase();
  if ( ![pspt isEqualToString:RSAccountPassport()] ) {
    TMClearDatabase();
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
    TBPresentSystemMessage(@"Sign in failed !");
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
