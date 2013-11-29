//
//  TMRosterHandler.mm
//  Teemo
//
//  Created by Wu Kevin on 11/12/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#include "TMRosterHandler.h"
#import "TMRosterDelegate.h"

#import "TMMacro.h"

#import "TMEngine.h"


void TMRosterHandler::handleItemAdded( const JID& jid )
{
  TMPRINTMETHOD();
  
  TMEngine *engine = [TMEngine sharedEngine];
  
  Roster *roster = [engine rosterManager]->roster();
  Roster::const_iterator it = roster->begin();
  
  for ( ; it != roster->end(); ++it ) {
    
    JID tmp( it->first );
    RosterItem *item = it->second;
    
    if ( jid.bare() == tmp.bare() ) {
      
      saveRosterItemIntoDatabase(item);
      
      [engine vcardManager]->fetchVCard(JID( tmp.bare() ), [engine vcardHandler]);
      
    }
    
  }
  
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMRosterDelegate> delegate = (__bridge id<TMRosterDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(rosterOnItemAdded:)] ) {
        [delegate rosterOnItemAdded:jid];
      }
    }
    
  });
  
}

void TMRosterHandler::handleItemSubscribed( const JID& jid )
{
  TMPRINTMETHOD();
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMRosterDelegate> delegate = (__bridge id<TMRosterDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(rosterOnItemSubscribed:)] ) {
        [delegate rosterOnItemSubscribed:jid];
      }
    }
    
  });
  
}

void TMRosterHandler::handleItemRemoved( const JID& jid )
{
  TMPRINTMETHOD();
  
  TMEngine *engine = [TMEngine sharedEngine];
  [[engine database] executeUpdate:@"DELETE FROM tBuddy WHERE bid=?;", OBJCSTR(jid.bare())];
  
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMRosterDelegate> delegate = (__bridge id<TMRosterDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(rosterOnItemRemoved:)] ) {
        [delegate rosterOnItemRemoved:jid];
      }
    }
    
  });
  
}

void TMRosterHandler::handleItemUpdated( const JID& jid )
{
  TMPRINTMETHOD();
  
  TMEngine *engine = [TMEngine sharedEngine];
  
  Roster *roster = [engine rosterManager]->roster();
  Roster::const_iterator it = roster->begin();
  
  for ( ; it!=roster->end(); ++it ) {
    
    JID tmp( it->first );
    RosterItem *item = it->second;
    
    if ( jid.bare() == tmp.bare() ) {
      
      saveRosterItemIntoDatabase(item);
      
      [engine vcardManager]->fetchVCard(JID( tmp.bare() ), [engine vcardHandler]);
      
    }
    
  }
  
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMRosterDelegate> delegate = (__bridge id<TMRosterDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(rosterOnItemUpdated:)] ) {
        [delegate rosterOnItemUpdated:jid];
      }
    }
    
  });
  
}

void TMRosterHandler::handleItemUnsubscribed( const JID& jid )
{
  TMPRINTMETHOD();
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMRosterDelegate> delegate = (__bridge id<TMRosterDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(rosterOnItemUnsubscribed:)] ) {
        [delegate rosterOnItemUnsubscribed:jid];
      }
    }
    
  });
  
}

void TMRosterHandler::handleRoster( const Roster& roster )
{
  TMPRINTMETHOD();
  
  TMEngine *engine = [TMEngine sharedEngine];
  
  [[engine database] executeUpdate:@"DELETE FROM tBuddy;"];
  
  Roster::const_iterator it = roster.begin();
  
  for ( ; it!=roster.end(); ++it ) {
    
    JID jid( it->first );
    RosterItem *item = it->second;
    
    string groupname = item->groups().front();
    string displayname = item->name();
    SubscriptionType subscription = item->subscription();
    const RosterItem::ResourceMap map = item->resources();
    RosterItem::ResourceMap::const_iterator aa = map.begin();
    for ( ; aa!=map.end(); ++aa ) {
      string first = aa->first;
      Resource *res = aa->second;
      printf("%s %s %d\n", first.c_str(), res->message().c_str(), res->presence());
    }
    
    TMPRINT("BUDDY: %s %s %s %d\n", jid.bare().c_str(), groupname.c_str(), displayname.c_str(), subscription);
    
    
    [[engine database] executeUpdate:@"INSERT INTO tBuddy(bid,displayname,groupname,subscription) VALUES(?,?,?,?);",
     OBJCSTR(jid.bare()),
     OBJCSTR(displayname),
     OBJCSTR(groupname),
     [NSNumber numberWithInt:subscription]];
    
    [engine vcardManager]->fetchVCard(JID( jid.bare() ), [engine vcardHandler]);
    
  }
  
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMRosterDelegate> delegate = (__bridge id<TMRosterDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(rosterOnReceived:)] ) {
        [delegate rosterOnReceived:roster];
      }
    }
    
  });
  
}

void TMRosterHandler::handleRosterPresence( const RosterItem& item, const std::string& resource,
                                            Presence::PresenceType presence, const std::string& msg )
{
  TMPRINTMETHOD();
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMRosterDelegate> delegate = (__bridge id<TMRosterDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(rosterOnPresence:resource:presence:msg:)] ) {
        [delegate rosterOnPresence:item
                          resource:resource
                          presence:presence
                               msg:msg];
      }
    }
    
  });
  
}

void TMRosterHandler::handleSelfPresence( const RosterItem& item, const std::string& resource,
                                          Presence::PresenceType presence, const std::string& msg )
{
  TMPRINTMETHOD();
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMRosterDelegate> delegate = (__bridge id<TMRosterDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(rosterOnSelfPresence:resource:presence:msg:)] ) {
        [delegate rosterOnSelfPresence:item
                              resource:resource
                              presence:presence
                                   msg:msg];
      }
    }
    
  });
  
}

bool TMRosterHandler::handleSubscriptionRequest( const JID& jid, const std::string& msg )
{
  TMPRINTMETHOD();
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMRosterDelegate> delegate = (__bridge id<TMRosterDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(rosterOnSubscriptionRequest:msg:)] ) {
        [delegate rosterOnSubscriptionRequest:jid msg:msg];
      }
    }
    
  });
  
  return true;
}

bool TMRosterHandler::handleUnsubscriptionRequest( const JID& jid, const std::string& msg )
{
  TMPRINTMETHOD();
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMRosterDelegate> delegate = (__bridge id<TMRosterDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(rosterOnUnsubscriptionRequest:msg:)] ) {
        [delegate rosterOnUnsubscriptionRequest:jid msg:msg];
      }
    }
    
  });
  
  return true;
}

void TMRosterHandler::handleNonrosterPresence( const Presence& presence )
{
  TMPRINTMETHOD();
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMRosterDelegate> delegate = (__bridge id<TMRosterDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(rosterOnNonrosterPresence:)] ) {
        [delegate rosterOnNonrosterPresence:presence];
      }
    }
    
  });
  
}

void TMRosterHandler::handleRosterError( const IQ& iq )
{
  TMPRINTMETHOD();
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMRosterDelegate> delegate = (__bridge id<TMRosterDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(rosterOnError:)] ) {
        [delegate rosterOnError:iq];
      }
    }
    
  });
  
}



void TMRosterHandler::saveRosterItemIntoDatabase(RosterItem *item)
{
  JID jid( item->jidJID() );
  string groupname = item->groups().front();
  string displayname = item->name();
  SubscriptionType subscription = item->subscription();
  
  TMPRINT("BUDDY: %s %s %s %d\n", jid.bare().c_str(), groupname.c_str(), displayname.c_str(), subscription);
  
  TMEngine *engine = [TMEngine sharedEngine];
  NSArray *buddies = [[engine database] executeQuery:@"SELECT pk FROM tBuddy WHERE bid=?;", OBJCSTR(jid.bare())];
  if ( [buddies count] > 0 ) {
    
    [[engine database] executeUpdate:@"UPDATE tBuddy SET displayname=?, groupname=?, subscription=? WHERE bid=?;",
     OBJCSTR(displayname),
     OBJCSTR(groupname),
     [NSNumber numberWithInt:subscription],
     OBJCSTR(jid.bare())];
    
  } else {
    
    [[engine database] executeUpdate:@"INSERT INTO tBuddy(bid,displayname,groupname,subscription) VALUES(?,?,?,?);",
     OBJCSTR(jid.bare()),
     OBJCSTR(displayname),
     OBJCSTR(groupname),
     [NSNumber numberWithInt:subscription]];
    
  }
}
