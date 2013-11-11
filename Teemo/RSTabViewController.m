//
//  RSTabViewController.m
//  Teemo
//
//  Created by Wu Kevin on 11/8/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSTabViewController.h"

@implementation RSTabViewController

- (id)init
{
  self = [super init];
  if (self) {
    self.wantsFullScreenLayout = YES;
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  NSAssert((_tabView != nil), @"");
  NSAssert((_viewControllers != nil), @"");
  NSAssert(([_tabView.items count] == [_viewControllers count]), @"");
  
  if ( _appearedTimes == 0 ) {
    UIViewController *vc = [_viewControllers firstObject];
    [self containerAddChildViewController:vc];
    [_tabView selectItemAtIndex:0];
  }
  
  [self layoutViews];
  
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  _viewAppeared = YES;
  _appearedTimes++;
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  _viewAppeared = NO;
}


- (void)layoutViews
{
  
  [_tabView sizeToFit];
  _tabView.frame = CGRectMake(0.0, self.view.height - _tabView.height, self.view.width, _tabView.height);
  
  UIViewController *vc = [self.childViewControllers firstObject];
  vc.view.frame = CGRectMake(0.0, 0.0, self.view.width, self.view.height - _tabView.height);
  
  
  [_tabView bringToFront];
  
}


- (RSTabView *)tabViewWithItems:(NSArray *)items
{
  RSTabView *tabView = [[RSTabView alloc] initWithItems:items];
  
  tabView.repeatedlyNotify = NO;
  
  
  
  __weak RSTabViewController *weakSelf = self;
  __weak NSArray *viewControllers = _viewControllers;
  
  tabView.block = ^(NSUInteger index, RSTabViewItem *item) {
    
    UIViewController *currentVC = [weakSelf.childViewControllers firstObject];
    UIViewController *newVC = [viewControllers objectOrNilAtIndex:index];
    
    if ( currentVC != newVC ) {
      
      [weakSelf containerAddChildViewController:newVC];
      [weakSelf containerRemoveChildViewController:currentVC];
      
    }
    
    [weakSelf layoutViews];
    
  };
  
  
  return tabView;
}

@end




@implementation RSTabView

- (id)initWithItems:(NSArray *)items
{
  self = [super init];
  if (self) {
    
    self.backgroundColor = [UIColor colorWithPatternImage:RSCreateImage(@"tabbar_bg.png")];
    
    
    _items = items;
    
    for ( int i=0; i<[_items count]; ++i ) {
      
      RSTabViewItem *item = [_items objectAtIndex:i];
      
      UIButton *button = [[UIButton alloc] init];
      item.button = button;
      
      button.tag = i;
      
      button.normalTitle = item.normalTitle;
      button.highlightedTitle = item.highlightedTitle;
      
      button.normalTitleColor = item.normalTitleColor;
      button.highlightedTitleColor = item.highlightedTitleColor;
      
      button.normalImage = item.normalImage;
      button.highlightedImage = item.highlightedImage;
      
      button.normalBackgroundImage = item.normalBackgroundImage;
      button.highlightedBackgroundImage = item.highlightedBackgroundImage;
      
      
      button.titleLabel.font = [UIFont systemFontOfSize:12.0];
      
      button.exclusiveTouch = YES;
      
      [button addTarget:self
                 action:@selector(buttonClicked:)
       forControlEvents:UIControlEventTouchUpInside];
      
      [self addSubview:button];
      
    }
    
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  CGFloat itemWidth = self.width / [_items count];
  
  for ( int i=0; i<[_items count]; ++i ) {
    
    RSTabViewItem *item = [_items objectAtIndex:i];
    UIButton *button = item.button;
    button.frame = CGRectMake(button.tag * itemWidth, 0.0, itemWidth, self.height);
    
    CGSize imageSize = button.imageView.frame.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0 - imageSize.width, 0.0 - imageSize.height - 2.0, 0.0);
    CGSize titleSize = button.titleLabel.frame.size;
    button.imageEdgeInsets = UIEdgeInsetsMake(0.0 - titleSize.height - 2.0, 0.0, 0.0, 0.0 - titleSize.width);
    
  }
  
}

- (CGSize)sizeThatFits:(CGSize)size
{
  return CGSizeMake(320.0, 50.0);
}


- (void)buttonClicked:(id)sender
{
  int tag = [(UIButton *)sender tag];
  if ( _selectedIndex == tag ) {
    if ( !_repeatedlyNotify ) {
      return;
    }
  }
  
  _selectedIndex = tag;
  [self updateTabView];
  
  if ( _block ) {
    RSTabViewItem *item = [_items objectOrNilAtIndex:tag];
    _block(tag, item);
  }
}

- (void)selectItemAtIndex:(NSUInteger)index
{
  if ( index < [_items count] ) {
    _selectedIndex = index;
    [self updateTabView];
  }
}

- (void)updateTabView
{
  
  for ( int i=0; i<[_items count]; ++i ) {
    RSTabViewItem *item = [_items objectAtIndex:i];
    UIButton *button = item.button;
    
    //button.normalTitle = item.normalTitle;
    button.highlightedTitle = item.highlightedTitle;
    
    //button.normalTitleColor = item.normalTitleColor;
    button.highlightedTitleColor = item.highlightedTitleColor;
    
    //button.normalImage = item.normalImage;
    button.highlightedImage = item.highlightedImage;
    
    //button.normalBackgroundImage = item.normalBackgroundImage;
    button.highlightedBackgroundImage = item.highlightedBackgroundImage;
    
    if ( _selectedIndex == i ) {
      
      button.normalTitle = item.highlightedTitle;
      
      button.normalTitleColor = item.highlightedTitleColor;
      
      button.normalImage = item.highlightedImage;
      
      button.normalBackgroundImage = item.highlightedBackgroundImage;
      
    } else {
      
      button.normalTitle = item.normalTitle;
      
      button.normalTitleColor = item.normalTitleColor;
      
      button.normalImage = item.normalImage;
      
      button.normalBackgroundImage = item.normalBackgroundImage;
      
    }
  }
  
}

@end


@implementation RSTabViewItem

+ (RSTabViewItem *)itemWithNormalTitle:(NSString *)normalTitle
                      highlightedTitle:(NSString *)highlightedTitle
                      normalTitleColor:(UIColor *)normalTitleColor
                 highlightedTitleColor:(UIColor *)highlightedTitleColor
                           normalImage:(UIImage *)normalImage
                      highlightedImage:(UIImage *)highlightedImage
                 normalBackgroundImage:(UIImage *)normalBackgroundImage
            highlightedBackgroundImage:(UIImage *)highlightedBackgroundImage
{
  RSTabViewItem *item = [[RSTabViewItem alloc] init];
  
  item.normalTitle = normalTitle;
  item.highlightedTitle = highlightedTitle;
  
  item.normalTitleColor = normalTitleColor;
  item.highlightedTitleColor = highlightedTitleColor;
  
  item.normalImage = normalImage;
  item.highlightedImage = highlightedImage;
  
  item.normalBackgroundImage = normalBackgroundImage;
  item.highlightedBackgroundImage = highlightedBackgroundImage;
  
  return item;
}

@end
