//
//  RSRosterModel.h
//  Teemo
//
//  Created by Wu Kevin on 11/29/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <gloox/rostermanager.h>

using namespace gloox;

@interface RSRosterModel : NSObject {
  NSArray *_presenceTypes;
  NSArray *_subscriptionTypes;
  NSArray *_groups;
}

@property (nonatomic, strong) NSArray *presenceTypes;
@property (nonatomic, strong) NSArray *subscriptionTypes;
@property (nonatomic, strong, readonly) NSArray *groups;

- (void)reloadGroups;

- (NSArray *)buddiesOfSubscriptionTypes:(NSArray *)subscriptionTypes;

@end


@interface RSRosterGroup : NSObject {
  NSString *_name;
  NSString *_displayname;
  NSArray *_buddies;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *displayname;
@property (nonatomic, strong) NSArray *buddies;

@end


@interface RSRosterBuddy : NSObject {
  Presence::PresenceType _presenceType;
  TKDatabaseRow *_dbObject;
}

@property (nonatomic, assign) Presence::PresenceType presenceType;
@property (nonatomic, strong) TKDatabaseRow *dbObject;

@end
