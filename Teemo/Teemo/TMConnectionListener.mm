//
//  TMConnectionListener.mm
//  TestGlx
//
//  Created by Wu Kevin on 11/5/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#include "TMConnectionListener.h"
#include "TMDebug.h"


void TMConnectionListener::onConnect()
{
  TMPRINTMETHOD();
}

void TMConnectionListener::onDisconnect( ConnectionError e )
{
  TMPRINTMETHOD();
}

void TMConnectionListener::onResourceBind( const std::string& resource )
{
  TMPRINTMETHOD();
  (void)resource;
}

void TMConnectionListener::onResourceBindError( const Error* error )
{
  TMPRINTMETHOD();
  (void) (error);
}

void TMConnectionListener::onSessionCreateError( const Error* error )
{
  TMPRINTMETHOD();
  (void) (error);
}

bool TMConnectionListener::onTLSConnect( const CertInfo& info )
{
  TMPRINTMETHOD();
  return true;
}

void TMConnectionListener::onStreamEvent( StreamEvent event )
{
  TMPRINTMETHOD();
  (void) (event);
}
