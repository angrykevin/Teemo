//
//  TMMessageSessionHandler.h
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#ifndef __TMMessageSessionHandler__
#define __TMMessageSessionHandler__

#include <iostream>

#include <gloox/messagesessionhandler.h>

#include "TMHandlerBase.h"

using namespace gloox;


class TMMessageSessionHandler : public MessageSessionHandler, public TMHandlerBase {
  
public:
  /**
   * Reimplement this function if you want to be notified about
   * incoming messages by means of automatically created MessageSessions.
   * You receive ownership of the supplied session (@b not the stanza) and
   * are responsible for deleting it at the end of its life.
   *
   * @note Make sure to read the note in ClientBase::registerMessageSessionHandler()
   * regarding the feeding of decorators.
   *
   * @note You should never delete the MessageSession manually. Instead call
   * ClientBase::disposeMessageSession() when you no longer need the session.
   *
   * @note If you don't need the MessageSession, you should not dispose it here. You will
   * get an endless loop if you do.
   *
   * @note You should register your MessageHandler here, or else the first message
   * (that caused the MessageSession to be created) may get lost.
   *
   * @param session The new MessageSession.
   */
  virtual void handleMessageSession( MessageSession* session );
  
};

#endif
