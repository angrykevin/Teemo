//
//  TMConnectionHandler.mm
//  Teemo
//
//  Created by Wu Kevin on 11/11/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#include "TMConnectionHandler.h"
#import "TMEngine.h"
#import "TMCommon.h"

void TMConnectionHandler::onConnect()
{
#ifdef DEBUG
  printf("\n<<==================================================\n");
  printf("onConnect\n");
  printf("==================================================>>\n\n");
#endif
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  NSArray *observers = [engine observers];
  if ( [observers count] > 0 ) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      for ( id<TMEngineDelegate> observer in observers ) {
        if ( [observer respondsToSelector:@selector(engineConnectionOnConnect:)] ) {
          [observer engineConnectionOnConnect:engine];
        }
      }
    });
  }
  
}

void TMConnectionHandler::onDisconnect( ConnectionError e )
{
#ifdef DEBUG
  
  printf("\n<<==================================================\n");
  
  switch ( e ) {
    case ConnNoError:               printf("onDisconnect: ConnNoError\n"); break;
    case ConnStreamError:           printf("onDisconnect: ConnStreamError\n"); break;
      
    case ConnStreamVersionError:    printf("onDisconnect: ConnStreamVersionError\n"); break;
    case ConnStreamClosed:          printf("onDisconnect: ConnStreamClosed\n"); break;
    case ConnProxyAuthRequired:     printf("onDisconnect: ConnProxyAuthRequired\n"); break;
      
    case ConnProxyAuthFailed:       printf("onDisconnect: ConnProxyAuthFailed\n"); break;
      
    case ConnProxyNoSupportedAuth:  printf("onDisconnect: ConnProxyNoSupportedAuth\n"); break;
      
    case ConnIoError:               printf("onDisconnect: ConnIoError\n"); break;
    case ConnParseError:            printf("onDisconnect: ConnParseError\n"); break;
    case ConnConnectionRefused:     printf("onDisconnect: ConnConnectionRefused\n"); break;
      
    case ConnDnsError:              printf("onDisconnect: ConnDnsError\n"); break;
      
    case ConnOutOfMemory:           printf("onDisconnect: ConnOutOfMemory\n"); break;
    case ConnNoSupportedAuth:       printf("onDisconnect: ConnNoSupportedAuth\n"); break;
      
    case ConnTlsFailed:             printf("onDisconnect: ConnTlsFailed\n"); break;
      
    case ConnTlsNotAvailable:       printf("onDisconnect: ConnTlsNotAvailable\n"); break;
      
      
    case ConnCompressionFailed:     printf("onDisconnect: ConnCompressionFailed\n"); break;
      
    case ConnAuthenticationFailed:  printf("onDisconnect: ConnAuthenticationFailed\n"); break;
      
    case ConnUserDisconnected:      printf("onDisconnect: ConnUserDisconnected\n"); break;
    case ConnNotConnected:          printf("onDisconnect: ConnNotConnected\n"); break;
      
      
    default:                        printf("onDisconnect: OTHER\n"); break;
  }
  
  printf("==================================================>>\n\n");
  
#endif
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  NSArray *observers = [engine observers];
  if ( [observers count] > 0 ) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      for ( id<TMEngineDelegate> observer in observers ) {
        if ( [observer respondsToSelector:@selector(engine:connectionOnDisconnect:)] ) {
          [observer engine:engine connectionOnDisconnect:e];
        }
      }
    });
  }
  
}

void TMConnectionHandler::onResourceBind( const std::string& resource )
{
#ifdef DEBUG
  printf("\n<<==================================================\n");
  printf("onResourceBind: %s\n", resource.c_str());
  printf("==================================================>>\n\n");
#endif
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  NSArray *observers = [engine observers];
  if ( [observers count] > 0 ) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      for ( id<TMEngineDelegate> observer in observers ) {
        if ( [observer respondsToSelector:@selector(engine:connectionOnResourceBind:)] ) {
          [observer engine:engine connectionOnResourceBind:OBJCSTR(resource)];
        }
      }
    });
  }
  
}

void TMConnectionHandler::onResourceBindError( const Error* error )
{
#ifdef DEBUG
  printf("\n<<==================================================\n");
  printf("onResourceBindError\n");
  printf("==================================================>>\n\n");
#endif
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  NSArray *observers = [engine observers];
  if ( [observers count] > 0 ) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      for ( id<TMEngineDelegate> observer in observers ) {
        if ( [observer respondsToSelector:@selector(engine:connectionOnResourceBindError:)] ) {
          [observer engine:engine connectionOnResourceBindError:error];
        }
      }
    });
  }
  
}

void TMConnectionHandler::onSessionCreateError( const Error* error )
{
#ifdef DEBUG
  printf("\n<<==================================================\n");
  printf("onSessionCreateError\n");
  printf("==================================================>>\n\n");
#endif
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  NSArray *observers = [engine observers];
  if ( [observers count] > 0 ) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      for ( id<TMEngineDelegate> observer in observers ) {
        if ( [observer respondsToSelector:@selector(engine:connectionOnSessionCreateError:)] ) {
          [observer engine:engine connectionOnSessionCreateError:error];
        }
      }
    });
  }
  
}

bool TMConnectionHandler::onTLSConnect( const CertInfo& info )
{
  
#ifdef DEBUG
  printf("\n<<==================================================\n");
  printf("onTLSConnect\n");
  
  printf("int    status: %d\n", info.status);
  printf("bool   chain: %d\n", info.chain);
  printf("string issuer: %s\n", info.issuer.c_str());
  printf("string server: %s\n", info.server.c_str());
  
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
  
  NSDate *from = [NSDate dateWithTimeIntervalSince1970:info.date_from];
  printf("date   date_from: %s\n", [[formatter stringFromDate:from] UTF8String]);
  
  NSDate *to = [NSDate dateWithTimeIntervalSince1970:info.date_to];
  printf("date   date_to: %s\n", [[formatter stringFromDate:to] UTF8String]);
  
  printf("string protocol: %s\n", info.protocol.c_str());
  printf("string cipher: %s\n", info.cipher.c_str());
  printf("string mac: %s\n", info.mac.c_str());
  printf("string compression: %s\n", info.compression.c_str());
  
  printf("==================================================>>\n\n");
#endif
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  NSArray *observers = [engine observers];
  if ( [observers count] > 0 ) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      for ( id<TMEngineDelegate> observer in observers ) {
        if ( [observer respondsToSelector:@selector(engine:connectionOnTLSConnect:)] ) {
          [observer engine:engine connectionOnTLSConnect:info];
        }
      }
    });
  }
  
  return true;
}

void TMConnectionHandler::onStreamEvent( StreamEvent event )
{
#ifdef DEBUG
  
  printf("\n<<==================================================\n");
  
  switch ( event ) {
    case StreamEventConnecting:       printf("onStreamEvent: StreamEventConnecting\n"); break;
    case StreamEventEncryption:       printf("onStreamEvent: StreamEventEncryption\n"); break;
    case StreamEventCompression:      printf("onStreamEvent: StreamEventCompression\n"); break;
    case StreamEventAuthentication:   printf("onStreamEvent: StreamEventAuthentication\n"); break;
    case StreamEventSessionInit:      printf("onStreamEvent: StreamEventSessionInit\n"); break;
    case StreamEventResourceBinding:  printf("onStreamEvent: StreamEventResourceBinding\n"); break;
    case StreamEventSMEnable:         printf("onStreamEvent: StreamEventSMEnable\n"); break;
      
    case StreamEventSMResume:         printf("onStreamEvent: StreamEventSMResume\n"); break;
      
      
    case StreamEventSMResumed:        printf("onStreamEvent: StreamEventSMResumed\n"); break;
      
      
    case StreamEventSMEnableFailed:   printf("onStreamEvent: StreamEventSMEnableFailed\n"); break;
      
      
    case StreamEventSMResumeFailed:   printf("onStreamEvent: StreamEventSMResumeFailed\n"); break;
      
      
    case StreamEventSessionCreation:  printf("onStreamEvent: StreamEventSessionCreation\n"); break;
      
    case StreamEventRoster:           printf("onStreamEvent: StreamEventRoster\n"); break;
    case StreamEventFinished:         printf("onStreamEvent: StreamEventFinished\n"); break;
      
      
    default:                          printf("onStreamEvent: OTHER\n"); break;
  }
  
  printf("==================================================>>\n\n");
  
#endif
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  NSArray *observers = [engine observers];
  if ( [observers count] > 0 ) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      for ( id<TMEngineDelegate> observer in observers ) {
        if ( [observer respondsToSelector:@selector(engine:connectionOnStreamEvent:)] ) {
          [observer engine:engine connectionOnStreamEvent:event];
        }
      }
    });
  }
  
}
