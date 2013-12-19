//
//  TBLocationManager.h
//  Teemo
//
//  Created by Wu Kevin on 11/8/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


#define TBLocationManagerDidStartUpdatingNotification @"TBLocationManagerDidStartUpdatingNotification"
#define TBLocationManagerDidStopUpdatingNotification @"TBLocationManagerDidStopUpdatingNotification"
#define TBLocationManagerDidUpdateNotification @"TBLocationManagerDidUpdateNotification"


@interface TBLocationManager : NSObject<CLLocationManagerDelegate> {
  CLLocationManager *_locationManager;
  CLLocation *_location;
  BOOL _updating;
}

@property(nonatomic, strong, readonly) CLLocationManager *locationManager;
@property(nonatomic, strong, readonly) CLLocation *location;
@property(nonatomic, readonly) BOOL updating;

+ (TBLocationManager *)sharedObject;

- (void)launchLocationServiceIfNeeded;
- (void)shutDownLocationServiceIfNeeded;

@end
