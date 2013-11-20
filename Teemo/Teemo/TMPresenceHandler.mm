//
//  TMPresenceHandler.mm
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#include "TMPresenceHandler.h"
#import "TMPresenceDelegate.h"

#import "TMMacro.h"

void TMPresenceHandler::handlePresence( const Presence& presence )
{
  TMPRINTMETHOD();
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMPresenceDelegate> delegate = (__bridge id<TMPresenceDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(presenceOnReceived:)] ) {
        [delegate presenceOnReceived:presence];
      }
    }
    
  });
  
}
