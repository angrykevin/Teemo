//
//  TBTableView.h
//  TapKitDemo
//
//  Created by Wu Kevin on 3/19/14.
//  Copyright (c) 2014 Telligenty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBTableView : UITableView {
  UIRefreshControl *_refreshControl;
  BOOL _showsRefreshControl;
}

@property (nonatomic, strong, readonly) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL showsRefreshControl;

- (void)startRefreshing:(BOOL)animated;

@end
