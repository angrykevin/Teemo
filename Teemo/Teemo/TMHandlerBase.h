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

typedef list<void *> TMObserverList;


class TMHandlerBase {
  
public:
  void addObserver(void *observer);
  
  void removeObserver(void *observer);
  
  void removeAllObservers();
  
protected:
  TMObserverList m_observers;
};

#endif
