//
//  TMVCardHandler.mm
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "TMVCardHandler.h"
#import "TMMacro.h"
#import "TMVCardDelegate.h"

void TMVCardHandler::handleVCard( const JID& jid, const VCard* vcard )
{
  TMPRINTMETHOD();
  
  printf("jid: %s %s\n", jid.bare().c_str(), vcard->jabberid().c_str());
  printf("nickname: %s\n", vcard->nickname().c_str());
  printf("desc: %s\n", vcard->desc().c_str());
  printf("name: %s\n", vcard->formattedname().c_str());
  
  
//  TKDatabase *db = [TKDatabase sharedObject];
//  NSArray *buddies = [db executeQuery:@"SELECT passport FROM tBuddy WHERE passport=?;", CPPStrToC(jid.bare())];
//  if ( [buddies count] > 0 ) {
//    
//    [db executeUpdate:@"UPDATE tBuddy SET name=?, desc=? WHERE passport=?;",
//     CPPStrToC(vcard->nickname()),
//     CPPStrToC(vcard->desc()),
//     CPPStrToC(jid.bare())];
//  }
  
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMVCardDelegate> delegate = (__bridge id<TMVCardDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(vcardOnReceived:vcard:)] ) {
        [delegate vcardOnReceived:jid vcard:vcard];
      }
    }
    
  });
  
}

void TMVCardHandler::handleVCardResult( VCardContext context, const JID& jid, StanzaError se )
{
  TMPRINTMETHOD();
  
  printf("HH%s\n", jid.bare().c_str());
  
  
  dispatch_sync(dispatch_get_main_queue(), ^{
    
    list<void *>::const_iterator it = m_observers.begin();
    
    for( ; it != m_observers.end(); ++it ) {
      id<TMVCardDelegate> delegate = (__bridge id<TMVCardDelegate>)(*it);
      if ( [delegate respondsToSelector:@selector(vcardOnResult:context:error:)] ) {
        [delegate vcardOnResult:jid context:context error:se];
      }
    }
    
  });
  
}
