//
//  RSProfileViewController.mm
//  Teemo
//
//  Created by Wu Kevin on 11/15/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSProfileViewController.h"
#import "RSCommon.h"
#import "Teemo.h"
#import "RSProfileHeaderView.h"
#import "RSProfileFooterView.h"
#import "RSProfileCell.h"

@implementation RSProfileViewController


- (id)initWithRow:(TKDatabaseRow *)row
{
  self = [super init];
  if (self) {
    
    _row = row;
    
    NSAssert((_row != nil), @"row error");
    
    NSString *bid = [_row stringForName:@"bid"];
    
    JID owner = JID( CPPSTR(TMJIDFromPassport(RSAccountPassport())) );
    JID current = JID( CPPSTR(bid) );
    _isOwner = ( owner.bare() == current.bare() );
    
  }
  return self;
}

- (id)initWithBid:(NSString *)bid
{
  self = [super init];
  if (self) {
    
    NSAssert(([bid length]>0), @"bid error");
    
    NSArray *buddies = [[TKDatabase sharedObject] executeQuery:@"SELECT * FROM tBuddy WHERE bid=?;", bid];
    _row = [buddies firstObject];
    
    NSAssert((_row != nil), @"row error");
    
    JID owner = JID( CPPSTR(TMJIDFromPassport(RSAccountPassport())) );
    JID current = JID( CPPSTR(bid) );
    _isOwner = ( owner.bare() == current.bare() );
    
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [_navigationView showBackButton];
  _navigationView.titleLabel.text = [_row stringForName:@"nickname"];
  
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  [_contentView addSubview:_tableView];
  
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [self addHeaderView];
  [self addFooterViewIfNeeded];
  
  
  NSIndexPath *ip = [_tableView indexPathForSelectedRow];
  if ( ip ) {
    [_tableView deselectRowAtIndexPath:ip animated:YES];
  }
}

- (void)layoutViews
{
  [super layoutViews];
  
  _tableView.frame = _contentView.bounds;
  
}


- (void)addHeaderView
{
  RSProfileHeaderView *header = [[RSProfileHeaderView alloc] init];
  [header.photoButton addTarget:self
                         action:@selector(photoButtonClicked:)
               forControlEvents:UIControlEventTouchUpInside];
  [header sizeToFit];
  
  [header loadPhoto:[_row stringForName:@"photo"]];
  header.jidLabel.text = [_row stringForName:@"bid"];
  
  _tableView.tableHeaderView = header;
  _tableView.tableHeaderView.frame = CGRectMake(0.0, 0.0, header.width, header.height);
}

- (void)addFooterViewIfNeeded
{
  if ( _isOwner ) {
    
    _tableView.tableFooterView = nil;
    
  } else {
    
    RSProfileFooterView *footer = [[RSProfileFooterView alloc] init];
    [footer.deleteButton addTarget:self
                            action:@selector(deleteButtonClicked:)
                  forControlEvents:UIControlEventTouchUpInside];
    [footer sizeToFit];
    
    _tableView.tableFooterView = footer;
    _tableView.tableFooterView.frame = CGRectMake(0.0, 0.0, footer.width, footer.height);
    
  }
}

- (void)photoButtonClicked:(id)sender
{
  TKPRINTMETHOD();
}

- (void)linkButtonClicked:(id)sender
{
  TKPRINTMETHOD();
  
  NSString *homepage = [[_row stringForName:@"homepage"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
  if ( [homepage length] > 0 ) {
    
    TBAlertView *alertView = [[TBAlertView alloc] initWithMessage:NSLocalizedString(@"Are you sure to open link?", @"")];
    
    [alertView addButtonWithTitle:NSLocalizedString(@"OK", @"") block:^{
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:homepage]];
    }];
    
    [alertView addCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:NULL];
    
    [alertView show];
    
  }
}

- (void)deleteButtonClicked:(id)sender
{
  TKPRINTMETHOD();
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  RSProfileCell *cell = (RSProfileCell *)[tableView dequeueReusableCellWithClass:[RSProfileCell class]];
  
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  int row = indexPath.row;
  if ( row == 0 ) {
    cell.titleLabel.text = NSLocalizedString(@"Nickname", @"");
    cell.valueButton.normalTitle = [_row stringForName:@"nickname"];
  } else if ( row == 1 ) {
    cell.titleLabel.text = NSLocalizedString(@"Name", @"");
    NSString *family = [_row stringForName:@"familyname"];
    NSString *given = [_row stringForName:@"givenname"];
    cell.valueButton.normalTitle = TBBuildFullName(given, family);
  } else if ( row == 2 ) {
    cell.titleLabel.text = NSLocalizedString(@"Birthday", @"");
    cell.valueButton.normalTitle = [_row stringForName:@"birthday"];
  } else if ( row == 3 ) {
    cell.titleLabel.text = NSLocalizedString(@"Homepage", @"");
    cell.valueButton.normalTitle = [_row stringForName:@"homepage"];
    cell.valueButton.enabled = YES;
    cell.valueButton.normalTitleColor = [UIColor blueColor];
    cell.valueButton.highlightedTitleColor = [UIColor darkGrayColor];
    [cell.valueButton addTarget:self
                         action:@selector(linkButtonClicked:)
               forControlEvents:UIControlEventTouchUpInside];
  } else if ( row == 4 ) {
    cell.titleLabel.text = NSLocalizedString(@"Description", @"");
    cell.valueButton.normalTitle = [_row stringForName:@"desc"];
  }
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [RSProfileCell heightForTableView:tableView object:nil];
}


@end
