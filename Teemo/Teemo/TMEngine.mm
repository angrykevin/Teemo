//
//  TMEngine.m
//  Teemo
//
//  Created by Wu Kevin on 11/5/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "TMEngine.h"

#import "TMConfig.h"
#import "TMMacro.h"
#import "TMCommon.h"


static TMEngine *CurrentEngine = nil;


@implementation TMEngine

+ (TMEngine *)sharedEngine
{
  return CurrentEngine;
}

+ (void)storeEngine:(TMEngine *)engine
{
  CurrentEngine = engine;
}

+ (void)clearStoredEngine
{
  CurrentEngine = nil;
}



- (void)setUpWithPassport:(NSString *)passport password:(NSString *)password
{
  NSAssert([passport length]>0, @"passport error");
  NSAssert([password length]>0, @"password error");
  
  _passport = [passport copy];
  _password = [password copy];
  
  _cancelled = NO;
  
  string jid = CPPSTR(TMJIDFromPassport(passport));
  string pwd = CPPSTR(password);
  string svr = CPPSTR(TMXMPPServerHost);
  int prt = [TMXMPPServerPort intValue];
  
  _client = new Client( JID( jid ), pwd );
  _client->setServer( svr );
  _client->setPort( prt );
  _client->setResource( CPPSTR(TMXMPPClientResource) );
  
  
  _connectionHandler = new TMConnectionHandler;
  _client->registerConnectionListener( _connectionHandler );
  
  _presenceHandler = new TMPresenceHandler;
  _client->registerPresenceHandler( _presenceHandler );
  
  _vcardManager = new VCardManager( _client );
  _vcardHandler = new TMVCardHandler;
  
  _rosterHandler = new TMRosterHandler;
  _client->rosterManager()->registerRosterListener( _rosterHandler );
  
}

- (BOOL)connect
{
  TKPRINTMETHOD();
  
  if ( _cancelled ) {
    return NO;
  }
  
  [self performSelector:@selector(connectionBody:)
               onThread:[[self class] engineThread]
             withObject:[NSValue valueWithPointer:_client]
          waitUntilDone:NO
                  modes:@[ NSRunLoopCommonModes ]];
  
  
  return YES;
  
}

- (void)disconnect
{
  _cancelled = YES;
  
  _client = NULL;
  
}

- (void)removeAllObservers
{
  _connectionHandler->removeAllObservers();
}


- (void)createDatabase
{
  _database = [[TKDatabase alloc] init];
  _database.path = TKPathForDocumentsResource(@"imdb.db");
  [_database open];
}

- (void)setUpDatabase
{
  if ( ![_database hasTableNamed:@"t_buddy"] ) {
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
    [_database executeUpdate:sql];
  }
  
  if ( ![_database hasTableNamed:@"t_session"] ) {
    NSString *sql =
    @"CREATE TABLE t_session( "
    @"pk INTEGER PRIMARY KEY, "
    @"jid TEXT, "
    @"date TEXT "
    @");";
    [_database executeUpdate:sql];
  }
  
  if ( ![_database hasTableNamed:@"t_message"] ) {
    NSString *sql =
    @"CREATE TABLE t_message( "
    @"pk INTEGER PRIMARY KEY, "
    @"passport TEXT, "
    @"content TEXT, "
    @"date TEXT, "
    @"read INTEGER "
    @");";
    [_database executeUpdate:sql];
  }
}

- (void)clearDatabase
{
  [_database executeUpdate:@"DELETE FROM t_buddy;"];
  [_database executeUpdate:@"DELETE FROM t_session;"];
  [_database executeUpdate:@"DELETE FROM t_message;"];
}


- (BOOL)isBuddyInRoster:(NSString *)bid
{
  if ( [bid length] > 0 ) {
    
    JID jid = JID( CPPSTR(bid) );
    
    Roster *roster = _client->rosterManager()->roster();
    Roster::const_iterator it = roster->begin();
    
    for ( ; it != roster->end(); ++it ) {
      
      JID tmp( it->first );
      
      if ( jid.bare() == tmp.bare() ) {
        return YES;
      }
      
    }
    
  }
  
  return NO;
}



- (NSString *)passport
{
  return _passport;
}

- (NSString *)password
{
  return _password;
}


- (TKDatabase *)database
{
  return _database;
}


- (Client *)client
{
  return _client;
}

- (VCardManager *)vcardManager
{
  return _vcardManager;
}

- (RosterManager *)rosterManager
{
  return _client->rosterManager();
}


- (TMConnectionHandler *)connectionHandler
{
  return _connectionHandler;
}

- (TMPresenceHandler *)presenceHandler
{
  return _presenceHandler;
}

- (TMVCardHandler *)vcardHandler
{
  return _vcardHandler;
}

- (TMRosterHandler *)rosterHandler
{
  return _rosterHandler;
}






- (void)connectionBody:(NSValue *)value
{
  @autoreleasepool {
    
    Client *client = (Client *)[value pointerValue];
    
    if ( client->connect( false ) ) {
      while ( !_cancelled ) {
        client->recv( 1000000 );
      }
      
      client->disconnect();
    }
    
  }
}



+ (NSThread *)engineThread
{
  static NSThread *thread = nil;
  
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    thread = [[NSThread alloc] initWithTarget:self
                                     selector:@selector(threadBody:)
                                       object:nil];
    [thread start];
  });
  
  return thread;
}

+ (void)threadBody:(id)object
{
  while ( YES ) {
    @autoreleasepool {
      [[NSRunLoop currentRunLoop] run];
    }
  }
}

@end
