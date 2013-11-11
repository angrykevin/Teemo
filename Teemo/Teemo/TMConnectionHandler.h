//
//  TMConnectionHandler.h
//  Teemo
//
//  Created by Wu Kevin on 11/11/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#ifndef __TMConnectionHandler__
#define __TMConnectionHandler__

#include <iostream>

#include <gloox/connectionlistener.h>

#include "TMHandlerBase.h"

using namespace gloox;


class TMConnectionHandler : public ConnectionListener, public TMHandlerBase {
  
public:
  
  /**
   * This function notifies about successful connections. It will be called either after all
   * authentication is finished if username/password were supplied, or after a connection has
   * been established if no credentials were supplied. Depending on the setting of AutoPresence,
   * a presence stanza is sent or not.
   */
  virtual void onConnect();
  
  /**
   * This function notifies about disconnection and its reason.
   * If @b e indicates a stream error, you can use @ref ClientBase::streamError() to find out
   * what exactly went wrong, and @ref ClientBase::streamErrorText() to retrieve any explaining text
   * sent along with the error.
   * If @b e indicates an authentication error, you can use @ref ClientBase::authError()
   * to get a finer grained reason.
   * @param e The reason for the disconnection.
   */
  virtual void onDisconnect( ConnectionError e );
  
  /**
   * This function will be called when a resource has been bound to the stream. It
   * will be called for any bound resource, including the main one.
   * @note The bound resource may be different from the one requested. The server
   * has the authority to change/overwrite the requested resource.
   * @param resource The resource string.
   * @since 1.0
   */
  virtual void onResourceBind( const std::string& resource );
  
  /**
   * This function is called (by a Client object) if an error occurs while trying to bind a resource.
   * @param error A pointer to an Error object that contains more
   * information. May be 0.
   */
  virtual void onResourceBindError( const Error* error );
  
  /**
   * This function is called (by a Client object) if an error occurs while trying to establish
   * a session.
   * @param error A pointer to an Error object that contains more
   * information. May be 0.
   */
  virtual void onSessionCreateError( const Error* error );
  
  /**
   * This function is called when the connection was TLS/SSL secured.
   * @param info Comprehensive info on the certificate.
   * @return @b True if cert credentials are accepted, @b false otherwise. If @b false is returned
   * the connection is terminated.
   */
  virtual bool onTLSConnect( const CertInfo& info );
  
  /**
   * This function is called for certain stream events. Notifications are purely informational
   * and implementation is optional. Not all StreamEvents will necessarily be emitted for
   * a given connection.
   * @param event A stream event.
   * @since 0.9
   */
  virtual void onStreamEvent( StreamEvent event );
  
};

#endif
