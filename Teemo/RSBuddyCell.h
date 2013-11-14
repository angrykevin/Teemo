//
//  RSBuddyCell.h
//  Teemo
//
//  Created by Wu Kevin on 11/14/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSBuddyCell : UITableViewCell {
  UIButton *_photoButton;
  UILabel *_nicknameLabel;
  UILabel *_descLabel;
}

@property (nonatomic, strong, readonly) UIButton *photoButton;
@property (nonatomic, strong, readonly) UILabel *nicknameLabel;
@property (nonatomic, strong, readonly) UILabel *descLabel;

- (void)loadPhoto:(NSString *)photo;

@end
