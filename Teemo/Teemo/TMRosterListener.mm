//
//  TMRosterListener.mm
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#include "TMRosterListener.h"
#include "TMDebug.h"

void TMRosterListener::handleItemAdded( const JID& jid )
{
  TMPRINTMETHOD();
}

void TMRosterListener::handleItemSubscribed( const JID& jid )
{
  TMPRINTMETHOD();
}

void TMRosterListener::handleItemRemoved( const JID& jid )
{
  TMPRINTMETHOD();
}

void TMRosterListener::handleItemUpdated( const JID& jid )
{
  TMPRINTMETHOD();
}

void TMRosterListener::handleItemUnsubscribed( const JID& jid )
{
  TMPRINTMETHOD();
}

void TMRosterListener::handleRoster( const Roster& roster )
{
  TMPRINTMETHOD();
}

void TMRosterListener::handleRosterPresence( const RosterItem& item, const std::string& resource,
                                            Presence::PresenceType presence, const std::string& msg )
{
  TMPRINTMETHOD();
}

void TMRosterListener::handleSelfPresence( const RosterItem& item, const std::string& resource,
                                          Presence::PresenceType presence, const std::string& msg )
{
  TMPRINTMETHOD();
}

bool TMRosterListener::handleSubscriptionRequest( const JID& jid, const std::string& msg )
{
  TMPRINTMETHOD();
  return true;
}

bool TMRosterListener::handleUnsubscriptionRequest( const JID& jid, const std::string& msg )
{
  TMPRINTMETHOD();
  return true;
}

void TMRosterListener::handleNonrosterPresence( const Presence& presence )
{
  TMPRINTMETHOD();
}

void TMRosterListener::handleRosterError( const IQ& iq )
{
  TMPRINTMETHOD();
}
