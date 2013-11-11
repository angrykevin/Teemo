//
//  TMConnectionListener.mm
//  Teemo
//
//  Created by Wu Kevin on 11/5/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#include "TMConnectionListener.h"
#include "TMDebug.h"
#import "TMConnectionDelegate.h"


void TMConnectionListener::onConnect()
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

void TMConnectionListener::onDisconnect( ConnectionError e )
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

void TMConnectionListener::onResourceBind( const std::string& resource )
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

void TMConnectionListener::onResourceBindError( const Error* error )
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

void TMConnectionListener::onSessionCreateError( const Error* error )
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

bool TMConnectionListener::onTLSConnect( const CertInfo& info )
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

void TMConnectionListener::onStreamEvent( StreamEvent event )
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
