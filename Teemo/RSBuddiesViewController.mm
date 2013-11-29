//
//  RSBuddiesViewController.mm
//  Teemo
//
//  Created by Wu Kevin on 11/12/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSBuddiesViewController.h"
#import "RSCommon.h"
#import "Teemo.h"

#import "RSBuddyCell.h"

#import "RSAddBuddyViewController.h"
#import "RSChatViewController.h"
#import "RSProfileViewController.h"


@implementation RSBuddiesViewController

- (id)init
{
  self = [super init];
  if (self) {
    
    TMEngine *engine = [TMEngine sharedEngine];
    [engine vcardHandler]->addObserver((__bridge void *)self);
    [engine rosterHandler]->addObserver((__bridge void *)self);
    
    _rosterModel = [[RSRosterModel alloc] init];
    
  }
  return self;
}

- (void)dealloc
{
  TMEngine *engine = [TMEngine sharedEngine];
  [engine vcardHandler]->removeObserver((__bridge void *)self);
  [engine rosterHandler]->removeObserver((__bridge void *)self);
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [_navigationView showRightButton];
  _navigationView.rightButton.normalTitle = NSLocalizedString(@"Add", @"");
  _navigationView.titleLabel.text = NSLocalizedString(@"Buddies", @"");
  
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [_contentView addSubview:_tableView];
  
  [self addFooterIfNeeded];
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [_tableView deselectAllRowsAnimated:YES];
  
  
  [_rosterModel reloadGroups];
  [self reloadOpenedMap];
  [_tableView reloadData];
  [self addFooterIfNeeded];
  
}

- (void)layoutViews
{
  [super layoutViews];
  
  _tableView.frame = _contentView.bounds;
  
}


- (void)addFooterIfNeeded
{
  if ( [_rosterModel.groups count] > 0 ) {
    _tableView.tableFooterView = nil;
  } else {
    UIView *footer = [[UIView alloc] init];
    footer.frame = CGRectMake(0.0, 0.0, 320.0, 100.0);
    
    UILabel *label = [UILabel labelWithFont:[UIFont boldSystemFontOfSize:14.0]
                                  textColor:[UIColor darkGrayColor]
                            backgroundColor:[UIColor clearColor]
                              textAlignment:NSTextAlignmentCenter
                              lineBreakMode:NSLineBreakByWordWrapping
                  adjustsFontSizeToFitWidth:NO
                              numberOfLines:0];
    [footer addSubview:label];
    label.frame = CGRectMake(10.0, 35.0, 300.0, 30.0);
    label.text = NSLocalizedString(@"There's no buddy yet!", @"");
    
    _tableView.tableFooterView = footer;
    _tableView.tableFooterView.frame = CGRectMake(0.0, 0.0, 320.0, 100.0);
  }
}

- (void)reloadOpenedMap
{
  NSString *openedGroupName = [self openedGroupName:_openedMap];
  
  NSMutableDictionary *openedMap = [[NSMutableDictionary alloc] init];
  for ( RSRosterGroup *group in _rosterModel.groups ) {
    if ( [group.displayname isEqualToString:openedGroupName] ) {
      [openedMap setObject:[NSNumber numberWithBool:YES] forKey:group.displayname];
    } else {
      [openedMap setObject:[NSNumber numberWithBool:NO] forKey:group.displayname];
    }
  }
  
  _openedMap = openedMap;
}


- (NSString *)openedGroupName:(NSDictionary *)openedMap
{
  for ( NSString *key in [_openedMap keyEnumerator] ) {
    NSNumber *value = [_openedMap objectForKey:key];
    if ( [value boolValue] ) {
      return key;
    }
  }
  return nil;
}




- (void)groupButtonClicked:(id)sender
{
  TKPRINTMETHOD();
  
  int section = [sender tag];
  RSRosterGroup *group = [_rosterModel.groups objectAtIndex:section];
  
  NSNumber *open = [_openedMap objectForKey:group.displayname];
  
  if ( [open boolValue] ) {
    [_openedMap setObject:[NSNumber numberWithBool:NO] forKey:group.displayname];
    [_tableView reloadData];
    //[_tableView reloadSections:[NSIndexSet indexSetWithIndex:section]
    //          withRowAnimation:UITableViewRowAnimationFade];
  } else {
    
    for ( NSString *key in [_openedMap keyEnumerator] ) {
      [_openedMap setObject:[NSNumber numberWithBool:NO] forKey:key];
    }
    
    [_openedMap setObject:[NSNumber numberWithBool:YES] forKey:group.displayname];
    [_tableView reloadData];
    
  }
}

- (void)photoButtonClicked:(id)sender
{
  TKPRINTMETHOD();
  
  TBButton *button = (TBButton *)sender;
  TKDatabaseRow *row = button.info;
  if ( row ) {
    RSProfileViewController *vc = [[RSProfileViewController alloc] initWithRow:row];
    [self.navigationController pushViewController:vc animated:YES];
  }
  
}

- (void)rightButtonClicked:(id)sender
{
  RSAddBuddyViewController *vc = [[RSAddBuddyViewController alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [_rosterModel.groups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  RSRosterGroup *group = [_rosterModel.groups objectAtIndex:section];
  NSNumber *opened = [_openedMap objectForKey:group.displayname];
  if ( [opened boolValue] ) {
    return [group.buddies count];
  }
  return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  RSBuddyCell *cell = (RSBuddyCell *)[tableView dequeueReusableCellWithClass:[RSBuddyCell class]];
  
  RSRosterGroup *group = [_rosterModel.groups objectAtIndex:indexPath.section];
  RSRosterBuddy *buddy = [group.buddies objectOrNilAtIndex:indexPath.row];
  TKDatabaseRow *row = buddy.dbObject;
  if ( row ) {
    
    NSString *displayname = [row stringForName:@"displayname"];
    if ( [displayname length] > 0 ) {
      cell.nicknameLabel.text = displayname;
    } else {
      NSString *nickname = [row stringForName:@"nickname"];
      if ( [nickname length] > 0 ) {
        cell.nicknameLabel.text = nickname;
      } else {
        cell.nicknameLabel.text = [row stringForName:@"bid"];
      }
    }
    
    cell.descLabel.text = [row stringForName:@"desc"];
    
    cell.photoButton.info = row;
    
    [cell.photoButton addTarget:self
                         action:@selector(photoButtonClicked:)
               forControlEvents:UIControlEventTouchUpInside];
    
    [cell loadPhoto:[row stringForName:@"photo"] block:^UIImage *(UIImage *image) {
      if ( buddy.presenceType == Presence::Unavailable ) {
        
        CGFloat originalWidth = image.size.width;
        CGFloat originalHeight = image.size.height;
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGContextRef context = CGBitmapContextCreate(NULL,
                                                     originalWidth,
                                                     originalHeight,
                                                     8,
                                                     3*originalWidth,
                                                     colorSpace,
                                                     kCGImageAlphaNone);
        CGColorSpaceRelease(colorSpace);
        
        // Image quality
        CGContextSetShouldAntialias(context, false);
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
        
        // Draw the image in the bitmap context
        CGContextDrawImage(context, CGRectMake(0.0, 0.0, originalWidth, originalHeight), image.CGImage);
        
        // Create an image object from the context
        CGImageRef grayscaleImageRef = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        UIImage *grayscaleImage = [UIImage imageWithCGImage:grayscaleImageRef];
        CGImageRelease(grayscaleImageRef);
        
        return grayscaleImage;
        
      }
      return image;
    }];
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
  }
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [RSBuddyCell heightForTableView:tableView object:nil];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  UIView *header = [[UIView alloc] init];
  header.frame = CGRectMake(0.0, 0.0, 320.0, 40.0);
  
  UILabel *nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12.0]
                                    textColor:[UIColor blackColor]
                              backgroundColor:[UIColor clearColor]
                                textAlignment:NSTextAlignmentLeft
                                lineBreakMode:NSLineBreakByTruncatingTail
                    adjustsFontSizeToFitWidth:NO
                                numberOfLines:1];
  [header addSubview:nameLabel];
  nameLabel.frame = CGRectMake(10.0, 0.0, 250.0, 40.0);
  
  UILabel *statisticsLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12.0]
                                          textColor:[UIColor darkGrayColor]
                                    backgroundColor:[UIColor clearColor]
                                      textAlignment:NSTextAlignmentRight
                                      lineBreakMode:NSLineBreakByTruncatingTail
                          adjustsFontSizeToFitWidth:NO
                                      numberOfLines:1];
  [header addSubview:statisticsLabel];
  statisticsLabel.frame = CGRectMake(260.0, 0.0, 50.0, 40.0);
  
  UIButton *button = [[UIButton alloc] init];
  button.tag = section;
  [button addTarget:self action:@selector(groupButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  [header addSubview:button];
  button.frame = header.bounds;
  
  RSRosterGroup *group = [_rosterModel.groups objectAtIndex:section];
  nameLabel.text = group.displayname;
  statisticsLabel.text = [NSString stringWithFormat:@"%d", [group.buddies count]];
  
  return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 40.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  RSRosterGroup *group = [_rosterModel.groups objectAtIndex:indexPath.section];
  RSRosterBuddy *buddy = [group.buddies objectOrNilAtIndex:indexPath.row];
  TKDatabaseRow *row = buddy.dbObject;
  if ( row ) {
    RSChatViewController *vc = [[RSChatViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
  }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
  RSRosterGroup *group = [_rosterModel.groups objectAtIndex:indexPath.section];
  RSRosterBuddy *buddy = [group.buddies objectOrNilAtIndex:indexPath.row];
  TKDatabaseRow *row = buddy.dbObject;
  if ( row ) {
    RSProfileViewController *vc = [[RSProfileViewController alloc] initWithRow:row];
    [self.navigationController pushViewController:vc animated:YES];
  }
}




- (void)vcardOnReceived:(const JID &)jid vcard:(const VCard *)vcard
{
  TKPRINTMETHOD();
  if ( _viewAppeared ) {
    [_rosterModel reloadGroups];
    [self reloadOpenedMap];
    [_tableView reloadData];
    [self addFooterIfNeeded];
  }
}

//- (void)vcardOnResult:(const JID &)jid context:(VCardHandler::VCardContext)context error:(StanzaError)se
//{
//  TKPRINTMETHOD();
//}



- (void)rosterOnItemAdded:(const JID &)jid
{
  TKPRINTMETHOD();
  if ( _viewAppeared ) {
    [_rosterModel reloadGroups];
    [self reloadOpenedMap];
    [_tableView reloadData];
    [self addFooterIfNeeded];
  }
}

- (void)rosterOnItemSubscribed:(const JID &)jid
{
  TKPRINTMETHOD();
}

- (void)rosterOnItemRemoved:(const JID &)jid
{
  TKPRINTMETHOD();
  if ( _viewAppeared ) {
    [_rosterModel reloadGroups];
    [self reloadOpenedMap];
    [_tableView reloadData];
    [self addFooterIfNeeded];
  }
}

- (void)rosterOnItemUpdated:(const JID &)jid
{
  TKPRINTMETHOD();
  if ( _viewAppeared ) {
    [_rosterModel reloadGroups];
    [self reloadOpenedMap];
    [_tableView reloadData];
    [self addFooterIfNeeded];
  }
}

- (void)rosterOnItemUnsubscribed:(const JID &)jid
{
  TKPRINTMETHOD();
}

- (void)rosterOnReceived:(const Roster &)roster
{
  TKPRINTMETHOD();
  if ( _viewAppeared ) {
    [_rosterModel reloadGroups];
    [self reloadOpenedMap];
    [_tableView reloadData];
    [self addFooterIfNeeded];
  }
}

- (void)rosterOnPresence:(const RosterItem &)item
                resource:(const std::string &)resource
                presence:(Presence::PresenceType)presence
                     msg:(const std::string &)msg
{
  TKPRINTMETHOD();
}

- (void)rosterOnSelfPresence:(const RosterItem &)item
                    resource:(const std::string &)resource
                    presence:(Presence::PresenceType)presence
                         msg:(const std::string &)msg
{
  TKPRINTMETHOD();
}

- (bool)rosterOnSubscriptionRequest:(const JID &)jid msg:(const std::string &)msg
{
  TKPRINTMETHOD();
  return true;
}

- (bool)rosterOnUnsubscriptionRequest:(const JID &)jid msg:(const std::string &)msg
{
  TKPRINTMETHOD();
  return true;
}

- (void)rosterOnNonrosterPresence:(const Presence &)presence
{
  TKPRINTMETHOD();
}

- (void)rosterOnError:(const IQ &)iq
{
  TKPRINTMETHOD();
}

@end
