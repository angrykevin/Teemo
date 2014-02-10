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


class TMHandlerBase {
  
public:
  TMHandlerBase();
  
  void setEngine(void *engine);
  void *getEngine();
  
protected:
  void *m_engine;
  
};

#endif
