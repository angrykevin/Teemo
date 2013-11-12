//
//  TMPresenceHandler.mm
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "TMPresenceHandler.h"
#import "TMDebug.h"
#import "TMPresenceDelegate.h"

void TMPresenceHandler::handlePresence( const Presence& presence )
{
  TMPRINTMETHOD();
  
  list<void *>::const_iterator it = m_observers.begin();
  
  for( ; it != m_observers.end(); ++it ) {
    id<TMPresenceDelegate> delegate = (__bridge id<TMPresenceDelegate>)(*it);
    if ( [delegate respondsToSelector:@selector(presenceOnReceived:)] ) {
      [delegate presenceOnReceived:presence];
    }
  }
  
}
