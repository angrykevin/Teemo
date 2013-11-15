//
//  RSProfileCell.h
//  Teemo
//
//  Created by Wu Kevin on 11/15/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSProfileCell : UITableViewCell {
  UILabel *_titleLabel;
  UIButton *_valueButton;
}

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIButton *valueButton;

@end
