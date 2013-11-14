//
//  RSBuddiesViewController.m
//  Teemo
//
//  Created by Wu Kevin on 11/12/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSBuddiesViewController.h"
#import "RSBuddyCell.h"


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
  
  _navigationView.titleLabel.text = NSLocalizedString(@"好友", @"");
  
  
  _buddies = [[TKDatabase sharedObject] executeQuery:@"SELECT * FROM tBuddy;"];
  
  
  _tableView = [[UITableView alloc] init];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  [_contentView addSubview:_tableView];
  
}

- (void)layoutViews
{
  [super layoutViews];
  
  _tableView.frame = _contentView.bounds;
  
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
  
  [UIView showBorder:cell level:0];
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [RSBuddyCell heightForTableView:tableView object:nil];
}

@end
