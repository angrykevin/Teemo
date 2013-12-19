//
//  TBReverseGeocoder.m
//  Teemo
//
//  Created by Wu Kevin on 12/19/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "TBReverseGeocoder.h"

@implementation TBReverseGeocoder

- (void)dealloc
{
  [_operation clearDelegatesAndCancel];
}

- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(TBOperationCompletionHandler)completionHandler
{
  if ( location ) {
    [_operation clearDelegatesAndCancel];
    _location = location;
    _result = nil;
    
    _parsing = NO;
    
    
    NSString *address = @"http://maps.googleapis.com/maps/api/geocode/json";
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"true" forKey:@"sensor"];
    [parameters setObject:@"zh-CN" forKey:@"language"];
    
    if ( [_parameters count] > 0 ) {
      for ( NSString *key in [_parameters keyEnumerator] ) {
        NSString *value = [_parameters objectForKey:key];
        [parameters setObject:value forKey:key];
      }
    }
    
    NSString *latlng = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    [parameters setObject:latlng forKey:@"latlng"];
    
    _operation = [[TKURLConnectionOperation alloc] initWithAddress:[address stringByAddingQueryDictionary:parameters]
                                                   timeoutInterval:0.0
                                                       cachePolicy:0];
    
    __weak typeof(self) weakSelf = self;
    
    _operation.didStartBlock = ^(id object) {
      [weakSelf setParsing:YES];
      [weakSelf setResult:nil];
    };
    
    _operation.didFailBlock = ^(id object) {
      [weakSelf setParsing:NO];
      [weakSelf setResult:nil];
      if ( completionHandler ) {
        NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
        completionHandler(nil, error);
      }
    };
    
    _operation.didFinishBlock = ^(id object) {
      id result = [NSJSONSerialization JSONObjectWithData:[object responseData]
                                                  options:0
                                                    error:NULL];
      [weakSelf setParsing:NO];
      [weakSelf setResult:result];
      if ( completionHandler ) {
        completionHandler(result, nil);
      }
    };
    
    [_operation startAsynchronous];
    
  }
}


- (BOOL)parsing
{
  return _parsing;
}

- (void)setParsing:(BOOL)parsing
{
  _parsing = parsing;
}


- (NSDictionary *)result
{
  return _result;
}

- (void)setResult:(NSDictionary *)result
{
  _result = result;
}

@end
