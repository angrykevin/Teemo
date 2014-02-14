//
//  RSProfileViewController.mm
//  Teemo
//
//  Created by Wu Kevin on 11/15/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSProfileViewController.h"

#import "Teemo.h"

#import "RSProfileAccessoryView.h"
#import "RSProfileCell.h"

@implementation RSProfileViewController


- (id)initWithRow:(TKDatabaseRow *)row
{
  self = [super init];
  if (self) {
    
    NSAssert((row != nil), @"row error");
    
    _row = row;
    
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
  
  [header loadPhoto:[_row stringForName:@"photo"]];
  header.jidLabel.text = [_row stringForName:@"bid"];
  
  _tableView.tableHeaderView = header;
  _tableView.tableHeaderView.frame = CGRectMake(0.0, 0.0, header.width, header.height);
}

- (void)addFooterViewIfNeeded
{
  TMEngine *engine = [TMEngine sharedEngine];
  
  if ( [TMJIDFromPassport(engine.passport) isEqualToString:[_row stringForName:@"bid"]] ) {
    
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
    
    TBAlertView *alertView = [[TBAlertView alloc] initWithMessage:NSLocalizedString(@"Open the link?", @"")];
    
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
  
  TMEngine *engine = [TMEngine sharedEngine];
  
  NSString *jid = [_row stringForName:@"bid"];
  
  [engine rosterManager]->remove(JID( CPPSTR(jid) ));
  
  [self.navigationController popViewControllerAnimated:YES];
  
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
  
  int row = indexPath.row;
  
  if ( row == 0 ) {
    
    cell.titleLabel.text = NSLocalizedString(@"Nickname", @"");
    cell.valueButton.normalTitle = [_row stringForName:@"nickname"];
    
  } else if ( row == 1 ) {
    
    cell.titleLabel.text = NSLocalizedString(@"Name", @"");
    NSString *family = [_row stringForName:@"familyname"];
    NSString *given = [_row stringForName:@"givenname"];
    cell.valueButton.normalTitle = TBBuildFullname(given, family);
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
