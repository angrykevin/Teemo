//
//  TMHandlerBase.h
//  Teemo
//
//  Created by Wu Kevin on 11/11/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#ifndef __TMHandlerBase__
#define __TMHandlerBase__

#include <iostream>
#include <list>

using namespace std;


class TMHandlerBase {
  
public:
  void addObserver(void *observer);
  
  void removeObserver(void *observer);
  
  void removeAllObservers();
  
protected:
  list<void *> m_observers;
};

#endif
