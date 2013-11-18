//
//  TMRosterHandler.mm
//  Teemo
//
//  Created by Wu Kevin on 11/12/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "TMRosterHandler.h"
#import "TMMacro.h"
#import "TMRosterDelegate.h"
#import "TMEngine.h"


void TMRosterHandler::handleItemAdded( const JID& jid )
{
  TMPRINTMETHOD();
  TMEngine *engine = [TMEngine sharedEngine];
  RosterManager *manager = [engine rosterManager];
  Roster *roster = manager->roster();
  
  map<const string, RosterItem*>::const_iterator it = roster->begin();
  
  for ( ; it != roster->end(); ++it ) {
    
    JID jid( it->first );
    string bare = jid.bare();
    
    RosterItem *item = it->second;
    string groupname = item->groups().front();
    if ( groupname.length() <= 0 ) {
      groupname = string( "Friends" );
    }
    
    string displayname = item->name();
    
    TMPRINT("BUDDY: %s %s %s\n", bare.c_str(), groupname.c_str(), displayname.c_str());
    
    
//    TKDatabase *db = [TKDatabase sharedObject];
//    [db executeUpdate:@"INSERT INTO tBuddy(bid,displayname,groupname) VALUES(?,?,?);", OBJCSTR(bare), OBJCSTR(displayname), OBJCSTR(groupname)];
//    
//    TMEngine *engine = [TMEngine sharedEngine];
//    VCardManager *manager = [engine vcardManager];
//    manager->fetchVCard(JID( bare ), [engine vcardHandler]);
    
    
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
  
  TKDatabase *db = [TKDatabase sharedObject];
  [db executeUpdate:@"DELETE FROM tBuddy;"];
  
  
  map<const string, RosterItem*>::const_iterator it = roster.begin();
  
  for ( ; it != roster.end(); ++it ) {
    
    JID jid( it->first );
    string bare = jid.bare();
    
    RosterItem *item = it->second;
    string groupname = item->groups().front();
    if ( groupname.length() <= 0 ) {
      groupname = string( "Friends" );
    }
    
    string displayname = item->name();
    
    TMPRINT("BUDDY: %s %s %s\n", bare.c_str(), groupname.c_str(), displayname.c_str());
    
    
    [db executeUpdate:@"INSERT INTO tBuddy(bid,displayname,groupname) VALUES(?,?,?);", OBJCSTR(bare), OBJCSTR(displayname), OBJCSTR(groupname)];
    
    TMEngine *engine = [TMEngine sharedEngine];
    VCardManager *manager = [engine vcardManager];
    manager->fetchVCard(JID( bare ), [engine vcardHandler]);
    
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
