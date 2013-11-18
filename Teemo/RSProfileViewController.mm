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
#import "RSEditProfileViewController.h"

@implementation RSProfileViewController


- (id)initWithRow:(TKDatabaseRow *)row
{
  self = [super init];
  if (self) {
    
    NSAssert((row != nil), @"row error");
    
    _row = row;
    
    _editedRow = [[NSMutableDictionary alloc] init];
    for ( NSString *name in _row.names ) {
      NSString *value = [_row stringForName:name];
      [_editedRow setObject:value forKeyIfNotNil:name];
    }
    
    NSString *bid = [_editedRow objectForKey:@"bid"];
    
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
  [_navigationView showRightButton];
  _navigationView.rightButton.normalTitle = NSLocalizedString(@"Save", @"");
  _navigationView.titleLabel.text = [_editedRow objectForKey:@"nickname"];
  
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  [_contentView addSubview:_tableView];
  
  [self addHeaderView];
  [self addFooterViewIfNeeded];
  
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


- (void)addHeaderView
{
  
  RSProfileHeaderView *header = [[RSProfileHeaderView alloc] init];
  [header.photoButton addTarget:self
                         action:@selector(photoButtonClicked:)
               forControlEvents:UIControlEventTouchUpInside];
  [header sizeToFit];
  
  [header loadPhoto:[_editedRow objectForKey:@"photo"]];
  header.jidLabel.text = [_editedRow objectForKey:@"bid"];
  
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
  
  NSString *homepage = [[_editedRow objectForKey:@"homepage"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
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

- (void)rightButtonClicked:(id)sender
{
  TKPRINTMETHOD();
  //NSLog(@"%@", _editedRow);
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
  
  if ( _isOwner ) {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  int row = indexPath.row;
  if ( row == 0 ) {
    cell.titleLabel.text = NSLocalizedString(@"Nickname", @"");
    cell.valueButton.normalTitle = [_editedRow objectForKey:@"nickname"];
  } else if ( row == 1 ) {
    cell.titleLabel.text = NSLocalizedString(@"Name", @"");
    NSString *family = [_editedRow objectForKey:@"familyname"];
    NSString *given = [_editedRow objectForKey:@"givenname"];
    cell.valueButton.normalTitle = TBBuildFullName(given, family);
  } else if ( row == 2 ) {
    cell.titleLabel.text = NSLocalizedString(@"Birthday", @"");
    cell.valueButton.normalTitle = [_editedRow objectForKey:@"birthday"];
  } else if ( row == 3 ) {
    cell.titleLabel.text = NSLocalizedString(@"Homepage", @"");
    cell.valueButton.normalTitle = [_editedRow objectForKey:@"homepage"];
    cell.valueButton.enabled = YES;
    cell.valueButton.normalTitleColor = [UIColor blueColor];
    cell.valueButton.highlightedTitleColor = [UIColor darkGrayColor];
    [cell.valueButton addTarget:self
                         action:@selector(linkButtonClicked:)
               forControlEvents:UIControlEventTouchUpInside];
  } else if ( row == 4 ) {
    cell.titleLabel.text = NSLocalizedString(@"Description", @"");
    cell.valueButton.normalTitle = [_editedRow objectForKey:@"desc"];
  }
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [RSProfileCell heightForTableView:tableView object:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ( !_isOwner ) {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    return;
  }
  
  RSEditProfileViewController *vc = [[RSEditProfileViewController alloc] init];
  
  int row = indexPath.row;
  if ( row == 0 ) {
    vc.value = [_editedRow objectForKey:@"nickname"];
    vc.maxLength = 12;
    vc.completeBlock = ^(id value) {
      [_editedRow setObject:value forKeyIfNotNil:@"nickname"];
    };
  } else if ( row == 1 ) {
    NSString *family = [_editedRow objectForKey:@"familyname"];
    NSString *given = [_editedRow objectForKey:@"givenname"];
    vc.value = TBBuildFullName(given, family);
    vc.maxLength = 30;
    vc.completeBlock = ^(id value) {
      NSArray *components = [value componentsSeparatedByString:@" "];
      NSString *fml = [components objectOrNilAtIndex:1];
      NSString *gvn = [components objectOrNilAtIndex:0];
      [_editedRow setObject:fml forKeyIfNotNil:@"familyname"];
      [_editedRow setObject:gvn forKeyIfNotNil:@"givenname"];
    };
  } else if ( row == 2 ) {
    vc.value = [_editedRow objectForKey:@"birthday"];
    vc.maxLength = 10;
    vc.completeBlock = ^(id value) {
      [_editedRow setObject:value forKeyIfNotNil:@"birthday"];
    };
  } else if ( row == 3 ) {
    vc.value = [_editedRow objectForKey:@"homepage"];
    vc.maxLength = 100;
    vc.completeBlock = ^(id value) {
      [_editedRow setObject:value forKeyIfNotNil:@"homepage"];
    };
  } else if ( row == 4 ) {
    vc.value = [_editedRow objectForKey:@"desc"];
    vc.maxLength = 30;
    vc.completeBlock = ^(id value) {
      [_editedRow setObject:value forKeyIfNotNil:@"desc"];
    };
  }
  
  [self.navigationController pushViewController:vc animated:YES];
}


@end
