//
//  RSChatlogViewController.m
//  Teemo
//
//  Created by Wu Kevin on 11/12/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSChatlogViewController.h"
#import "Teemo.h"


@implementation RSChatlogViewController

- (id)init
{
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  
  _navigationView.titleLabel.text = NSLocalizedString(@"会话", @"");
  
  
  UIButton *bt = [UIButton buttonWithType:UIButtonTypeSystem];
  bt.normalTitle = @"store";
  [bt addTarget:self action:@selector(store:) forControlEvents:UIControlEventTouchUpInside];
  [_contentView addSubview:bt];
  bt.frame = CGRectMake(10, 10, 300, 40);
  
  bt = [UIButton buttonWithType:UIButtonTypeSystem];
  bt.normalTitle = @"fetch";
  [bt addTarget:self action:@selector(fetch:) forControlEvents:UIControlEventTouchUpInside];
  [_contentView addSubview:bt];
  bt.frame = CGRectMake(10, 60, 300, 40);
  
}

- (void)store:(id)sender
{
//  TMEngine *engine = [TMEngine sharedEngine];
//  VCardManager *manager = [engine vcardManager];
//  
//  VCard *card = new VCard();
//  card->setNickname( "Alex" );
//  card->setName( "Wu", "Tom");
//  card->setPhotoUri( "http://v1.qzone.cc/avatar/201311/14/17/16/52849501170d3903.jpg!200x200.jpg" );
//  card->setBday( "1988-03-08" );
//  card->setDesc( "I'm Tom!" );
//  card->setUrl( "http://tom.com/" );
//  
//  manager->storeVCard(card, [engine vcardHandler]);
}

- (void)fetch:(id)sender
{
//  TMEngine *engine = [TMEngine sharedEngine];
//  VCardManager *manager = [engine vcardManager];
//  manager->fetchVCard(JID( CPPSTR(TMJIDFromPassport(engine.passport)) ), [engine vcardHandler]);
}

@end
