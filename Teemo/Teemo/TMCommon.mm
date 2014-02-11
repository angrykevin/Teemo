//
//  TMCommon.mm
//  Teemo
//
//  Created by Wu Kevin on 11/5/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "TMCommon.h"
#import "TMConfig.h"


NSString *TMJIDFromPassport(NSString *pspt)
{
  if ( [pspt length] > 0 ) {
    NSMutableString *jid = [[NSMutableString alloc] init];
    [jid appendString:pspt];
    [jid appendString:TMXMPPServerDomain];
    return jid;
  }
  return nil;
}


void TMInitiateTeemo()
{
  // Root directory
  NSString *teemoRoot = TKPathForDocumentsResource(@"Teemo");
  if ( ![[NSFileManager defaultManager] fileExistsAtPath:teemoRoot isDirectory:NULL] ) {
    [[NSFileManager defaultManager] createDirectoryAtPath:teemoRoot
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
  }
  
}



void TMSetupContextForAccount(NSString *pspt)
{
  // Account root directory
  NSString *accountRoot = TKPathForDocumentsResource(pspt);
  if ( ![[NSFileManager defaultManager] fileExistsAtPath:accountRoot isDirectory:NULL] ) {
    [[NSFileManager defaultManager] createDirectoryAtPath:accountRoot
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
  }
}

void TMDeleteContextByAccount(NSString *pspt)
{
}

TKDatabase *TMCreateDatabaseForAccount(NSString *pspt)
{
  return nil;
}


TKDatabase *TMCreateDatabase(NSString *name)
{
  NSString *relativePath = [NSString stringWithFormat:@"Teemo/%@.db", name];
  TKDatabase *db = [[TKDatabase alloc] init];
  db.path = TKPathForDocumentsResource(relativePath);
  [db open];
  return db;
}

void TMDeleteDatabase(NSString *name)
{
  NSString *relativePath = [NSString stringWithFormat:@"Teemo/%@.db", name];
  NSString *path = TKPathForDocumentsResource(relativePath);
}

void TMSetUpDatabase(TKDatabase *db)
{
  
  if ( ![db hasTableNamed:@"t_buddy"] ) {
    NSString *sql =
    @"CREATE TABLE t_buddy( "
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
    @"homepage TEXT"
    @");";
    [db executeUpdate:sql];
  }
  
  if ( ![db hasTableNamed:@"t_session"] ) {
    NSString *sql =
    @"CREATE TABLE t_session( "
    @"pk INTEGER PRIMARY KEY, "
    @"jid TEXT, "
    @"date TEXT "
    @");";
    [db executeUpdate:sql];
  }
  
  if ( ![db hasTableNamed:@"t_message"] ) {
    NSString *sql =
    @"CREATE TABLE t_message( "
    @"pk INTEGER PRIMARY KEY, "
    @"passport TEXT, "
    @"content TEXT, "
    @"date TEXT, "
    @"read INTEGER "
    @");";
    [db executeUpdate:sql];
  }
}

void TMClearDatabase(TKDatabase *db)
{
  [db executeUpdate:@"DELETE FROM t_buddy;"];
  [db executeUpdate:@"DELETE FROM t_session;"];
  [db executeUpdate:@"DELETE FROM t_message;"];
}

