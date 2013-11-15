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
    [self reloadRoster];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _navigationView.titleLabel.text = NSLocalizedString(@"Buddies", @"");
  
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
  
  [self reloadRoster];
  [_tableView reloadData];
}

- (void)layoutViews
{
  [super layoutViews];
  
  _tableView.frame = _contentView.bounds;
  
}



- (void)reloadRoster
{
  
  TKDatabase *db = [TKDatabase sharedObject];
  
  NSMutableArray *groups = [[NSMutableArray alloc] init];
  
  NSArray *dbGroups = [db executeQuery:@"SELECT DISTINCT group FROM tBuddy ORDER BY group;"];
  
  for ( int i=0; i<[dbGroups count]; ++i ) {
    TKDatabaseRow *dbGroup = [dbGroups objectAtIndex:i];
    
    NSMutableDictionary *group = [[NSMutableDictionary alloc] init];
    [groups addObject:group];
    
    [group setObject:[NSNumber numberWithBool:NO] forKeyIfNotNil:@"open"];
    
    NSString *groupName = [dbGroup stringForName:@"group"];
    [group setObject:groupName forKeyIfNotNil:@"name"];
    
    
    NSArray *dbBuddies = [db executeQuery:@"SELECT * FROM tBuddy WHERE group=? ORDER BY nickname;", groupName];
    [group setObject:dbBuddies forKeyIfNotNil:@"buddies"];
    
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




- (void)groupButtonClicked:(id)sender
{
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
    int openedSection = -1;
    NSMutableDictionary *openedGroup = nil;
    for ( int i=0; i<[_groups count]; ++i ) {
      NSMutableDictionary *item = [_groups objectAtIndex:i];
      if ( [[item objectForKey:@"open"] boolValue] ) {
        openedSection = i;
        openedGroup = item;
        break;
      }
    }
    
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
  header.frame = CGRectMake(0.0, 0.0, 320.0, 30.0);
  
  UILabel *nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12.0]
                                    textColor:[UIColor blackColor]
                              backgroundColor:[UIColor clearColor]
                                textAlignment:NSTextAlignmentLeft
                                lineBreakMode:NSLineBreakByTruncatingTail
                    adjustsFontSizeToFitWidth:NO
                                numberOfLines:1];
  [header addSubview:nameLabel];
  nameLabel.frame = CGRectMake(10.0, 0.0, 250.0, 30.0);
  
  UILabel *statisticsLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12.0]
                                          textColor:[UIColor darkGrayColor]
                                    backgroundColor:[UIColor clearColor]
                                      textAlignment:NSTextAlignmentRight
                                      lineBreakMode:NSLineBreakByTruncatingTail
                          adjustsFontSizeToFitWidth:NO
                                      numberOfLines:1];
  [header addSubview:statisticsLabel];
  statisticsLabel.frame = CGRectMake(260.0, 0.0, 50.0, 30.0);
  
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
  return 30.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  RSChatViewController *vc = [[RSChatViewController alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
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

@end
