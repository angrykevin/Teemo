//
//  TMVCardHandler.h
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#ifndef __TMVCardHandler__
#define __TMVCardHandler__

#include <iostream>
#include <gloox/vcardhandler.h>
#include <gloox/vcardmanager.h>
#include "TMBaseHandler.h"

using namespace gloox;


class TMVCardHandler : public TMBaseHandler, public VCardHandler {
  
public:
  /**
   * This function is called when a VCard has been successfully fetched.
   * @param jid The JID to which this VCard belongs.
   * @param vcard The fetched VCard. Zero if there is no VCard for this contact.
   * Do @b not delete the VCard. It will be deleted after this function returned.
   */
  virtual void handleVCard( const JID& jid, const VCard* vcard );
  
  /**
   * This function is called to indicate the result of a VCard store operation
   * or any error that occurs.
   * @param context The operation which yielded the result.
   * @param jid The JID involved.
   * @param se The error, if any. If equal to @c StanzaErrorUndefined no error occured.
   */
  virtual void handleVCardResult( VCardContext context, const JID& jid, StanzaError se = StanzaErrorUndefined  );
};

#endif
