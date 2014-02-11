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


void TMRosterHandler::handleItemAdded( const JID& jid )
{
  TKPRINTMETHOD();
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  
  
  RosterItem *item = [engine rosterManager]->getRosterItem(jid);
  
  string displayedname = item->name();
  SubscriptionType subscription = item->subscription();
  Presence::PresenceType highestPresence = Presence::Unavailable;
  if ( item->highestResource() ) highestPresence = item->highestResource()->presence();
  
  NSArray *result = [[engine database] executeQuery:@"SELECT pk FROM t_buddy WHERE bid=?;", OBJCSTR(jid.bare())];
  if ( [result count] > 0 ) {
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
  
  //[engine vcardManager]->fetchVCard(jid, [engine vcardHandler]);
  
  
  NSArray *observers = [engine observers];
  if ( [observers count] > 0 ) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      for ( id<TMEngineDelegate> observer in observers ) {
        if ( [observer respondsToSelector:@selector(engine:handleItemAdded:)] ) {
          [observer engine:engine handleItemAdded:jid];
        }
      }
    });
  }
  
}

void TMRosterHandler::handleItemSubscribed( const JID& jid )
{
  TKPRINTMETHOD();
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  NSArray *observers = [engine observers];
  if ( [observers count] > 0 ) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      for ( id<TMEngineDelegate> observer in observers ) {
        if ( [observer respondsToSelector:@selector(engine:handleItemSubscribed:)] ) {
          [observer engine:engine handleItemSubscribed:jid];
        }
      }
    });
  }
  
}

void TMRosterHandler::handleItemRemoved( const JID& jid )
{
  TKPRINTMETHOD();
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  
  [[engine database] executeUpdate:@"DELETE FROM t_buddy WHERE bid=?;", OBJCSTR(jid.bare())];
  
  
  NSArray *observers = [engine observers];
  if ( [observers count] > 0 ) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      for ( id<TMEngineDelegate> observer in observers ) {
        if ( [observer respondsToSelector:@selector(engine:handleItemRemoved:)] ) {
          [observer engine:engine handleItemRemoved:jid];
        }
      }
    });
  }
  
}

void TMRosterHandler::handleItemUpdated( const JID& jid )
{
  TKPRINTMETHOD();
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  
  
  RosterItem *item = [engine rosterManager]->getRosterItem(jid);
  
  string displayedname = item->name();
  SubscriptionType subscription = item->subscription();
  Presence::PresenceType highestPresence = Presence::Unavailable;
  if ( item->highestResource() ) highestPresence = item->highestResource()->presence();
  
  NSArray *result = [[engine database] executeQuery:@"SELECT pk FROM t_buddy WHERE bid=?;", OBJCSTR(jid.bare())];
  if ( [result count] > 0 ) {
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
  
  //[engine vcardManager]->fetchVCard(jid, [engine vcardHandler]);
  
  
  NSArray *observers = [engine observers];
  if ( [observers count] > 0 ) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      for ( id<TMEngineDelegate> observer in observers ) {
        if ( [observer respondsToSelector:@selector(engine:handleItemUpdated:)] ) {
          [observer engine:engine handleItemUpdated:jid];
        }
      }
    });
  }
  
}

void TMRosterHandler::handleItemUnsubscribed( const JID& jid )
{
  TKPRINTMETHOD();
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  NSArray *observers = [engine observers];
  if ( [observers count] > 0 ) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      for ( id<TMEngineDelegate> observer in observers ) {
        if ( [observer respondsToSelector:@selector(engine:handleItemUnsubscribed:)] ) {
          [observer engine:engine handleItemUnsubscribed:jid];
        }
      }
    });
  }
  
}

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
    
    //[engine vcardManager]->fetchVCard(jid, [engine vcardHandler]);
    
  }
  
  
  NSArray *observers = [engine observers];
  if ( [observers count] > 0 ) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      for ( id<TMEngineDelegate> observer in observers ) {
        if ( [observer respondsToSelector:@selector(engine:handleRoster:)] ) {
          [observer engine:engine handleRoster:roster];
        }
      }
    });
  }
  
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
  
  
  NSArray *observers = [engine observers];
  if ( [observers count] > 0 ) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      for ( id<TMEngineDelegate> observer in observers ) {
        if ( [observer respondsToSelector:@selector(engine:handleRosterPresence:resource:presence:msg:)] ) {
          [observer engine:engine
      handleRosterPresence:item
                  resource:resource
                  presence:presence
                       msg:msg];
        }
      }
    });
  }
  
}

void TMRosterHandler::handleSelfPresence( const RosterItem& item, const std::string& resource,
                                          Presence::PresenceType presence, const std::string& msg )
{
  TKPRINTMETHOD();
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  
  NSArray *observers = [engine observers];
  if ( [observers count] > 0 ) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      for ( id<TMEngineDelegate> observer in observers ) {
        if ( [observer respondsToSelector:@selector(engine:handleSelfPresence:resource:presence:msg:)] ) {
          [observer engine:engine
        handleSelfPresence:item
                  resource:resource
                  presence:presence
                       msg:msg];
        }
      }
    });
  }
  
}

bool TMRosterHandler::handleSubscriptionRequest( const JID& jid, const std::string& msg )
{
  TKPRINTMETHOD();
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  
  NSArray *observers = [engine observers];
  if ( [observers count] > 0 ) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      for ( id<TMEngineDelegate> observer in observers ) {
        if ( [observer respondsToSelector:@selector(engine:handleSubscriptionRequest:msg:)] ) {
          [observer engine:engine
 handleSubscriptionRequest:jid
                       msg:msg];
        }
      }
    });
  }
  
  return true;
}

bool TMRosterHandler::handleUnsubscriptionRequest( const JID& jid, const std::string& msg )
{
  TKPRINTMETHOD();
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  
  NSArray *observers = [engine observers];
  if ( [observers count] > 0 ) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      for ( id<TMEngineDelegate> observer in observers ) {
        if ( [observer respondsToSelector:@selector(engine:handleUnsubscriptionRequest:msg:)] ) {
          [observer engine:engine
handleUnsubscriptionRequest:jid
                       msg:msg];
        }
      }
    });
  }
  
  return true;
}

void TMRosterHandler::handleNonrosterPresence( const Presence& presence )
{
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  
  NSArray *observers = [engine observers];
  if ( [observers count] > 0 ) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      for ( id<TMEngineDelegate> observer in observers ) {
        if ( [observer respondsToSelector:@selector(engine:handleNonrosterPresence:)] ) {
          [observer engine:engine handleNonrosterPresence:presence];
        }
      }
    });
  }
}

void TMRosterHandler::handleRosterError( const IQ& iq )
{
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  
  NSArray *observers = [engine observers];
  if ( [observers count] > 0 ) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      for ( id<TMEngineDelegate> observer in observers ) {
        if ( [observer respondsToSelector:@selector(engine:handleRosterError:)] ) {
          [observer engine:engine handleRosterError:iq];
        }
      }
    });
  }
}

