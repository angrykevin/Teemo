//
//  RSBuddiesViewController.m
//  Teemo
//
//  Created by Wu Kevin on 11/12/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSBuddiesViewController.h"
#import "RSBuddyCell.h"

#import "RSChatViewController.h"
#import "RSProfileViewController.h"


@implementation RSBuddiesViewController

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
  
  _navigationView.titleLabel.text = NSLocalizedString(@"Buddies", @"");
  
  
  _buddies = [[TKDatabase sharedObject] executeQuery:@"SELECT * FROM tBuddy;"];
  
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  [_contentView addSubview:_tableView];
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  NSIndexPath *ip = [_tableView indexPathForSelectedRow];
  if ( ip ) {
    [_tableView deselectRowAtIndexPath:ip animated:YES];
  }
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
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
    cell.nicknameLabel.text = [row stringForName:@"nickname"];
    cell.descLabel.text = [row stringForName:@"desc"];
    
    [cell loadPhoto:[row stringForName:@"photo"]];
    
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
  RSChatViewController *vc = [[RSChatViewController alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
  TKDatabaseRow *row = [_buddies objectOrNilAtIndex:indexPath.row];
  if ( row ) {
    RSProfileViewController *vc = [[RSProfileViewController alloc] initWithRow:row];
    [self.navigationController pushViewController:vc animated:YES];
  }
}

@end
