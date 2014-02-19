//
//  TMMessageHandler.h
//  Teemo
//
//  Created by Wu Kevin on 2/18/14.
//  Copyright (c) 2014 xbcx. All rights reserved.
//

#ifndef __TMMessageHandler__
#define __TMMessageHandler__

#include <iostream>

#include <gloox/message.h>
#include <gloox/messagefilter.h>
#include <gloox/messagehandler.h>

#include <gloox/chatstate.h>
#include <gloox/chatstatefilter.h>
#include <gloox/chatstatehandler.h>

#include <gloox/messageevent.h>
#include <gloox/messageeventfilter.h>
#include <gloox/messageeventhandler.h>

#include <gloox/messagesession.h>
#include <gloox/messagesessionhandler.h>

#include "TMBaseHandler.h"

using namespace gloox;


class TMMessageHandler : public TMBaseHandler, public MessageHandler, public ChatStateHandler, public MessageEventHandler {
  
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
  
  
  /**
   * Notifies the ChatStateHandler that a different chat state has been set by the remote
   * contact.
   * @param from The originator of the Event.
   * @param state The chat state set by the remote entity.
   */
  virtual void handleChatState( const JID& from, ChatStateType state );
  
  
  /**
   * Notifies the MessageEventHandler that an event has been raised by the remote
   * contact.
   * @param from The originator of the Event.
   * @param event The Event which has been raised.
   */
  virtual void handleMessageEvent( const JID& from, MessageEventType event );
  
  
  TMMessageHandler(MessageSession *ms)
      : m_messageSession(ms)
  {
    m_messageSession->registerMessageHandler( this );
    
    m_chatStateFilter = new ChatStateFilter( m_messageSession );
    m_chatStateFilter->registerChatStateHandler( this );
    
    m_messageEventFilter = new MessageEventFilter( m_messageSession );
    m_messageEventFilter->registerMessageEventHandler( this );
  }
  
  ~TMMessageHandler()
  {
    m_messageSession = NULL;
    delete m_chatStateFilter;
    delete m_messageEventFilter;
  }
  
  MessageSession *getMessageSession()
  {
    return m_messageSession;
  }
  
  ChatStateFilter *getChatStateFilter()
  {
    return m_chatStateFilter;
  }
  
  MessageEventFilter *getMessageEventFilter()
  {
    return m_messageEventFilter;
  }
  
private:
  MessageSession *m_messageSession;
  ChatStateFilter *m_chatStateFilter;
  MessageEventFilter *m_messageEventFilter;
  
};


class TMMessageSessionHandler : public TMBaseHandler, public MessageSessionHandler {
  
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
