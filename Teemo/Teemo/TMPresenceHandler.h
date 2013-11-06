//
//  TMPresenceHandler.h
//  TestGlx
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#ifndef __TMPresenceHandler__
#define __TMPresenceHandler__

#include <iostream>

#include <gloox/presencehandler.h>

using namespace gloox;


class TMPresenceHandler : public PresenceHandler {
  
public:
  /**
   * Reimplement this function if you want to be updated on
   * incoming presence notifications.
   * @param presence The complete stanza.
   * @since 1.0
   */
  virtual void handlePresence( const Presence& presence );
  
};

#endif
