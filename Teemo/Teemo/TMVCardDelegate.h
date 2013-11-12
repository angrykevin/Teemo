//
//  TMVCardDelegate.h
//  Teemo
//
//  Created by Wu Kevin on 11/12/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TMVCardDelegate <NSObject>
@optional

- (void)vcardOnReceived:(const JID &)jid vcard:(const VCard *)vcard;

- (void)vcardOnResult:(const JID &)jid context:(VCardHandler::VCardContext)context error:(StanzaError)se;

@end
