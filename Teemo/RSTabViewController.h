//
//  RSTabViewController.h
//  Teemo
//
//  Created by Wu Kevin on 11/8/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSTabView;


@interface RSTabViewController : UIViewController {
  NSArray *_viewControllers;
  RSTabView *_tabView;
  
  BOOL _viewAppeared;
  NSUInteger _appearedTimes;
}

- (void)layoutViews;

- (RSTabView *)tabViewWithItems:(NSArray *)items;

@end





@class RSTabViewItem;

typedef void(^RSTabViewBlock)(NSUInteger index, RSTabViewItem *item);

@interface RSTabView : UIView {
  NSArray *_items;
  
  BOOL _repeatedlyNotify;
  RSTabViewBlock _block;
  NSUInteger _selectedIndex;
}

@property (nonatomic, strong, readonly) NSArray *items;

@property (nonatomic, assign) BOOL repeatedlyNotify;
@property (nonatomic, copy) RSTabViewBlock block;
@property (nonatomic, assign, readonly) NSUInteger selectedIndex;

- (id)initWithItems:(NSArray *)items;

- (void)selectItemAtIndex:(NSUInteger)index;

@end

@interface RSTabViewItem : NSObject {
  
  UIButton *_button;
  
  NSString *_normalTitle;
  NSString *_highlightedTitle;
  
  UIColor *_normalTitleColor;
  UIColor *_highlightedTitleColor;
  
  UIImage *_normalImage;
  UIImage *_highlightedImage;
  
  UIImage *_normalBackgroundImage;
  UIImage *_highlightedBackgroundImage;
}

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, copy) NSString *normalTitle;
@property (nonatomic, copy) NSString *highlightedTitle;

@property (nonatomic, strong) UIColor *normalTitleColor;
@property (nonatomic, strong) UIColor *highlightedTitleColor;

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *highlightedImage;

@property (nonatomic, strong) UIImage *normalBackgroundImage;
@property (nonatomic, strong) UIImage *highlightedBackgroundImage;

@end
