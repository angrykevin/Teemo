//
//  TMAccountContext.h
//  Teemo
//
//  Created by Wu Kevin on 2/11/14.
//  Copyright (c) 2014 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMAccountContext : NSObject {
  NSString *_passport;
  
  TKDatabase *_database;
  
}

@property (nonatomic, copy, readonly) NSString *passport;

@property (nonatomic, strong, readonly) TKDatabase *database;


- (id)initWithPassport:(NSString *)pspt;

- (NSString *)saveImage:(NSData *)image;
- (NSString *)saveAudio:(NSData *)audio;
- (NSString *)saveVideo:(NSData *)video;

- (void)remove;

@end
