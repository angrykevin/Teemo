//
//  RSViewController.h
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSNavigationView;


@interface RSViewController : UIViewController {
  RSNavigationView *_navigationView;
  UIView *_contentView;
  
  BOOL _viewAppeared;
  NSUInteger _appearedTimes;
}

- (void)layoutViews;

- (void)leftButtonClicked:(id)sender;
- (void)rightButtonClicked:(id)sender;

@end


@interface RSNavigationView : UIView {
  UIButton *_leftButton;
  UILabel *_titleLabel;
  UIButton *_rightButton;
}

@property (nonatomic, strong, readonly) UIButton *leftButton;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIButton *rightButton;

@end
