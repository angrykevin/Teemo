//
//  RSBuddyCell.h
//  Teemo
//
//  Created by Wu Kevin on 11/14/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSCommon.h"


@interface RSBuddyCell : UITableViewCell {
  TBButton *_photoButton;
  UIImageView *_statusImageView;
  UILabel *_nicknameLabel;
  UILabel *_descLabel;
}

@property (nonatomic, strong, readonly) TBButton *photoButton;
@property (nonatomic, strong, readonly) UIImageView *statusImageView;
@property (nonatomic, strong, readonly) UILabel *nicknameLabel;
@property (nonatomic, strong, readonly) UILabel *descLabel;

- (void)loadPhoto:(NSString *)photo placeholderImage:(UIImage *)placeholderImage block:(RSImageProcessBlock)block;

@end
