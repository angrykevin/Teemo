//
//  TMStatisticsHandler.h
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#ifndef __TMStatisticsHandler__
#define __TMStatisticsHandler__

#include <iostream>

#include <gloox/statisticshandler.h>

#include "TMHandlerBase.h"

using namespace gloox;


class TMStatisticsHandler : public StatisticsHandler, TMHandlerBase {
  
public:
  /**
   * This function is called when a Stanza has been sent or received.
   * @param stats The updated connection statistics.
   */
  virtual void handleStatistics( const StatisticsStruct stats );
  
};

#endif
