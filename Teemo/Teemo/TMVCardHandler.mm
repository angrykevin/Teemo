//
//  TMVCardHandler.mm
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "TMVCardHandler.h"
#import "TMDebug.h"
#import "TMVCardDelegate.h"

void TMVCardHandler::handleVCard( const JID& jid, const VCard* vcard )
{
  TMPRINTMETHOD();
  
  dispatch_async(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMVCardDelegate> delegate = (__bridge id<TMVCardDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(vcardOnReceived:vcard:)] ) {
        [delegate vcardOnReceived:jid vcard:vcard];
      }
    }
    
  });
  
}

void TMVCardHandler::handleVCardResult( VCardContext context, const JID& jid, StanzaError se )
{
  TMPRINTMETHOD();
  
  dispatch_async(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMVCardDelegate> delegate = (__bridge id<TMVCardDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(vcardOnResult:context:error:)] ) {
        [delegate vcardOnResult:jid context:context error:se];
      }
    }
    
  });
  
}
