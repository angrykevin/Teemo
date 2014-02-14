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
    
    _photoButton = [[TBButton alloc] init];
    _photoButton.layer.cornerRadius = 2.0;
    _photoButton.clipsToBounds = YES;
    [self.contentView addSubview:_photoButton];
    
    _statusImageView = [[UIImageView alloc] init];
    _statusImageView.backgroundColor = [UIColor clearColor];
    _statusImageView.contentMode = UIViewContentModeBottomRight;
    [_photoButton addSubview:_statusImageView];
    
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
  
  _photoButton.frame = CGRectMake(10.0, 5.0, self.contentView.height - 5.0 * 2, self.contentView.height - 5.0 * 2);
  _statusImageView.frame = _photoButton.bounds;
  
  _nicknameLabel.frame = CGRectMake(_photoButton.rightX + 5.0, _photoButton.topY,
                                    (self.contentView.width-10.0) - (_photoButton.rightX+5.0),
                                    _nicknameLabel.font.lineHeight);
  
  CGSize size = [_descLabel.text sizeWithFont:_descLabel.font
                            constrainedToSize:CGSizeMake(_nicknameLabel.width, 10000)
                                lineBreakMode:_descLabel.lineBreakMode];
  _descLabel.frame = CGRectMake(_nicknameLabel.leftX, _nicknameLabel.bottomY,
                                _nicknameLabel.width, MIN( (_descLabel.font.lineHeight*2), (size.height) ));
  
}

- (void)prepareForReuse
{
  [super prepareForReuse];
  
  [_photoButton cancelCurrentImageLoad];
  [_photoButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
  _photoButton.normalImage = nil;
  _photoButton.info = nil;
  
  _statusImageView.image = nil;
  
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


- (void)loadPhoto:(NSString *)photo placeholderImage:(UIImage *)placeholderImage
{
  [_photoButton cancelCurrentImageLoad];
  
  if ( [photo length] > 0 ) {
    [_photoButton setImageWithURL:[NSURL URLWithString:photo]
                         forState:UIControlStateNormal
                 placeholderImage:placeholderImage];
  } else {
    _photoButton.normalImage = placeholderImage;
  }
}

@end
