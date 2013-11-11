//
//  TMIqHandler.h
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#ifndef __TMIqHandler__
#define __TMIqHandler__

#include <iostream>

#include <gloox/iqhandler.h>

#include "TMHandlerBase.h"

using namespace gloox;


class TMIqHandler : public IqHandler, public TMHandlerBase {
  
public:
  /**
   * Reimplement this function if you want to be notified about incoming IQs.
   * @param iq The complete IQ stanza.
   * @return Indicates whether a request of type 'get' or 'set' has been handled. This includes
   * the obligatory 'result' answer. If you return @b false, an 'error' will be sent.
   * @since 1.0
   */
  virtual bool handleIq( const IQ& iq );
  
  /**
   * Reimplement this function if you want to be notified about
   * incoming IQs with a specific value of the @c id attribute. You
   * have to enable tracking of those IDs using Client::trackID().
   * This is usually useful for IDs that generate a positive reply, i.e.
   * &lt;iq type='result' id='reg'/&gt; where a namespace filter wouldn't
   * work.
   * @param iq The complete IQ stanza.
   * @param context A value to restore context, stored with ClientBase::trackID().
   * @note Only IQ stanzas of type 'result' or 'error' can arrive here.
   * @since 1.0
   */
  virtual void handleIqID( const IQ& iq, int context );
  
};

#endif
