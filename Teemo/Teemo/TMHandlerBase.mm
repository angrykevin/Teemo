//
//  TMHandlerBase.mm
//  Teemo
//
//  Created by Wu Kevin on 11/11/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#include "TMHandlerBase.h"

TMHandlerBase::TMHandlerBase()
{
  m_engine = NULL;
}

void TMHandlerBase::setEngine(void *engine)
{
  m_engine = engine;
}

void *TMHandlerBase::getEngine()
{
  return m_engine;
}

