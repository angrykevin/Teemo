//
//  RSProfileCell.m
//  Teemo
//
//  Created by Wu Kevin on 11/15/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSProfileCell.h"
#import <SDWebImage/UIButton+WebCache.h>

@implementation RSProfileCell

- (id)init
{
  self = [super init];
  if (self) {
    _titleLabel = [UILabel labelWithFont:[UIFont boldSystemFontOfSize:14.0]
                               textColor:[UIColor blackColor]
                         backgroundColor:[UIColor clearColor]
                           textAlignment:NSTextAlignmentLeft
                           lineBreakMode:NSLineBreakByTruncatingTail
               adjustsFontSizeToFitWidth:NO
                           numberOfLines:1];
    [self.contentView addSubview:_titleLabel];
    
    _valueButton = [[UIButton alloc] init];
    _valueButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    _valueButton.enabled = NO;
    _valueButton.normalTitleColor = [UIColor darkGrayColor];
    _valueButton.highlightedTitleColor = [UIColor darkGrayColor];
    [self.contentView addSubview:_valueButton];
    
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  _titleLabel.frame = CGRectMake(10.0, 5.0, 80.0, self.contentView.height - 2*5.0);
  
  [_valueButton sizeToFit];
  CGFloat maxWidth = (self.contentView.width-10.0) - (_titleLabel.rightX + 5.0);
  CGFloat width = MIN( maxWidth, (_valueButton.width) );
  _valueButton.frame = CGRectMake((self.contentView.width - 10.0) - width, _titleLabel.topY,
                                  width, _titleLabel.height);
}

- (void)prepareForReuse
{
  [super prepareForReuse];
  
  _titleLabel.text = nil;
  
  _valueButton.normalTitle = nil;
  _valueButton.enabled = NO;
  _valueButton.normalTitleColor = [UIColor darkGrayColor];
  _valueButton.highlightedTitleColor = [UIColor darkGrayColor];
  [_valueButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
}

//+ (CGFloat)heightForTableView:(UITableView *)tableView object:(id)object
//{
//  return 44.0;
//}

@end
