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
  
  [self reloadRoster];
  [self addFooterIfNeeded];
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [_tableView deselectAllRowsAnimated:YES];
}

- (void)layoutViews
{
  [super layoutViews];
  
  _tableView.frame = _contentView.bounds;
  
}




- (void)reloadRoster
{
  
  NSDictionary *openedGroup = [_groups objectOrNilAtIndex:[self indexOfOpenedGroup:_groups]];
  
  TMEngine *engine = [TMEngine sharedEngine];
  NSArray *dbGroups = [[engine database] executeQuery:@"SELECT DISTINCT groupname FROM tBuddy ORDER BY groupname;"];
  
  
  NSMutableArray *groups = [[NSMutableArray alloc] init];
  
  for ( int i=0; i<[dbGroups count]; ++i ) {
    
    TKDatabaseRow *dbGroup = [dbGroups objectAtIndex:i];
    
    
    NSMutableDictionary *group = [[NSMutableDictionary alloc] init];
    
    NSString *groupName = [dbGroup stringForName:@"groupname"];
    if ( [groupName length] <= 0 ) {
      [group setObject:RSDefaultGroupName forKeyIfNotNil:@"name"];
    } else {
      [group setObject:groupName forKeyIfNotNil:@"name"];
    }
    
    NSArray *dbBuddies = [[engine database] executeQuery:@"SELECT * FROM tBuddy WHERE groupname=? ORDER BY nickname;", groupName];
    NSMutableArray *buddies = [dbBuddies mutableCopy];
    [group setObject:buddies forKeyIfNotNil:@"buddies"];
    
    
    if ( [[group objectForKey:@"name"] isEqualToString:[openedGroup objectForKey:@"name"]] ) {
      [group setObject:[NSNumber numberWithBool:YES] forKeyIfNotNil:@"open"];
    } else {
      [group setObject:[NSNumber numberWithBool:NO] forKeyIfNotNil:@"open"];
    }
    
    [groups addObject:group];
    
  }
  
  _groups = groups;
  
}

- (void)addFooterIfNeeded
{
  if ( [_groups count] > 0 ) {
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

- (int)indexOfOpenedGroup:(NSArray *)groups
{
  for ( int i=0; i<[groups count]; ++i ) {
    NSMutableDictionary *item = [groups objectAtIndex:i];
    if ( [[item objectForKey:@"open"] boolValue] ) {
      return i;
    }
  }
  return -1;
}




- (void)groupButtonClicked:(id)sender
{
  TKPRINTMETHOD();
  
  int section = [sender tag];
  NSMutableDictionary *group = [_groups objectAtIndex:section];
  //NSArray *buddies = [group objectForKey:@"buddies"];
  //NSString *name = [group objectForKey:@"name"];
  NSNumber *open = [group objectForKey:@"open"];
  
  if ( [open boolValue] ) {
    [group setObject:[NSNumber numberWithBool:NO] forKey:@"open"];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section]
              withRowAnimation:UITableViewRowAnimationFade];
  } else {
    int openedSection = [self indexOfOpenedGroup:_groups];
    NSMutableDictionary *openedGroup = [_groups objectOrNilAtIndex:openedSection];
    
    if ( (openedSection>=0) && (openedGroup!=nil) ) {
      [openedGroup setObject:[NSNumber numberWithBool:NO] forKey:@"open"];
      [_tableView reloadSections:[NSIndexSet indexSetWithIndex:openedSection]
                withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [group setObject:[NSNumber numberWithBool:YES] forKey:@"open"];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section]
              withRowAnimation:UITableViewRowAnimationFade];
    
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
  return [_groups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSDictionary *group = [_groups objectAtIndex:section];
  NSNumber *open = [group objectForKey:@"open"];
  if ( [open boolValue] ) {
    NSArray *buddies = [group objectForKey:@"buddies"];
    return [buddies count];
  }
  return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  RSBuddyCell *cell = (RSBuddyCell *)[tableView dequeueReusableCellWithClass:[RSBuddyCell class]];
  
  NSDictionary *group = [_groups objectAtIndex:indexPath.section];
  NSArray *buddies = [group objectForKey:@"buddies"];
  TKDatabaseRow *row = [buddies objectOrNilAtIndex:indexPath.row];
  if ( row ) {
    cell.nicknameLabel.text = [row stringForName:@"nickname"];
    cell.descLabel.text = [row stringForName:@"desc"];
    
    cell.photoButton.info = row;
    
    [cell.photoButton addTarget:self
                         action:@selector(photoButtonClicked:)
               forControlEvents:UIControlEventTouchUpInside];
    
    [cell loadPhoto:[row stringForName:@"photo"]];
    
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
  
  
  NSDictionary *group = [_groups objectAtIndex:section];
  NSArray *buddies = [group objectForKey:@"buddies"];
  NSString *name = [group objectForKey:@"name"];
  //NSNumber *open = [group objectForKey:@"open"];
  
  nameLabel.text = name;
  
  statisticsLabel.text = [NSString stringWithFormat:@"%d", [buddies count]];
  
  return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 40.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSDictionary *group = [_groups objectAtIndex:indexPath.section];
  NSArray *buddies = [group objectForKey:@"buddies"];
  TKDatabaseRow *row = [buddies objectOrNilAtIndex:indexPath.row];
  if ( row ) {
    RSChatViewController *vc = [[RSChatViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
  }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
  NSDictionary *group = [_groups objectAtIndex:indexPath.section];
  NSArray *buddies = [group objectForKey:@"buddies"];
  TKDatabaseRow *row = [buddies objectOrNilAtIndex:indexPath.row];
  if ( row ) {
    RSProfileViewController *vc = [[RSProfileViewController alloc] initWithRow:row];
    [self.navigationController pushViewController:vc animated:YES];
  }
}




- (void)vcardOnReceived:(const JID &)jid vcard:(const VCard *)vcard
{
  TKPRINTMETHOD();
  [self reloadRoster];
  [_tableView reloadData];
  [self addFooterIfNeeded];
}

//- (void)vcardOnResult:(const JID &)jid context:(VCardHandler::VCardContext)context error:(StanzaError)se
//{
//  TKPRINTMETHOD();
//}



- (void)rosterOnItemAdded:(const JID &)jid
{
  TKPRINTMETHOD();
  [self reloadRoster];
  [_tableView reloadData];
  [self addFooterIfNeeded];
}

- (void)rosterOnItemSubscribed:(const JID &)jid
{
  TKPRINTMETHOD();
}

- (void)rosterOnItemRemoved:(const JID &)jid
{
  TKPRINTMETHOD();
  [self reloadRoster];
  [_tableView reloadData];
  [self addFooterIfNeeded];
}

- (void)rosterOnItemUpdated:(const JID &)jid
{
  TKPRINTMETHOD();
  [self reloadRoster];
  [_tableView reloadData];
  [self addFooterIfNeeded];
}

- (void)rosterOnItemUnsubscribed:(const JID &)jid
{
  TKPRINTMETHOD();
}

- (void)rosterOnReceived:(const Roster &)roster
{
  TKPRINTMETHOD();
  [self reloadRoster];
  [_tableView reloadData];
  [self addFooterIfNeeded];
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
