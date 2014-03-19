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
  _refreshControl.frame = CGRectMake(0.0,
                                     MIN( self.contentOffset.y, 0.0-_refreshControl.height ),
                                     self.width,
                                     _refreshControl.height);
  
}

//- (void)setContentOffset:(CGPoint)contentOffset
//{
//  if ( [self isDragging] ) {
//    if ( abs(contentOffset.y - self.contentOffset.y)>20 ) {
//      return;
//    }
//  }
//  [super setContentOffset:contentOffset];
//}
//
//- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
//{
//  if ( [self isDragging] ) {
//    if ( abs(contentOffset.y - self.contentOffset.y)>20 ) {
//      return;
//    }
//  }
//  [super setContentOffset:contentOffset animated:animated];
//}

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
