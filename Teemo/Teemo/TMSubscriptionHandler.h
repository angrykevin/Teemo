//
//  TMSubscriptionHandler.h
//  TestGlx
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#ifndef __TMSubscriptionHandler__
#define __TMSubscriptionHandler__

#include <iostream>

#include <gloox/subscriptionhandler.h>

using namespace gloox;


class TMSubscriptionHandler : public SubscriptionHandler {
  
public:
  /**
   * Reimplement this function if you want to be notified about incoming
   * subscriptions/subscription requests.
   * @param subscription The complete Subscription stanza.
   * @since 1.0
   */
  virtual void handleSubscription( const Subscription& subscription );
  
};

#endif
