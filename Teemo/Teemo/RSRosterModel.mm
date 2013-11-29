//
//  RSRosterModel.mm
//  Teemo
//
//  Created by Wu Kevin on 11/29/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSRosterModel.h"
#import "TMEngine.h"
#import "TMMacro.h"

@implementation RSRosterModel

- (id)init
{
  self = [super init];
  if (self) {
    
    _presenceTypes = @[[NSNumber numberWithInt:Presence::Available],
                       [NSNumber numberWithInt:Presence::Chat],
                       [NSNumber numberWithInt:Presence::Away],
                       [NSNumber numberWithInt:Presence::DND],
                       [NSNumber numberWithInt:Presence::XA],
                       [NSNumber numberWithInt:Presence::Unavailable]];
    
    _subscriptionTypes = @[[NSNumber numberWithInt:S10nTo],
                           [NSNumber numberWithInt:S10nToIn],
                           [NSNumber numberWithInt:S10nBoth]];
    
  }
  return self;
}

- (void)reloadGroups
{
  NSMutableString *subscriptionTypeString = nil;
  if ( [_subscriptionTypes count] > 0 ) {
    subscriptionTypeString = [[NSMutableString alloc] init];
    [subscriptionTypeString appendFormat:@"%d", [[_subscriptionTypes firstObject] intValue]];
    for ( int i=1; i<[_subscriptionTypes count]; ++i ) {
      NSNumber *tmp = [_subscriptionTypes objectAtIndex:i];
      [subscriptionTypeString appendFormat:@",%d", [tmp intValue]];
    }
  }
  
  
  
  TMEngine *engine = [TMEngine sharedEngine];
  
  NSMutableArray *groupNames = [[NSMutableArray alloc] init];
  NSArray *dbGroupNames = [[engine database] executeQuery:@"SELECT DISTINCT groupname FROM tBuddy;"];
  for ( TKDatabaseRow *row in dbGroupNames ) {
    NSArray *names = [[row stringForName:@"groupname"] componentsSeparatedByString:@","];
    for ( NSString *name in names ) {
      [groupNames addUnequalObjectIfNotNil:name];
    }
  }
  
  
  NSMutableArray *groups = [[NSMutableArray alloc] init];
  
  for ( NSString *groupName in groupNames ) {
    
    RSRosterGroup *group = [[RSRosterGroup alloc] init];
    [groups addObject:group];
    
    
    group.name = groupName;
    
    
    if ( [groupName length] > 0 ) {
      group.displayname = groupName;
    } else {
      group.displayname = NSLocalizedString(@"Friends", @"");
    }
    
    
    RosterManager *rosterManager = [engine rosterManager];
    
    NSMutableArray *buddies = [[NSMutableArray alloc] init];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tBuddy WHERE (groupname LIKE '%@' OR groupname LIKE '%@,%%' OR groupname LIKE '%%,%@' OR groupname LIKE '%%,%@,%%') AND (subscription IN (%@));", groupName, groupName, groupName, groupName, subscriptionTypeString];
    NSArray *dbBuddies = [[engine database] executeQuery:sql];
    for ( TKDatabaseRow *row in dbBuddies ) {
      
      NSString *bid = [row stringForName:@"bid"];
      RosterItem *item = rosterManager->getRosterItem( JID( CPPSTR(bid) ) );
      Presence::PresenceType presenceType = Presence::Unavailable;
      const Resource *resource = item->highestResource();
      if ( resource ) {
        presenceType = resource->presence();
      }
      
      NSNumber *tmp = [NSNumber numberWithInt:presenceType];
      if ( [_presenceTypes hasObjectEqualTo:tmp] ) {
        RSRosterBuddy *buddy = [[RSRosterBuddy alloc] init];
        buddy.dbObject = row;
        buddy.presenceType = presenceType;
        [buddies addObject:buddy];
      }
      
    }
    
    group.buddies = [buddies sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
      RSRosterBuddy *b1 = obj1;
      RSRosterBuddy *b2 = obj2;
      NSUInteger idx1 = [_presenceTypes indexOfObject:[NSNumber numberWithInt:b1.presenceType]];
      NSUInteger idx2 = [_presenceTypes indexOfObject:[NSNumber numberWithInt:b2.presenceType]];
      if ( idx1 != idx2 ) {
        if ( idx1<idx2 ) {
          return NSOrderedAscending;
        } else {
          return NSOrderedDescending;
        }
      } else {
        NSString *bid1 = [b1.dbObject stringForName:@"bid"];
        NSString *bid2 = [b2.dbObject stringForName:@"bid"];
        return [bid1 compare:bid2];
      }
    }];
    
  }
  
  _groups = [groups sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    RSRosterGroup *g1 = obj1;
    RSRosterGroup *g2 = obj2;
    return [g1.displayname compare:g2.displayname];
  }];
}

- (NSArray *)buddiesOfSubscriptionTypes:(NSArray *)subscriptionTypes
{
  NSMutableString *subscriptionTypeString = nil;
  if ( [subscriptionTypes count] > 0 ) {
    subscriptionTypeString = [[NSMutableString alloc] init];
    [subscriptionTypeString appendFormat:@"%d", [[subscriptionTypes firstObject] intValue]];
    for ( int i=1; i<[subscriptionTypes count]; ++i ) {
      NSNumber *tmp = [subscriptionTypes objectAtIndex:i];
      [subscriptionTypeString appendFormat:@",%d", [tmp intValue]];
    }
  }
  
  if ( [subscriptionTypeString length] > 0 ) {
    
    TMEngine *engine = [TMEngine sharedEngine];
    
    RosterManager *rosterManager = [engine rosterManager];
    
    NSMutableArray *buddies = [[NSMutableArray alloc] init];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tBuddy WHERE subscription IN (%@);", subscriptionTypeString];
    NSArray *dbBuddies = [[engine database] executeQuery:sql];
    for ( TKDatabaseRow *row in dbBuddies ) {
      
      NSString *bid = [row stringForName:@"bid"];
      RosterItem *item = rosterManager->getRosterItem( JID( CPPSTR(bid) ) );
      Presence::PresenceType presenceType = Presence::Unavailable;
      const Resource *resource = item->highestResource();
      if ( resource ) {
        presenceType = resource->presence();
      }
      
      RSRosterBuddy *buddy = [[RSRosterBuddy alloc] init];
      buddy.dbObject = row;
      buddy.presenceType = presenceType;
      [buddies addObject:buddy];
      
    }
    
    return buddies;
    
  }
  
  return nil;
}

@end


@implementation RSRosterGroup

@end


@implementation RSRosterBuddy

@end
