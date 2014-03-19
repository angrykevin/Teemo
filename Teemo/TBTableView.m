//
//  TBTableView.m
//  TapKitDemo
//
//  Created by Wu Kevin on 3/19/14.
//  Copyright (c) 2014 Telligenty. All rights reserved.
//

#import "TBTableView.h"

@implementation TBTableView

- (id)init
{
  self = [super initWithFrame:CGRectZero style:UITableViewStylePlain];
  if (self) {
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  [_refreshControl sizeToFit];
  
  CGFloat maxY = 0.0 - _refreshControl.height;
  CGFloat offsetY = self.contentOffset.y;
  
  // At top
  _refreshControl.frame = CGRectMake(0.0, MIN( offsetY, maxY ), self.width, _refreshControl.height);
  
  // At middle
//  if ( offsetY<maxY ) {
//    _refreshControl.frame = CGRectMake(0.0, (offsetY+maxY)/2.0, self.width, _refreshControl.height);
//  } else {
//    _refreshControl.frame = CGRectMake(0.0, maxY, self.width, _refreshControl.height);
//  }
  
}


- (void)setShowsRefreshControl:(BOOL)showsRefreshControl
{
  _showsRefreshControl = showsRefreshControl;
  if ( _showsRefreshControl ) {
    if ( _refreshControl==nil ) {
      _refreshControl = [[UIRefreshControl alloc] init];
    }
    if ( _refreshControl.superview!=self ) {
      [_refreshControl removeFromSuperview];
      [self addSubview:_refreshControl];
    }
    [_refreshControl sendToBack];
    UITableViewController *tvc = [[UITableViewController alloc] init];
    tvc.tableView = self;
    tvc.refreshControl = _refreshControl;
  } else {
    [_refreshControl removeFromSuperview];
    _refreshControl = nil;
  }
}

- (void)startRefreshing:(BOOL)animated
{
  [_refreshControl beginRefreshing];
  [self setContentOffset:CGPointMake(0.0, 0.0-_refreshControl.height) animated:animated];
}

@end
