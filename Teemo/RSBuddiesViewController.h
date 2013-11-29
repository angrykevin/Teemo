//
//  RSBuddiesViewController.h
//  Teemo
//
//  Created by Wu Kevin on 11/12/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSRosterModel.h"

@interface RSBuddiesViewController : TBViewController<
    UITableViewDataSource,
    UITableViewDelegate
> {
  UITableView *_tableView;
  RSRosterModel *_rosterModel;
  NSMutableDictionary *_openedMap;
}

@end
