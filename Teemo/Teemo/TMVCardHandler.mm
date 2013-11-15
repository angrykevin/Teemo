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
  
  printf("jid: %s\n", jid.bare().c_str());
  
  printf("nickname: %s\n", vcard->nickname().c_str());
  printf("familyname: %s\n", vcard->name().family.c_str());
  printf("givenname: %s\n", vcard->name().given.c_str());
  printf("photo: %s\n", vcard->photo().extval.c_str());
  printf("birthday: %s\n", vcard->bday().c_str());
  printf("desc: %s\n", vcard->desc().c_str());
  printf("homepage: %s\n", vcard->url().c_str());
  
  if ( jid.bare().length() > 0 ) {
    
    
    NSString *bid = OBJCSTR(jid.bare());
    
    TKDatabase *db = [TKDatabase sharedObject];
    
    NSArray *buddies = [db executeQuery:@"SELECT pk,bid,group FROM tBuddy WHERE bid=?;", bid];
    if ( [buddies count] > 0 ) {
      TKDatabaseRow *row = [buddies firstObject];
      
      int pk = [row intForName:@"pk"];
      NSString *group = [row stringForName:@"group"];
      
      [db executeUpdate:@"DELETE FROM tBuddy WHERE bid=?;", bid];
      
      [db executeUpdate:@"INSERT INTO tBuddy(pk,bid,nickname,familyname,givenname,photo,birthday,desc,homepage,group) VALUES(?,?,?,?,?,?,?,?,?,?);",
       [NSNumber numberWithInt:pk],
       bid,
       OBJCSTR( vcard->nickname() ),
       OBJCSTR( vcard->name().family ),
       OBJCSTR( vcard->name().given ),
       OBJCSTR( vcard->photo().extval ),
       OBJCSTR( vcard->bday() ),
       OBJCSTR( vcard->desc() ),
       OBJCSTR( vcard->url() ),
       group];
      
    }
    
  }
  
  
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
