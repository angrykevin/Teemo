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
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _navigationView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
  NSAssert((_tabView != nil), @"");
  NSAssert((_viewControllers != nil), @"");
  NSAssert(([_tabView.items count] == [_viewControllers count]), @"");
  
  if ( _appearedTimes == 0 ) {
    UIViewController *vc = [_viewControllers firstObject];
    [self containerAddChildViewController:vc];
    [_tabView selectItemAtIndex:0];
  }
  
  [super viewWillAppear:animated];
}


- (void)layoutViews
{
  [super layoutViews];
  
  [_tabView sizeToFit];
  _tabView.frame = CGRectMake(0.0, self.view.height - _tabView.height, self.view.width, _tabView.height);
  
  UIViewController *vc = [self.childViewControllers firstObject];
  vc.view.frame = CGRectMake(0.0, 0.0, self.view.width, self.view.height - _tabView.height);
  
  [_tabView bringToFront];
  
}

@end




@implementation RSTabView

- (id)initWithItems:(NSArray *)items
{
  self = [super init];
  if (self) {
    
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

@end
