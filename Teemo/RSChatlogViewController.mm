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
  bt.normalTitle = @"doit";
  [bt addTarget:self action:@selector(doit:) forControlEvents:UIControlEventTouchUpInside];
  [_contentView addSubview:bt];
  bt.frame = CGRectMake(10, 10, 300, 40);
  
}

- (void)doit:(id)sender
{
  
  TMEngine *engine = [TMEngine sharedEngine];
  VCardManager *manager = [engine vcardManager];
  
//  VCard *card = new VCard();
//  card->setFormattedname( "ALX3216" );
//  card->setDesc( "Give it to me !" );
//  manager->storeVCard(card, [engine vcardHandler]);
  
  manager->fetchVCard(JID( CStrToCPP(TMJIDFromPassport(engine.passport)) ), [engine vcardHandler]);
}

@end
