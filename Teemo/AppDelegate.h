//
//  AppDelegate.h
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
  UIWindow *_window;
  UINavigationController *_root;
  TBReverseGeocoder *_geocoder;
}

@property (nonatomic, strong) UIWindow *window;

- (void)signinWithPassport:(NSString *)pspt password:(NSString *)pswd;
- (void)signout;

@end
