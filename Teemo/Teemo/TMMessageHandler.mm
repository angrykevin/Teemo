//
//  TMMessageHandler.mm
//  Teemo
//
//  Created by Wu Kevin on 2/18/14.
//  Copyright (c) 2014 xbcx. All rights reserved.
//

#import "TMMessageHandler.h"
#import "TMEngine.h"
#import "TMCommon.h"



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
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  
  [engine addMessageHandler:mh forJid:OBJCSTR(session->target().bare())];
  
}
