//
//  RSChatlogViewController.mm
//  Teemo
//
//  Created by Wu Kevin on 11/12/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSChatlogViewController.h"
#import "Teemo.h"
#import "RSCommon.h"


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
  
  
  _navigationView.titleLabel.text = NSLocalizedString(@"Chatlog", @"");
  
  
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
  NSDictionary *photos = @{
                      @"ALEX": @"http://www.touxiang.cn/uploads/20131127/27-082443_622.jpg",
                      @"TOM": @"http://www.touxiang.cn/uploads/20131127/27-082444_443.jpg",
                      @"KEVIN": @"http://www.touxiang.cn/uploads/20131127/27-082733_698.jpg",
                      @"LILY": @"http://www.touxiang.cn/uploads/20131127/27-082445_141.jpg",
                      @"ROSE": @"http://www.touxiang.cn/uploads/20131127/27-082448_631.jpg",
                      
                      @"TONY": @"http://www.touxiang.cn/uploads/20131127/27-082449_760.jpg",
                      @"JIMMY": @"http://www.touxiang.cn/uploads/20131127/27-082450_440.jpg",
                      @"JOY": @"http://www.touxiang.cn/uploads/20131127/27-082450_935.jpg",
                      @"ERIC": @"http://www.touxiang.cn/uploads/20131127/27-082451_330.jpg",
                      @"AMY": @"http://www.touxiang.cn/uploads/20131127/27-082451_545.jpg",
                      
                      @"JACKY": @"http://www.touxiang.cn/uploads/20131127/27-082454_756.jpg",
                      @"JOHN": @"http://www.touxiang.cn/uploads/20131127/27-082455_359.jpg",
                      @"ANDY": @"http://www.touxiang.cn/uploads/20131127/27-082501_580.jpg",
                      @"RAY": @"http://www.touxiang.cn/uploads/20131127/27-082502_857.jpg",
                      @"BOB": @"http://www.touxiang.cn/uploads/20131127/27-082502_224.jpg",
                      
                      @"BILL": @"http://www.touxiang.cn/uploads/20131127/27-082503_415.jpg",
                      @"DANIEL": @"http://www.touxiang.cn/uploads/20131127/27-082507_457.jpg",
                      @"DAVID": @"http://www.touxiang.cn/uploads/20131127/27-082508_286.jpg",
                      @"EASON": @"http://www.touxiang.cn/uploads/20131127/27-082648_454.jpg",
                      @"EVA": @"http://www.touxiang.cn/uploads/20131127/27-082652_788.jpg",
                      
                      @"FORD": @"http://www.touxiang.cn/uploads/20131127/27-082734_635.jpg",
                      @"HENRY": @"http://www.touxiang.cn/uploads/20131127/27-082659_148.jpg",
                      @"JEFF": @"http://www.touxiang.cn/uploads/20131127/27-082700_864.jpg",
                      @"MARY": @"http://www.touxiang.cn/uploads/20131127/27-082701_882.jpg",
                      @"SAM": @"http://www.touxiang.cn/uploads/20131127/27-082736_580.jpg"
                      };
  
  NSString *passport = RSAccountPassport();
  NSString *tmp1 = [passport substringToIndex:1];
  NSString *tmp2 = [passport substringFromIndex:1];
  NSString *name = [NSString stringWithFormat:@"%@%@", [tmp1 uppercaseString], tmp2];
  
  
  NSString *nickname = [name uppercaseString];
  NSString *uri = photos[ nickname ];
  NSString *desc = [NSString stringWithFormat:@"I'm %@!", name];
  NSString *url = [NSString stringWithFormat:@"http://%@.com/", [name lowercaseString]];
  
  TMEngine *engine = [TMEngine sharedEngine];
  VCardManager *manager = [engine vcardManager];
  
  VCard *card = new VCard();
  card->setNickname( CPPSTR(nickname) );
  card->setName( "Wu", CPPSTR(name));
  card->setPhotoUri( CPPSTR(uri) );
  card->setBday( "1988-03-08" );
  card->setDesc( CPPSTR(desc) );
  card->setUrl( CPPSTR(url) );
  
  manager->storeVCard(card, [engine vcardHandler]);
  
  
//  TMEngine *engine = [TMEngine sharedEngine];
//  RosterManager *manager = [engine rosterManager];
//  
//  manager->remove( JID( "kevin@batoo.com" ) );
//  //manager->subscribe( JID( "kevin@batoo.com" ) );
  
  
  //NSArray *values = @[ @"1", @"4" ];
//  NSString *va = @"6,4";
//  NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_buddy WHERE subscription IN(%@);", va];
//  TMEngine *engine = [TMEngine sharedEngine];
//  NSArray *ary = [[engine database] executeQuery:sql];
//  NSLog(@"%@", ary);
  
}

- (void)fetch:(id)sender
{
  TMEngine *engine = [TMEngine sharedEngine];
  VCardManager *manager = [engine vcardManager];
  manager->fetchVCard(JID( CPPSTR(TMJIDFromPassport(engine.passport)) ), [engine vcardHandler]);
}

@end
