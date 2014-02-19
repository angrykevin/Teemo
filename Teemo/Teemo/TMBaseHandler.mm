//
//  TMBaseHandler.mm
//  Teemo
//
//  Created by Wu Kevin on 11/11/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#include "TMBaseHandler.h"

TMBaseHandler::TMBaseHandler()
    : m_engine(NULL)
{
}


void TMBaseHandler::setEngine(void *engine)
{
  m_engine = engine;
}

void *TMBaseHandler::getEngine()
{
  return m_engine;
}

