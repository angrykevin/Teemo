//
//  TMVCardHandler.mm
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#include "TMVCardHandler.h"
#import "TMEngine.h"
#import "TMCommon.h"


void TMVCardHandler::handleVCard( const JID& jid, const VCard* vcard )
{
  TKPRINTMETHOD();
  
#ifdef DEBUG
  printf("jid: %s\n", jid.bare().c_str());
  
  printf("nickname: %s\n", vcard->nickname().c_str());
  printf("familyname: %s\n", vcard->name().family.c_str());
  printf("givenname: %s\n", vcard->name().given.c_str());
  printf("photo: %s\n", vcard->photo().extval.c_str());
  printf("birthday: %s\n", vcard->bday().c_str());
  printf("desc: %s\n", vcard->desc().c_str());
  printf("homepage: %s\n", vcard->url().c_str());
  printf("note: %s\n", vcard->note().c_str());
#endif
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  
  if ( jid.bare().length() > 0 ) {
    NSString *sql = [[NSString alloc] initWithFormat:@"SELECT pk FROM t_buddy WHERE bid='%@';", OBJCSTR(jid.bare())];
    if ( [[engine database] hasRowForSQLStatement:sql] ) {
      [[engine database] executeUpdate:@"UPDATE t_buddy SET nickname=?, familyname=?, givenname=?, photo=?, birthday=?, desc=?, homepage=?, note=? WHERE bid=?;",
       OBJCSTR(vcard->nickname()),
       OBJCSTR(vcard->name().family),
       OBJCSTR(vcard->name().given),
       OBJCSTR(vcard->photo().extval),
       OBJCSTR(vcard->bday()),
       OBJCSTR(vcard->desc()),
       OBJCSTR(vcard->url()),
       OBJCSTR(vcard->note()),
       OBJCSTR(jid.bare())];
    }
  }
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    for ( id<TMEngineDelegate> observer in [engine observers] ) {
      if ( [observer respondsToSelector:@selector(engine:handleVCard:)] ) {
        [observer engine:engine handleVCard:OBJCSTR(jid.bare())];
      }
    }
  });
  
}

void TMVCardHandler::handleVCardResult( VCardContext context, const JID& jid, StanzaError se )
{
  TKPRINTMETHOD();
  
  TMEngine *engine = (__bridge TMEngine *)getEngine();
  
  NSError *error = nil;
  if ( se != StanzaErrorUndefined ) {
    error = [[NSError alloc] initWithDomain:@"VCard" code:se userInfo:nil];
  }
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    if ( context == FetchVCard ) {
      for ( id<TMEngineDelegate> observer in [engine observers] ) {
        if ( [observer respondsToSelector:@selector(engine:handleFetchVCardResult:error:)] ) {
          [observer engine:engine handleFetchVCardResult:OBJCSTR(jid.bare()) error:error];
        }
      }
    } else if ( context == StoreVCard ) {
      for ( id<TMEngineDelegate> observer in [engine observers] ) {
        if ( [observer respondsToSelector:@selector(engine:handleStoreVCardResult:error:)] ) {
          [observer engine:engine handleStoreVCardResult:OBJCSTR(jid.bare()) error:error];
        }
      }
    }
  });
  
}
