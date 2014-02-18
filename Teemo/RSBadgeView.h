//
//  RSBadgeView.h
//  Teemo
//
//  Created by Wu Kevin on 2/17/14.
//  Copyright (c) 2014 xbcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSBadgeView : UIImageView {
  UILabel *_textLabel;
  UIEdgeInsets _edgeInsets;
}

@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@end
