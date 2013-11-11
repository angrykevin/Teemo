//
//  TTTabViewController.h
//  Teemo
//
//  Created by Wu Kevin on 11/8/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapKit.h"

@class TTTabView;


@interface TTTabViewController : UIViewController {
  NSArray *_viewControllers;
  TTTabView *_tabView;
  
  BOOL _viewAppeared;
  NSUInteger _appearedTimes;
}

- (void)layoutViews;

- (TTTabView *)tabViewWithItems:(NSArray *)items;

@end





@class TTTabViewItem;

typedef void(^TTTabViewBlock)(NSUInteger index, TTTabViewItem *item);

@interface TTTabView : UIView {
  NSArray *_items;
  
  BOOL _repeatedlyNotify;
  TTTabViewBlock _block;
  NSUInteger _selectedIndex;
}

@property (nonatomic, strong, readonly) NSArray *items;

@property (nonatomic, assign) BOOL repeatedlyNotify;
@property (nonatomic, copy) TTTabViewBlock block;
@property (nonatomic, assign, readonly) NSUInteger selectedIndex;

- (id)initWithItems:(NSArray *)items;

- (void)selectItemAtIndex:(NSUInteger)index;

@end

@interface TTTabViewItem : NSObject {
  
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

+ (TTTabViewItem *)itemWithNormalTitle:(NSString *)normalTitle
                      highlightedTitle:(NSString *)highlightedTitle
                      normalTitleColor:(UIColor *)normalTitleColor
                 highlightedTitleColor:(UIColor *)highlightedTitleColor
                           normalImage:(UIImage *)normalImage
                      highlightedImage:(UIImage *)highlightedImage
                 normalBackgroundImage:(UIImage *)normalBackgroundImage
            highlightedBackgroundImage:(UIImage *)highlightedBackgroundImage;

@end
