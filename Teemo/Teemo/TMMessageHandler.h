//
//  TMMessageHandler.h
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#ifndef __TMMessageHandler__
#define __TMMessageHandler__

#include <iostream>

#include <gloox/messagehandler.h>

#include "TMHandlerBase.h"

using namespace gloox;


class TMMessageHandler : public MessageHandler, public TMHandlerBase {
  
public:
  /**
   * Reimplement this function if you want to be notified about
   * incoming messages.
   * @param msg The complete Message.
   * @param session If this MessageHandler is used with a MessageSession, this parameter
   * holds a pointer to that MessageSession.
   * @since 1.0
   */
  virtual void handleMessage( const Message& msg, MessageSession* session = 0 );
  
};

#endif
