//
//  TMMessageSessionHandler.mm
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#include "TMMessageSessionHandler.h"
#include "TMMessageHandler.h"
#include "TMDebug.h"

void TMMessageSessionHandler::handleMessageSession( MessageSession* session )
{
  TMMessageHandler *messageHandler = new TMMessageHandler;
  session->registerMessageHandler( messageHandler );
  TMPRINTMETHOD();
}
