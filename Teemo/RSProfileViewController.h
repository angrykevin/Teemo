//
//  RSProfileViewController.h
//  Teemo
//
//  Created by Wu Kevin on 11/15/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSProfileViewController : TBViewController<
    UITableViewDataSource,
    UITableViewDelegate
> {
  UITableView *_tableView;
  TKDatabaseRow *_row;
}

- (id)initWithRow:(TKDatabaseRow *)row;

@end
