//
//  TMCommon.mm
//  Teemo
//
//  Created by Wu Kevin on 11/5/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "TMCommon.h"
#import "TMConfig.h"
#import "TMEngine.h"


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



void TMSetUpDatabase()
{
  TKDatabase *database = [[TMEngine sharedEngine] database];
  
  if ( ![database hasTableNamed:@"t_buddy"] ) {
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
    [database executeUpdate:sql];
  }
  
  if ( ![database hasTableNamed:@"t_session"] ) {
    NSString *sql =
    @"CREATE TABLE t_session( "
    @"pk INTEGER PRIMARY KEY, "
    @"jid TEXT, "
    @"date TEXT "
    @");";
    [database executeUpdate:sql];
  }
  
  if ( ![database hasTableNamed:@"t_message"] ) {
    NSString *sql =
    @"CREATE TABLE t_message( "
    @"pk INTEGER PRIMARY KEY, "
    @"passport TEXT, "
    @"content TEXT, "
    @"date TEXT, "
    @"read INTEGER "
    @");";
    [database executeUpdate:sql];
  }
}

void TMClearDatabase()
{
  TKDatabase *database = [[TMEngine sharedEngine] database];
  
  [database executeUpdate:@"DELETE FROM t_buddy;"];
  [database executeUpdate:@"DELETE FROM t_session;"];
  [database executeUpdate:@"DELETE FROM t_message;"];
  
}

