//
//  TMAccountContext.m
//  Teemo
//
//  Created by Wu Kevin on 2/11/14.
//  Copyright (c) 2014 xbcx. All rights reserved.
//

#import "TMAccountContext.h"

@implementation TMAccountContext

- (id)initWithPassport:(NSString *)pspt
{
  self = [super init];
  if (self) {
    
    _passport = [pspt copy];
    
    [self createDirectories];
    [self initiateDatabase];
    
  }
  return self;
}


- (NSString *)saveImage:(NSData *)image
{
  if ( [image length] > 0 ) {
    NSString *relativePath = [NSString stringWithFormat:@"Teemo/%@/image/%@", _passport, [NSString UUIDString]];
    NSString *path = TKPathForDocumentsResource(relativePath);
    if ( [image writeToFile:path atomically:YES] ) {
      return path;
    }
  }
  return nil;
}

- (NSString *)saveAudio:(NSData *)audio
{
  if ( [audio length] > 0 ) {
    NSString *relativePath = [NSString stringWithFormat:@"Teemo/%@/audio/%@", _passport, [NSString UUIDString]];
    NSString *path = TKPathForDocumentsResource(relativePath);
    if ( [audio writeToFile:path atomically:YES] ) {
      return path;
    }
  }
  return nil;
}

- (NSString *)saveVideo:(NSData *)video
{
  if ( [video length] > 0 ) {
    NSString *relativePath = [NSString stringWithFormat:@"Teemo/%@/video/%@", _passport, [NSString UUIDString]];
    NSString *path = TKPathForDocumentsResource(relativePath);
    if ( [video writeToFile:path atomically:YES] ) {
      return path;
    }
  }
  return nil;
}


- (void)remove
{
  NSString *relativeRootPath = [NSString stringWithFormat:@"Teemo/%@", _passport];
  NSString *rootPath = TKPathForDocumentsResource(relativeRootPath);
  [[NSFileManager defaultManager] removeItemAtPath:rootPath error:NULL];
}



- (void)createDirectories
{
  // Account root directory
  NSString *relativeRootPath = [NSString stringWithFormat:@"Teemo/%@", _passport];
  NSString *rootPath = TKPathForDocumentsResource(relativeRootPath);
  if ( ![[NSFileManager defaultManager] fileExistsAtPath:rootPath isDirectory:NULL] ) {
    [[NSFileManager defaultManager] createDirectoryAtPath:rootPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
  }
  
  // Image directory
  NSString *relativeImagePath = [NSString stringWithFormat:@"Teemo/%@/image", _passport];
  NSString *imagePath = TKPathForDocumentsResource(relativeImagePath);
  if ( ![[NSFileManager defaultManager] fileExistsAtPath:imagePath isDirectory:NULL] ) {
    [[NSFileManager defaultManager] createDirectoryAtPath:imagePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
  }
  
  // Audio directory
  NSString *relativeAudioPath = [NSString stringWithFormat:@"Teemo/%@/audio", _passport];
  NSString *audioPath = TKPathForDocumentsResource(relativeAudioPath);
  if ( ![[NSFileManager defaultManager] fileExistsAtPath:audioPath isDirectory:NULL] ) {
    [[NSFileManager defaultManager] createDirectoryAtPath:audioPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
  }
  
  // Video directory
  NSString *relativeVideoPath = [NSString stringWithFormat:@"Teemo/%@/video", _passport];
  NSString *videoPath = TKPathForDocumentsResource(relativeVideoPath);
  if ( ![[NSFileManager defaultManager] fileExistsAtPath:videoPath isDirectory:NULL] ) {
    [[NSFileManager defaultManager] createDirectoryAtPath:videoPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
  }
  
}

- (void)initiateDatabase
{
  // Create database
  NSString *relativePath = [NSString stringWithFormat:@"Teemo/%@/im.db", _passport];
  _database = [[TKDatabase alloc] init];
  _database.path = TKPathForDocumentsResource(relativePath);
  [_database open];
  
  // Create database tables
  if ( ![_database hasTableNamed:@"t_buddy"] ) {
    NSString *sql =
    @"CREATE TABLE t_buddy("
    @"pk INTEGER PRIMARY KEY, "
    @"bid TEXT, "
    @"displayedname TEXT, "
    @"subscription INTEGER, "
    @"presence INTEGER, "
    
    @"nickname TEXT, "
    @"familyname TEXT, "
    @"givenname TEXT, "
    @"photo TEXT, "
    @"birthday TEXT, "
    @"desc TEXT, "
    @"homepage TEXT, "
    @"note TEXT"
    @");";
    [_database executeUpdate:sql];
  }
  
  if ( ![_database hasTableNamed:@"t_request"] ) {
    NSString *sql =
    @"CREATE TABLE t_request("
    @"pk INTEGER PRIMARY KEY, "
    @"bid TEXT, "
    @"date TEXT"
    @");";
    [_database executeUpdate:sql];
  }
  
  if ( ![_database hasTableNamed:@"t_request_message"] ) {
    NSString *sql =
    @"CREATE TABLE t_request_message("
    @"pk INTEGER PRIMARY KEY, "
    @"bid TEXT, "
    @"content TEXT, "
    @"read INTEGER, "
    @"date TEXT"
    @");";
    [_database executeUpdate:sql];
  }
  
  if ( ![_database hasTableNamed:@"t_session"] ) {
    NSString *sql =
    @"CREATE TABLE t_session("
    @"pk INTEGER PRIMARY KEY, "
    @"bid TEXT, "
    @"date TEXT"
    @");";
    [_database executeUpdate:sql];
  }
  
  if ( ![_database hasTableNamed:@"t_message"] ) {
    NSString *sql =
    @"CREATE TABLE t_message("
    @"pk INTEGER PRIMARY KEY, "
    @"bid TEXT, "
    @"content TEXT, "
    @"date TEXT, "
    @"read INTEGER"
    @");";
    [_database executeUpdate:sql];
  }
  
}

@end
