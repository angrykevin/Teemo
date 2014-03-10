//
//  TMRosterHandler.mm
//  Teemo
//
//  Created by Wu Kevin on 11/12/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#include "TMRosterHandler.h"
#import "TMEngine.h"
#import "TMCommon.h"


void TMRosterHandler::handleRoster( const Roster& roster )
{
  TKPRINTMETHOD();
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  [[engine database] executeUpdate:@"DELETE FROM t_buddy;"];
  
  Roster::const_iterator it = roster.begin();
  for ( ; it!=roster.end(); ++it ) {
    
    JID jid( it->first );
    RosterItem *item = it->second;
    
    string displayedname = item->name();
    SubscriptionType subscription = item->subscription();
    Presence::PresenceType highestPresence = Presence::Unavailable;
    if ( item->highestResource() ) highestPresence = item->highestResource()->presence();
    
    [[engine database] executeUpdate:@"INSERT INTO t_buddy(bid, displayedname, subscription, presence) VALUES(?, ?, ?, ?);",
     OBJCSTR(jid.bare()),
     OBJCSTR(displayedname),
     [NSNumber numberWithInt:subscription],
     [NSNumber numberWithInt:highestPresence]];
    
    [engine requestVCard:OBJCSTR(jid.bare())];
    
  }
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    for ( id<TMEngineDelegate> observer in [engine observers] ) {
      if ( [observer respondsToSelector:@selector(engineHandleRoster:)] ) {
        [observer engineHandleRoster:engine];
      }
    }
  });
  
}

void TMRosterHandler::handleRosterError( const IQ& iq )
{
  TKPRINTMETHOD();
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSError *error = [[NSError alloc] initWithDomain:@"Roster" code:iq.error()->error() userInfo:nil];
    for ( id<TMEngineDelegate> observer in [engine observers] ) {
      if ( [observer respondsToSelector:@selector(engine:handleRosterError:)] ) {
        [observer engine:engine handleRosterError:error];
      }
    }
  });
  
}

void TMRosterHandler::handleItemAdded( const JID& jid )
{
  TKPRINTMETHOD();
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  
  
  RosterManager *rosterManager = (RosterManager *)[engine rosterManager];
  RosterItem *item = rosterManager->getRosterItem(jid);
  
  string displayedname = item->name();
  SubscriptionType subscription = item->subscription();
  Presence::PresenceType highestPresence = Presence::Unavailable;
  if ( item->highestResource() ) highestPresence = item->highestResource()->presence();
  
  NSString *sql = [[NSString alloc] initWithFormat:@"SELECT pk FROM t_buddy WHERE bid='%@';", OBJCSTR(jid.bare())];
  if ( [[engine database] hasRowForSQLStatement:sql] ) {
    [[engine database] executeUpdate:@"UPDATE t_buddy SET displayedname=?, subscription=?, presence=? WHERE bid=?;",
     OBJCSTR(displayedname),
     [NSNumber numberWithInt:subscription],
     [NSNumber numberWithInt:highestPresence],
     OBJCSTR(jid.bare())];
  } else {
    [[engine database] executeUpdate:@"INSERT INTO t_buddy(bid, displayedname, subscription, presence) VALUES(?, ?, ?, ?);",
     OBJCSTR(jid.bare()),
     OBJCSTR(displayedname),
     [NSNumber numberWithInt:subscription],
     [NSNumber numberWithInt:highestPresence]];
  }
  
  [engine requestVCard:OBJCSTR(jid.bare())];
  
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    for ( id<TMEngineDelegate> observer in [engine observers] ) {
      if ( [observer respondsToSelector:@selector(engine:handleItemAdded:)] ) {
        [observer engine:engine handleItemAdded:OBJCSTR(jid.bare())];
      }
    }
  });
  
}

void TMRosterHandler::handleItemRemoved( const JID& jid )
{
  TKPRINTMETHOD();
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  
  [[engine database] executeUpdate:@"DELETE FROM t_buddy WHERE bid=?;", OBJCSTR(jid.bare())];
  [[engine database] executeUpdate:@"DELETE FROM t_message WHERE bid=?;", OBJCSTR(jid.bare())];
  // TODO: 删除其它的东西
  
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    for ( id<TMEngineDelegate> observer in [engine observers] ) {
      if ( [observer respondsToSelector:@selector(engine:handleItemRemoved:)] ) {
        [observer engine:engine handleItemRemoved:OBJCSTR(jid.bare())];
      }
    }
  });
  
}

void TMRosterHandler::handleItemUpdated( const JID& jid )
{
  TKPRINTMETHOD();
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  
  
  RosterManager *rosterManager = (RosterManager *)[engine rosterManager];
  RosterItem *item = rosterManager->getRosterItem(jid);
  
  string displayedname = item->name();
  SubscriptionType subscription = item->subscription();
  Presence::PresenceType highestPresence = Presence::Unavailable;
  if ( item->highestResource() ) highestPresence = item->highestResource()->presence();
  
  NSString *sql = [[NSString alloc] initWithFormat:@"SELECT pk FROM t_buddy WHERE bid='%@';", OBJCSTR(jid.bare())];
  if ( [[engine database] hasRowForSQLStatement:sql] ) {
    [[engine database] executeUpdate:@"UPDATE t_buddy SET displayedname=?, subscription=?, presence=? WHERE bid=?;",
     OBJCSTR(displayedname),
     [NSNumber numberWithInt:subscription],
     [NSNumber numberWithInt:highestPresence],
     OBJCSTR(jid.bare())];
  } else {
    [[engine database] executeUpdate:@"INSERT INTO t_buddy(bid, displayedname, subscription, presence) VALUES(?, ?, ?, ?);",
     OBJCSTR(jid.bare()),
     OBJCSTR(displayedname),
     [NSNumber numberWithInt:subscription],
     [NSNumber numberWithInt:highestPresence]];
  }
  
  [engine requestVCard:OBJCSTR(jid.bare())];
  
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    for ( id<TMEngineDelegate> observer in [engine observers] ) {
      if ( [observer respondsToSelector:@selector(engine:handleItemUpdated:)] ) {
        [observer engine:engine handleItemUpdated:OBJCSTR(jid.bare())];
      }
    }
  });
  
}

void TMRosterHandler::handleItemSubscribed( const JID& jid )
{
  TKPRINTMETHOD();
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    for ( id<TMEngineDelegate> observer in [engine observers] ) {
      if ( [observer respondsToSelector:@selector(engine:handleItemSubscribed:)] ) {
        [observer engine:engine handleItemSubscribed:OBJCSTR(jid.bare())];
      }
    }
  });
  
}

void TMRosterHandler::handleItemUnsubscribed( const JID& jid )
{
  TKPRINTMETHOD();
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    for ( id<TMEngineDelegate> observer in [engine observers] ) {
      if ( [observer respondsToSelector:@selector(engine:handleItemUnsubscribed:)] ) {
        [observer engine:engine handleItemUnsubscribed:OBJCSTR(jid.bare())];
      }
    }
  });
  
}

bool TMRosterHandler::handleSubscriptionRequest( const JID& jid, const std::string& msg )
{
  TKPRINTMETHOD();
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  
  NSArray *result = [[engine database] executeQuery:@"SELECT pk FROM t_request WHERE bid=?;", OBJCSTR(jid.bare())];
  if ( [result count] > 0 ) {
    [[engine database] executeUpdate:@"UPDATE t_request SET date=? WHERE bid=?;",
     TKInternetDateStringFromDate([NSDate date]),
     OBJCSTR(jid.bare())];
  } else {
    [[engine database] executeUpdate:@"INSERT INTO t_request(bid, date) VALUES(?, ?);",
     OBJCSTR(jid.bare()),
     TKInternetDateStringFromDate([NSDate date])];
  }
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    for ( id<TMEngineDelegate> observer in [engine observers] ) {
      if ( [observer respondsToSelector:@selector(engine:handleSubscriptionRequest:)] ) {
        [observer engine:engine handleSubscriptionRequest:OBJCSTR(jid.bare())];
      }
    }
  });
  
  return true;
}

bool TMRosterHandler::handleUnsubscriptionRequest( const JID& jid, const std::string& msg )
{
  TKPRINTMETHOD();
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  
  [[engine database] executeUpdate:@"DELETE FROM t_request WHERE bid=?;", OBJCSTR(jid.bare())];
  [[engine database] executeUpdate:@"DELETE FROM t_request_message WHERE bid=?;", OBJCSTR(jid.bare())];
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    for ( id<TMEngineDelegate> observer in [engine observers] ) {
      if ( [observer respondsToSelector:@selector(engine:handleUnsubscriptionRequest:)] ) {
        [observer engine:engine handleUnsubscriptionRequest:OBJCSTR(jid.bare())];
      }
    }
  });
  
  return true;
}

void TMRosterHandler::handleRosterPresence( const RosterItem& item, const std::string& resource,
                                            Presence::PresenceType presence, const std::string& msg )
{
  TKPRINTMETHOD();
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  
  string displayedname = item.name();
  SubscriptionType subscription = item.subscription();
  Presence::PresenceType highestPresence = Presence::Unavailable;
  if ( item.highestResource() ) highestPresence = item.highestResource()->presence();
  
  NSArray *result = [[engine database] executeQuery:@"SELECT pk FROM t_buddy WHERE bid=?;", OBJCSTR(item.jidJID().bare())];
  if ( [result count] > 0 ) {
    [[engine database] executeUpdate:@"UPDATE t_buddy SET displayedname=?, subscription=?, presence=? WHERE bid=?;",
     OBJCSTR(displayedname),
     [NSNumber numberWithInt:subscription],
     [NSNumber numberWithInt:highestPresence],
     OBJCSTR(item.jidJID().bare())];
  }
  
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    for ( id<TMEngineDelegate> observer in [engine observers] ) {
      if ( [observer respondsToSelector:@selector(engine:handlePresence:)] ) {
        [observer engine:engine handlePresence:OBJCSTR(item.jidJID().bare())];
      }
    }
  });
  
}

void TMRosterHandler::handleSelfPresence( const RosterItem& item, const std::string& resource,
                                          Presence::PresenceType presence, const std::string& msg )
{
  TKPRINTMETHOD();
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  
  string displayedname = item.name();
  SubscriptionType subscription = item.subscription();
  Presence::PresenceType highestPresence = Presence::Unavailable;
  if ( item.highestResource() ) highestPresence = item.highestResource()->presence();
  
  NSArray *result = [[engine database] executeQuery:@"SELECT pk FROM t_buddy WHERE bid=?;", OBJCSTR(item.jidJID().bare())];
  if ( [result count] > 0 ) {
    [[engine database] executeUpdate:@"UPDATE t_buddy SET displayedname=?, subscription=?, presence=? WHERE bid=?;",
     OBJCSTR(displayedname),
     [NSNumber numberWithInt:subscription],
     [NSNumber numberWithInt:highestPresence],
     OBJCSTR(item.jidJID().bare())];
  }
  
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    for ( id<TMEngineDelegate> observer in [engine observers] ) {
      if ( [observer respondsToSelector:@selector(engine:handlePresence:)] ) {
        [observer engine:engine handlePresence:OBJCSTR(item.jidJID().bare())];
      }
    }
  });
  
}

void TMRosterHandler::handleNonrosterPresence( const Presence& presence )
{
  TKPRINTMETHOD();
//  TMEngine *engine = (__bridge TMEngine *)getEngine();
//  NSArray *observers = [engine observers];
//  if ( [observers count] > 0 ) {
//    dispatch_sync(dispatch_get_main_queue(), ^{
//      for ( id<TMEngineDelegate> observer in observers ) {
//        if ( [observer respondsToSelector:@selector(engine:handleNonrosterPresence:)] ) {
//          [observer engine:engine handleNonrosterPresence:presence];
//        }
//      }
//    });
//  }
}

