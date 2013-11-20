//
//  TMHandlerBase.mm
//  Teemo
//
//  Created by Wu Kevin on 11/11/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#include "TMHandlerBase.h"

void TMHandlerBase::addObserver(void *observer)
{
  m_observers.push_back( observer );
}

void TMHandlerBase::removeObserver(void *observer)
{
  m_observers.remove( observer );
}

void TMHandlerBase::removeAllObservers()
{
  m_observers.erase( m_observers.begin(), m_observers.end() );
}
