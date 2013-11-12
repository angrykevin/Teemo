//
//  TMPresenceDelegate.h
//  Teemo
//
//  Created by Wu Kevin on 11/12/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TMPresenceDelegate <NSObject>
@optional

- (void)presenceOnReceived:(const Presence &)presence;

@end
