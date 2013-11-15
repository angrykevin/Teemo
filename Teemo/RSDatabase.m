//
//  RSDatabase.m
//  Teemo
//
//  Created by Wu Kevin on 11/13/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSDatabase.h"

NSString *RSDatabasePath()
{
  NSString *name = @"teemo.db";
  return TKPathForDocumentsResource(name);
}

void RSDatabaseCreate()
{
  TKDatabase *db = [TKDatabase sharedObject];
  db.path = RSDatabasePath();
  [db open];
}

void RSDatabaseSetUpTables()
{
  TKDatabase *db = [TKDatabase sharedObject];
  
  if ( ![db hasTableNamed:@"tBuddy"] ) {
    NSString *sql = @"CREATE TABLE tBuddy( pk INTEGER PRIMARY KEY, bid TEXT, nickname TEXT, familyname TEXT, givenname TEXT, photo TEXT, birthday TEXT, desc TEXT, homepage TEXT );";
    [db executeUpdate:sql];
  }
  
  if ( ![db hasTableNamed:@"tChatlog"] ) {
    NSString *sql = @"CREATE TABLE tChatlog( pk INTEGER PRIMARY KEY, passport TEXT, date TEXT );";
    [db executeUpdate:sql];
  }
  
  if ( ![db hasTableNamed:@"tMessage"] ) {
    NSString *sql = @"CREATE TABLE tMessage( pk INTEGER PRIMARY KEY, passport TEXT, content TEXT, date TEXT, read INTEGER );";
    [db executeUpdate:sql];
  }
  
}

void RSDatabaseClearData()
{
  TKDatabase *db = [TKDatabase sharedObject];
  
  [db executeUpdate:@"DELETE FROM tBuddy;"];
  [db executeUpdate:@"DELETE FROM tChatlog;"];
  [db executeUpdate:@"DELETE FROM tMessage;"];
  
}
