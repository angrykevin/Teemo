//
//  TKCoreCommon.m
//  TapKit
//
//  Created by Wu Kevin on 4/25/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import "TKCoreCommon.h"



#pragma mark - Version

NSComparisonResult TKCompareVersion(NSString *version1, NSString *version2)
{
  NSArray *components1 = [version1 componentsSeparatedByString:@"."];
  NSArray *components2 = [version2 componentsSeparatedByString:@"."];
  
  int count = MIN( [components1 count], [components2 count] );
  
  for ( int i=0; i<count; ++i ) {
    int component1 = [[components1 objectAtIndex:i] intValue];
    int component2 = [[components2 objectAtIndex:i] intValue];
    
    if ( component1 > component2 ) {
      return NSOrderedDescending;
    } else if ( component1 < component2 ) {
      return NSOrderedAscending;
    }
    
  }
  
  return NSOrderedSame;
}

int TKMajorVersion(NSString *version)
{
  NSArray *components = [version componentsSeparatedByString:@"."];
  if ( [components count] >= 1 ) {
    return [[components objectAtIndex:0] intValue];
  }
  return 0;
}

int TKMinorVersion(NSString *version)
{
  NSArray *components = [version componentsSeparatedByString:@"."];
  if ( [components count] >= 2 ) {
    return [[components objectAtIndex:1] intValue];
  }
  return 0;
}

int TKBugfixVersion(NSString *version)
{
  NSArray *components = [version componentsSeparatedByString:@"."];
  if ( [components count] >= 3 ) {
    return [[components objectAtIndex:2] intValue];
  }
  return 0;
}



#pragma mark - System paths

NSString *TKPathForBundleResource(NSBundle *bundle, NSString *relativePath)
{
  NSString *resourcePath = [( (bundle) ? bundle : [NSBundle mainBundle] ) resourcePath];
  return [resourcePath stringByAppendingPathComponent:relativePath];
}

NSString *TKPathForDocumentsResource(NSString *relativePath)
{
  static NSString *documentsPath = nil;
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    documentsPath = [paths objectAtIndex:0];
  });
  return [documentsPath stringByAppendingPathComponent:relativePath];
}

NSString *TKPathForLibraryResource(NSString *relativePath)
{
  static NSString *libraryPath = nil;
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    libraryPath = [paths objectAtIndex:0];
  });
  return [libraryPath stringByAppendingPathComponent:relativePath];
}

NSString *TKPathForCachesResource(NSString *relativePath)
{
  static NSString *cachesPath = nil;
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    cachesPath = [paths objectAtIndex:0];
  });
  return [cachesPath stringByAppendingPathComponent:relativePath];
}



#pragma mark - Weak collections

NSMutableArray *TKCreateWeakMutableArray()
{
  return (__bridge_transfer NSMutableArray *)CFArrayCreateMutable(nil, 0, nil);
}

NSMutableDictionary *TKCreateWeakMutableDictionary()
{
  return (__bridge_transfer NSMutableDictionary *)CFDictionaryCreateMutable(nil, 0, nil, nil);
}

NSMutableSet *TKCreateWeakMutableSet()
{
  return (__bridge_transfer NSMutableSet *)CFSetCreateMutable(nil, 0, nil);
}



#pragma mark - Object validaty

BOOL TKIsInstance(id object, Class cls)
{
  return ((object)
          && [object isKindOfClass:cls]
          );
}


BOOL TKIsStringWithText(id object)
{
  return ((object)
          && [object isKindOfClass:[NSString class]]
          && ([(NSString *)object length] > 0)
          );
}

BOOL TKIsDataWithBytes(id object)
{
  return ((object)
          && [object isKindOfClass:[NSData class]]
          && ([(NSData *)object length] > 0)
          );
}

BOOL TKIsArrayWithItems(id object)
{
  return ((object)
          && [object isKindOfClass:[NSArray class]]
          && ([(NSArray *)object count] > 0)
          );
}

BOOL TKIsDictionaryWithItems(id object)
{
  return ((object)
          && [object isKindOfClass:[NSDictionary class]]
          && ([(NSDictionary *)object count] > 0)
          );
}

BOOL TKIsSetWithItems(id object)
{
  return ((object)
          && [object isKindOfClass:[NSSet class]]
          && ([(NSSet *)object count] > 0)
          );
}



#pragma mark - Internet date

NSDateFormatter *TKInternetDateFormatter()
{
  static NSDateFormatter *internetDateFormatter = nil;
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    internetDateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [internetDateFormatter setLocale:enUSPOSIXLocale];
    
    [internetDateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    
    [internetDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
  });
  return internetDateFormatter;
}

NSDate *TKDateFromInternetDateString(NSString *string)
{
  return [TKInternetDateFormatter() dateFromString:string];
}

NSString *TKInternetDateStringFromDate(NSDate *date)
{
  return [TKInternetDateFormatter() stringFromDate:date];
}
