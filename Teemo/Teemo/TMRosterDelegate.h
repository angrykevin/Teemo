//
//  TMRosterDelegate.h
//  Teemo
//
//  Created by Wu Kevin on 11/12/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TMRosterDelegate <NSObject>
@optional

- (void)rosterOnItemAdded:(const JID &)jid;

- (void)rosterOnItemSubscribed:(const JID &)jid;

- (void)rosterOnItemRemoved:(const JID &)jid;

- (void)rosterOnItemUpdated:(const JID &)jid;

- (void)rosterOnItemUnsubscribed:(const JID &)jid;

- (void)rosterOnReceived:(const Roster &)roster;

- (void)rosterOnPresence:(const RosterItem &)item
                resource:(const std::string &)resource
                presence:(Presence::PresenceType)presence
                     msg:(const std::string &)msg;

- (void)rosterOnSelfPresence:(const RosterItem &)item
                    resource:(const std::string &)resource
                    presence:(Presence::PresenceType)presence
                         msg:(const std::string &)msg;

- (bool)rosterOnSubscriptionRequest:(const JID &)jid msg:(const std::string &)msg;

- (bool)rosterOnUnsubscriptionRequest:(const JID &)jid msg:(const std::string &)msg;

- (void)rosterOnNonrosterPresence:(const Presence &)presence;

- (void)rosterOnError:(const IQ &)iq;

@end
