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
#ifdef DEBUG
  printf("\n<<==================================================\n");
  printf("%s\n", __PRETTY_FUNCTION__);
  printf("==================================================>>\n\n");
#endif
  
  dispatch_async(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMConnectionDelegate> delegate = (__bridge id<TMConnectionDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(connectionOnConnect)] ) {
        [delegate connectionOnConnect];
      }
    }
    
  });
  
}

void TMConnectionHandler::onDisconnect( ConnectionError e )
{
#ifdef DEBUG
  
  printf("\n<<==================================================\n");
  
  switch ( e ) {
    case ConnNoError: printf("%s: ConnNoError\n", __PRETTY_FUNCTION__); break;
    case ConnStreamError: printf("%s: ConnStreamError\n", __PRETTY_FUNCTION__); break;
      
    case ConnStreamVersionError: printf("%s: ConnStreamVersionError\n", __PRETTY_FUNCTION__); break;
    case ConnStreamClosed: printf("%s: ConnStreamClosed\n", __PRETTY_FUNCTION__); break;
    case ConnProxyAuthRequired: printf("%s: ConnProxyAuthRequired\n", __PRETTY_FUNCTION__); break;
      
    case ConnProxyAuthFailed: printf("%s: ConnProxyAuthFailed\n", __PRETTY_FUNCTION__); break;
      
    case ConnProxyNoSupportedAuth: printf("%s: ConnProxyNoSupportedAuth\n", __PRETTY_FUNCTION__); break;
      
    case ConnIoError: printf("%s: ConnIoError\n", __PRETTY_FUNCTION__); break;
    case ConnParseError: printf("%s: ConnParseError\n", __PRETTY_FUNCTION__); break;
    case ConnConnectionRefused: printf("%s: ConnConnectionRefused\n", __PRETTY_FUNCTION__); break;
      
    case ConnDnsError: printf("%s: ConnDnsError\n", __PRETTY_FUNCTION__); break;
      
    case ConnOutOfMemory: printf("%s: ConnOutOfMemory\n", __PRETTY_FUNCTION__); break;
    case ConnNoSupportedAuth: printf("%s: ConnNoSupportedAuth\n", __PRETTY_FUNCTION__); break;
      
    case ConnTlsFailed: printf("%s: ConnTlsFailed\n", __PRETTY_FUNCTION__); break;
      
    case ConnTlsNotAvailable: printf("%s: ConnTlsNotAvailable\n", __PRETTY_FUNCTION__); break;
      
      
    case ConnCompressionFailed: printf("%s: ConnCompressionFailed\n", __PRETTY_FUNCTION__); break;
      
    case ConnAuthenticationFailed: printf("%s: ConnAuthenticationFailed\n", __PRETTY_FUNCTION__); break;
      
    case ConnUserDisconnected: printf("%s: ConnUserDisconnected\n", __PRETTY_FUNCTION__); break;
    case ConnNotConnected: printf("%s: ConnNotConnected\n", __PRETTY_FUNCTION__); break;
      
      
    default: printf("%s: OTHER\n", __PRETTY_FUNCTION__); break;
  }
  
  printf("==================================================>>\n\n");
  
#endif
  
  dispatch_async(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMConnectionDelegate> delegate = (__bridge id<TMConnectionDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(connectionOnDisconnect:)] ) {
        [delegate connectionOnDisconnect:e];
      }
    }
    
  });
  
}

void TMConnectionHandler::onResourceBind( const std::string& resource )
{
#ifdef DEBUG
  printf("\n<<==================================================\n");
  printf("%s: %s\n", __PRETTY_FUNCTION__, resource.c_str());
  printf("==================================================>>\n\n");
#endif
  
  dispatch_async(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMConnectionDelegate> delegate = (__bridge id<TMConnectionDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(connectionOnResourceBind:)] ) {
        [delegate connectionOnResourceBind:resource];
      }
    }
    
  });
  
}

void TMConnectionHandler::onResourceBindError( const Error* error )
{
#ifdef DEBUG
  printf("\n<<==================================================\n");
  printf("%s\n", __PRETTY_FUNCTION__);
  printf("==================================================>>\n\n");
#endif
  
  dispatch_async(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMConnectionDelegate> delegate = (__bridge id<TMConnectionDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(connectionOnResourceBindError:)] ) {
        [delegate connectionOnResourceBindError:error];
      }
    }
    
  });
  
}

void TMConnectionHandler::onSessionCreateError( const Error* error )
{
#ifdef DEBUG
  printf("\n<<==================================================\n");
  printf("%s\n", __PRETTY_FUNCTION__);
  printf("==================================================>>\n\n");
#endif
  
  dispatch_async(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMConnectionDelegate> delegate = (__bridge id<TMConnectionDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(connectionOnSessionCreateError:)] ) {
        [delegate connectionOnSessionCreateError:error];
      }
    }
    
  });
  
}

bool TMConnectionHandler::onTLSConnect( const CertInfo& info )
{
  
#ifdef DEBUG
  printf("\n<<==================================================\n");
  printf("%s\n", __PRETTY_FUNCTION__);
  
  printf("int status: %d\n", info.status);
  printf("bool chain: %d\n", info.chain);
  printf("string issuer: %s\n", info.issuer.c_str());
  printf("string server: %s\n", info.server.c_str());
  
  NSDate *from = [NSDate dateWithTimeIntervalSince1970:info.date_from];
  printf("date date_from: %s\n", [[from description] UTF8String]);
  
  NSDate *to = [NSDate dateWithTimeIntervalSince1970:info.date_to];
  printf("date date_to: %s\n", [[to description] UTF8String]);
  
  printf("string protocol: %s\n", info.protocol.c_str());
  printf("string cipher: %s\n", info.cipher.c_str());
  printf("string mac: %s\n", info.mac.c_str());
  printf("string compression: %s\n", info.compression.c_str());
  
  printf("==================================================>>\n\n");
#endif
  
  dispatch_async(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMConnectionDelegate> delegate = (__bridge id<TMConnectionDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(connectionOnTLSConnect:)] ) {
        [delegate connectionOnTLSConnect:info];
      }
    }
    
  });
  
  return true;
}

void TMConnectionHandler::onStreamEvent( StreamEvent event )
{
#ifdef DEBUG
  
  printf("\n<<==================================================\n");
  
  switch ( event ) {
    case StreamEventConnecting: printf("%s: StreamEventConnecting\n", __PRETTY_FUNCTION__); break;
    case StreamEventEncryption: printf("%s: StreamEventEncryption\n", __PRETTY_FUNCTION__); break;
    case StreamEventCompression: printf("%s: StreamEventCompression\n", __PRETTY_FUNCTION__); break;
    case StreamEventAuthentication: printf("%s: StreamEventAuthentication\n", __PRETTY_FUNCTION__); break;
    case StreamEventSessionInit: printf("%s: StreamEventSessionInit\n", __PRETTY_FUNCTION__); break;
    case StreamEventResourceBinding: printf("%s: StreamEventResourceBinding\n", __PRETTY_FUNCTION__); break;
    case StreamEventSMEnable: printf("%s: StreamEventSMEnable\n", __PRETTY_FUNCTION__); break;
      
    case StreamEventSMResume: printf("%s: StreamEventSMResume\n", __PRETTY_FUNCTION__); break;
      
      
    case StreamEventSMResumed: printf("%s: StreamEventSMResumed\n", __PRETTY_FUNCTION__); break;
      
      
    case StreamEventSMEnableFailed: printf("%s: StreamEventSMEnableFailed\n", __PRETTY_FUNCTION__); break;
      
      
    case StreamEventSMResumeFailed: printf("%s: StreamEventSMResumeFailed\n", __PRETTY_FUNCTION__); break;
      
      
    case StreamEventSessionCreation: printf("%s: StreamEventSessionCreation\n", __PRETTY_FUNCTION__); break;
      
    case StreamEventRoster: printf("%s: StreamEventRoster\n", __PRETTY_FUNCTION__); break;
    case StreamEventFinished: printf("%s: StreamEventFinished\n", __PRETTY_FUNCTION__); break;
      
      
    default: printf("%s: OTHER\n", __PRETTY_FUNCTION__); break;
  }
  
  printf("==================================================>>\n\n");
  
#endif
  
  dispatch_async(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMConnectionDelegate> delegate = (__bridge id<TMConnectionDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(connectionOnStreamEvent:)] ) {
        [delegate connectionOnStreamEvent:event];
      }
    }
    
  });
  
}
