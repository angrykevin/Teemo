//
//  TBReverseGeocoder.h
//  Teemo
//
//  Created by Wu Kevin on 12/19/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBCommon.h"

@interface TBReverseGeocoder : NSObject {
  
  NSDictionary *_parameters;
  
  TKURLConnectionOperation *_operation;
  CLLocation *_location;
  NSDictionary *_result;
  
  BOOL _parsing;
}

@property (nonatomic, strong) NSDictionary *parameters;

@property (nonatomic, strong, readonly) TKURLConnectionOperation *operation;
@property (nonatomic, strong, readonly) CLLocation *location;
@property (nonatomic, strong, readonly) NSDictionary *result;

@property (nonatomic, readonly) BOOL parsing;

- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(TBOperationCompletionHandler)completionHandler;

- (void)cancelAndClear;

@end
