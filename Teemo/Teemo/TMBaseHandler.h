//
//  TMBaseHandler.h
//  Teemo
//
//  Created by Wu Kevin on 11/11/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#ifndef __TMBaseHandler__
#define __TMBaseHandler__

#include <iostream>


class TMBaseHandler {
  
public:
  TMBaseHandler();
  
  void setEngine(void *engine);
  void *getEngine();
  
protected:
  void *m_engine;
  
};

#endif
