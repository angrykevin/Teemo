//
//  RSProfileHeaderView.h
//  Teemo
//
//  Created by Wu Kevin on 11/15/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSProfileHeaderView : UIView {
  UIButton *_photoButton;
  UILabel *_jidLabel;
}

@property (nonatomic, strong, readonly) UIButton *photoButton;
@property (nonatomic, strong, readonly) UILabel *jidLabel;

- (void)loadPhoto:(NSString *)photo;

@end
