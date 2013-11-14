//
//  RSBuddyCell.m
//  Teemo
//
//  Created by Wu Kevin on 11/14/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "RSBuddyCell.h"
#import <SDWebImage/UIButton+WebCache.h>

@implementation RSBuddyCell

- (id)init
{
  self = [super init];
  if (self) {
    
    _photoButton = [[UIButton alloc] init];
    [self.contentView addSubview:_photoButton];
    
    _nicknameLabel = [UILabel labelWithFont:[UIFont boldSystemFontOfSize:14.0]
                                  textColor:[UIColor blackColor]
                            backgroundColor:[UIColor clearColor]
                              textAlignment:NSTextAlignmentLeft
                              lineBreakMode:NSLineBreakByTruncatingTail
                  adjustsFontSizeToFitWidth:NO
                              numberOfLines:1];
    [self.contentView addSubview:_nicknameLabel];
    
    _descLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12.0]
                              textColor:[UIColor darkGrayColor]
                        backgroundColor:[UIColor clearColor]
                          textAlignment:NSTextAlignmentLeft
                          lineBreakMode:NSLineBreakByWordWrapping
              adjustsFontSizeToFitWidth:NO
                          numberOfLines:0];
    [self.contentView addSubview:_descLabel];
    
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  _photoButton.frame = CGRectMake(10.0, 5.0, self.contentView.height - 5.0 * 2, self.contentView.height - 2.0 * 2);
  
  _nicknameLabel.frame = CGRectMake(_photoButton.rightX + 5.0, 2.0,
                                    (self.contentView.width-10.0) - (_photoButton.rightX+5.0),
                                    _nicknameLabel.font.lineHeight);
  _descLabel.frame = CGRectMake(_nicknameLabel.leftX, _nicknameLabel.bottomY,
                                _nicknameLabel.width, _descLabel.font.lineHeight * 2);
  
}

- (void)prepareForReuse
{
  [super prepareForReuse];
  
  [_photoButton cancelCurrentImageLoad];
  _photoButton.normalImage = nil;
  
  _nicknameLabel.text = nil;
  
  _descLabel.text = nil;
  
}

- (void)dealloc
{
  [_photoButton cancelCurrentImageLoad];
}

+ (CGFloat)heightForTableView:(UITableView *)tableView object:(id)object
{
  CGFloat height = 5.0;
  height += 18.0;
  height += (15.0*2);
  height += 5.0;
  return height;
}


- (void)loadPhoto:(NSString *)photo
{
  [_photoButton cancelCurrentImageLoad];
  
  if ( [photo length] > 0 ) {
    [_photoButton setImageWithURL:[NSURL URLWithString:photo]
                         forState:UIControlStateNormal];
  } else {
    _photoButton.normalImage = nil;
  }
}

@end
