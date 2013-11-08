//
//  TKDatabase.h
//  TapKit
//
//  Created by Wu Kevin on 4/29/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Core/Core.h"
#import "Additions/Additions.h"

#import "TKDatabaseRow.h"

@interface TKDatabase : NSObject {
  NSString *_path;
  
  sqlite3 *_handle;
  
  BOOL _opened;
  
  NSLock *_lock;
}

@property (nonatomic, copy) NSString *path;

@property (nonatomic, assign) sqlite3 *handle;


///-------------------------------
/// Singleton
///-------------------------------

+ (TKDatabase *)sharedObject;


///-------------------------------
/// Sqlite connection
///-------------------------------

- (BOOL)open;
- (void)close;


///-------------------------------
/// Database routines
///-------------------------------

- (BOOL)executeUpdate:(NSString *)sql, ...;
- (BOOL)executeUpdate:(NSString *)sql parameters:(NSArray *)parameters;

- (NSArray *)executeQuery:(NSString *)sql, ...;
- (NSArray *)executeQuery:(NSString *)sql parameters:(NSArray *)parameters;


///-------------------------------
/// Error infomation
///-------------------------------

- (NSString *)lastErrorMessage;
- (int)lastErrorCode;
- (BOOL)hadError;


///-------------------------------
/// Database status
///-------------------------------

+ (BOOL)isSQLiteThreadSafe;
+ (NSString *)sqliteLibVersion;
- (BOOL)hasTableNamed:(NSString *)tableName;
- (NSUInteger)databaseFileSize;

@end
