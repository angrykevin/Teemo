//
//  TMMessageHandler.mm
//  Teemo
//
//  Created by Wu Kevin on 2/18/14.
//  Copyright (c) 2014 xbcx. All rights reserved.
//

#import "TMMessageHandler.h"


void TMMessageHandler::handleMessage( const Message& msg, MessageSession* session )
{
  TKPRINTMETHOD();
}


void TMMessageHandler::handleChatState( const JID& from, ChatStateType state )
{
  TKPRINTMETHOD();
}


void TMMessageHandler::handleMessageEvent( const JID& from, MessageEventType event )
{
  TKPRINTMETHOD();
}



void TMMessageSessionHandler::handleMessageSession( MessageSession* session )
{
  TKPRINTMETHOD();
  
  TMMessageHandler *mh = new TMMessageHandler( session );
  
}
