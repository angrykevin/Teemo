//
//  TMConnectionHandler.m
//  Teemo
//
//  Created by Wu Kevin on 11/11/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "TMConnectionHandler.h"
#import "TMDebug.h"
#import "TMConnectionDelegate.h"


void TMConnectionHandler::onConnect()
{
  TMPRINTMETHOD();
  
  list<void *>::const_iterator it = m_observers.begin();
  
  for( ; it != m_observers.end(); ++it ) {
    id<TMConnectionDelegate> delegate = (__bridge id<TMConnectionDelegate>)(*it);
    if ( [delegate respondsToSelector:@selector(connectionOnConnect)] ) {
      [delegate connectionOnConnect];
    }
  }
  
}

void TMConnectionHandler::onDisconnect( ConnectionError e )
{
  TMPRINTMETHOD();
  
  list<void *>::const_iterator it = m_observers.begin();
  
  for( ; it != m_observers.end(); ++it ) {
    id<TMConnectionDelegate> delegate = (__bridge id<TMConnectionDelegate>)(*it);
    if ( [delegate respondsToSelector:@selector(connectionOnDisconnect:)] ) {
      [delegate connectionOnDisconnect:e];
    }
  }
  
}

void TMConnectionHandler::onResourceBind( const std::string& resource )
{
  TMPRINTMETHOD();
  
  list<void *>::const_iterator it = m_observers.begin();
  
  for( ; it != m_observers.end(); ++it ) {
    id<TMConnectionDelegate> delegate = (__bridge id<TMConnectionDelegate>)(*it);
    if ( [delegate respondsToSelector:@selector(connectionOnResourceBind:)] ) {
      [delegate connectionOnResourceBind:resource];
    }
  }
  
}

void TMConnectionHandler::onResourceBindError( const Error* error )
{
  TMPRINTMETHOD();
  
  list<void *>::const_iterator it = m_observers.begin();
  
  for( ; it != m_observers.end(); ++it ) {
    id<TMConnectionDelegate> delegate = (__bridge id<TMConnectionDelegate>)(*it);
    if ( [delegate respondsToSelector:@selector(connectionOnResourceBindError:)] ) {
      [delegate connectionOnResourceBindError:error];
    }
  }
  
}

void TMConnectionHandler::onSessionCreateError( const Error* error )
{
  TMPRINTMETHOD();
  
  list<void *>::const_iterator it = m_observers.begin();
  
  for( ; it != m_observers.end(); ++it ) {
    id<TMConnectionDelegate> delegate = (__bridge id<TMConnectionDelegate>)(*it);
    if ( [delegate respondsToSelector:@selector(connectionOnSessionCreateError:)] ) {
      [delegate connectionOnSessionCreateError:error];
    }
  }
  
}

bool TMConnectionHandler::onTLSConnect( const CertInfo& info )
{
  TMPRINTMETHOD();
  
  list<void *>::const_iterator it = m_observers.begin();
  
  for( ; it != m_observers.end(); ++it ) {
    id<TMConnectionDelegate> delegate = (__bridge id<TMConnectionDelegate>)(*it);
    if ( [delegate respondsToSelector:@selector(connectionOnTLSConnect:)] ) {
      [delegate connectionOnTLSConnect:info];
    }
  }
  
  return true;
}

void TMConnectionHandler::onStreamEvent( StreamEvent event )
{
  TMPRINTMETHOD();
  
  list<void *>::const_iterator it = m_observers.begin();
  
  for( ; it != m_observers.end(); ++it ) {
    id<TMConnectionDelegate> delegate = (__bridge id<TMConnectionDelegate>)(*it);
    if ( [delegate respondsToSelector:@selector(connectionOnStreamEvent:)] ) {
      [delegate connectionOnStreamEvent:event];
    }
  }
  
}
