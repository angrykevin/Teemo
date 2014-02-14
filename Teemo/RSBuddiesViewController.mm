//
//  RSBuddiesViewController.mm
//  Teemo
//
//  Created by Wu Kevin on 11/12/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSBuddiesViewController.h"

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
    [[TMEngine sharedEngine] addObserver:self];
  }
  return self;
}

- (void)dealloc
{
  [[TMEngine sharedEngine] removeObserver:self];
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
  //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [_contentView addSubview:_tableView];
  
  [self addFooterIfNeeded];
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [_tableView deselectAllRowsAnimated:YES];
  
  
  [self reloadBuddies];
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
  if ( [_buddies count] > 0 ) {
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

- (void)reloadBuddies
{
  NSMutableArray *toSubscriptions = [[NSMutableArray alloc] init];
  [toSubscriptions addObject:[NSString stringWithFormat:@"%d", S10nTo]];
  [toSubscriptions addObject:[NSString stringWithFormat:@"%d", S10nToIn]];
  [toSubscriptions addObject:[NSString stringWithFormat:@"%d", S10nBoth]];
  _buddies = [[TMEngine sharedEngine] buddiesForSubscriptions:toSubscriptions];
}

- (void)refreshTableView
{
  if ( _viewAppeared ) {
    [self reloadBuddies];
    [_tableView reloadData];
    [self addFooterIfNeeded];
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
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_buddies count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  RSBuddyCell *cell = (RSBuddyCell *)[tableView dequeueReusableCellWithClass:[RSBuddyCell class]];
  
  TKDatabaseRow *row = [_buddies objectOrNilAtIndex:indexPath.row];
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
    [cell loadPhoto:[row stringForName:@"photo"]
   placeholderImage:[UIImage imageNamed:@"default_avatar.png"]];
    
    Presence::PresenceType presence = (Presence::PresenceType)[row intForName:@"presence"];
    if ( (presence == Presence::Available) || (presence == Presence::Chat) ) {
      cell.statusImageView.image = [UIImage imageNamed:@"status_online.png"];
    } else if ( (presence == Presence::Away) || (presence == Presence::XA) ) {
      cell.statusImageView.image = [UIImage imageNamed:@"status_away.png"];
    } else if ( presence == Presence::DND ) {
      cell.statusImageView.image = [UIImage imageNamed:@"status_dnd.png"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
  }
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [RSBuddyCell heightForTableView:tableView object:nil];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  TKDatabaseRow *row = [_buddies objectOrNilAtIndex:indexPath.row];
  if ( row ) {
    RSChatViewController *vc = [[RSChatViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
  }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
  TKDatabaseRow *row = [_buddies objectOrNilAtIndex:indexPath.row];
  if ( row ) {
    RSProfileViewController *vc = [[RSProfileViewController alloc] initWithRow:row];
    [self.navigationController pushViewController:vc animated:YES];
  }
}




- (void)engineHandleRoster:(TMEngine *)engine
{
  [self refreshTableView];
}

- (void)engine:(TMEngine *)engine handleRosterError:(NSError *)error
{
}

- (void)engine:(TMEngine *)engine handleItemAdded:(NSString *)jid
{
  [self refreshTableView];
}

- (void)engine:(TMEngine *)engine handleItemRemoved:(NSString *)jid
{
  [self refreshTableView];
}

- (void)engine:(TMEngine *)engine handleItemUpdated:(NSString *)jid
{
  [self refreshTableView];
}

- (void)engine:(TMEngine *)engine handleItemSubscribed:(NSString *)jid
{
}

- (void)engine:(TMEngine *)engine handleItemUnsubscribed:(NSString *)jid
{
}

- (void)engine:(TMEngine *)engine handleSubscriptionRequest:(NSString *)jid message:(NSString *)message
{
}

- (void)engine:(TMEngine *)engine handleUnsubscriptionRequest:(NSString *)jid message:(NSString *)message
{
}


- (void)engine:(TMEngine *)engine handleVCard:(NSString *)jid
{
  [self refreshTableView];
}

@end
