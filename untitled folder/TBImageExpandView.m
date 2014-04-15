//
//  TBImageExpandView.m
//  Teemo
//
//  Created by Wu Kevin on 4/2/14.
//  Copyright (c) 2014 Telligenty. All rights reserved.
//

#import "TBImageExpandView.h"
#import "TBActionSheet.h"
#import "MBProgressHUD/MBProgressHUDExtentions.h"
#import "SDWebImage/UIImageView+WebCache.h"


@implementation TBImageExpandView

- (id)initWithItem:(NSDictionary *)item
{
  self = [super init];
  if (self) {
    
    self.backgroundColor = [UIColor blackColor];
    self.clipsToBounds = YES;
    
    
    _item = item;
    
    _startLoadingAfterPresented = YES;
    
    
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.clipsToBounds = YES;
    _imageView.userInteractionEnabled = NO;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
    
    
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    _longPressGestureRecognizer.cancelsTouchesInView = NO;
    [self addGestureRecognizer:_longPressGestureRecognizer];
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    _tapGestureRecognizer.cancelsTouchesInView = NO;
    [self addGestureRecognizer:_tapGestureRecognizer];
    
    
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  TKPRINTMETHOD();
  _imageView.frame = self.bounds;
  
}

- (void)dealloc
{
  if ( [_item objectForKey:@"image"] == nil ) {
    NSString *imageURL = [_item objectForKey:@"imageURL"];
    if ( [imageURL length] > 0 ) {
      SDWebImageManager *manager = [SDWebImageManager sharedManager];
      [manager.imageCache removeImageForKey:imageURL fromDisk:NO];
    }
  }
}


- (void)longPress:(UIGestureRecognizer *)gestureRecognizer
{
  if ( _imageView.image ) {
    if ( _actionSheet == nil ) {
      __weak typeof(self) weakSelf = self;
      _actionSheet = [[TBActionSheet alloc] initWithTitle:@""];
      [_actionSheet addButtonWithTitle:NSLocalizedString(@"保存到相册", @"") block:^{ [weakSelf saveImageToAlbum]; }];
      [_actionSheet addCancelButtonWithTitle:NSLocalizedString(@"取消", @"") block:NULL];
    }
    [_actionSheet showInView:self];
  }
}

- (void)tap:(UIGestureRecognizer *)gestureRecognizer
{
  [UIView animateWithDuration:0.25
                   animations:^{
                     self.alpha = 0.0;
                   }
                   completion:^(BOOL finished) {
                     [self removeFromSuperview];
                   }];
}

- (void)saveImageToAlbum
{
  [MBProgressHUD showHUD:self info:NSLocalizedString(@"保存中\u2026", @"")];
  
  UIImage *image = _imageView.image;
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
  });
  
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
  if ( error != nil ) {
    [MBProgressHUD showAndHideHUD:self
                             info:NSLocalizedString(@"保存失败", @"")
                 createIfNonexist:YES
                  completionBlock:NULL];
  } else {
    [MBProgressHUD showAndHideHUD:self
                             info:NSLocalizedString(@"保存成功", @"")
                 createIfNonexist:YES
                  completionBlock:NULL];
  }
}

- (void)showActivityIndicatorView
{
  if ( _activityIndicatorView == nil ) {
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.hidesWhenStopped = NO;
    [_activityIndicatorView startAnimating];
  }
  
  if ( _activityIndicatorView.superview != self ) {
    [_activityIndicatorView removeFromSuperview];
    [self addSubview:_activityIndicatorView];
  }
  
  [_activityIndicatorView moveToCenterOfSuperview];
  
}

- (void)hideActivityIndicatorView
{
  [_activityIndicatorView removeFromSuperview];
}



- (void)presentInView:(UIView *)inView fromView:(UIView *)fromView
{
  CGRect from = [inView convertRect:fromView.bounds fromView:fromView];
  [inView addSubview:self];
  self.frame = from;
  
  [UIView animateWithDuration:0.25
                   animations:^{
                     self.frame = inView.bounds;
                   }
                   completion:^(BOOL finished) {
                     if ( _startLoadingAfterPresented ) {
                       [self startLoading];
                     }
                   }];
  
//  CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
//  positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointZero];
//  positionAnimation.duration = 5.0;
//  positionAnimation.autoreverses = NO;
//  
//  CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
//  boundsAnimation.toValue = [NSValue valueWithCGRect:inView.bounds];
//  boundsAnimation.duration = 5.0;
//  boundsAnimation.autoreverses = NO;
//  
//  CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
//  animationGroup.animations = @[ positionAnimation, boundsAnimation ];
//  animationGroup.autoreverses = NO;
//  [self.layer addAnimation:animationGroup forKey:@"frame"];
  
//  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"frame"];
//  //animation.fromValue = fromValue;
//  animation.toValue = toValue;
//  animation.autoreverses = NO;
//  animation.fillMode = kCAFillModeForwards;
//  animation.duration = 5.0;
//  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//  [self.layer addAnimation:animation forKey:nil];
  
//  CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//  pulseAnimation.duration = .5;
//  pulseAnimation.toValue = [NSNumber numberWithFloat:1.1];
//  pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//  pulseAnimation.autoreverses = YES;
//  pulseAnimation.repeatCount = FLT_MAX;
//  
//  [self.layer addAnimation:pulseAnimation forKey:nil];
  
}

- (void)startLoading
{
  [_imageView cancelCurrentImageLoad];
  _imageView.image = nil;
  
  if ( [_item count] <= 0 ) {
    return;
  }
  
  UIImage *image = [_item objectForKey:@"image"];
  if ( image ) {
    _imageView.image = image;
  } else {
    NSString *imageURL = [_item objectForKey:@"imageURL"];
    UIImage *placeholderImage = [_item objectForKey:@"placeholderImage"];
    UIImage *errorImage = [_item objectForKey:@"errorImage"];
    if ( [imageURL length] > 0 ) {
      [self showActivityIndicatorView];
      __weak typeof(self) weakSelf = self;
      __weak UIImageView *imageView = _imageView;
      [_imageView setImageWithURL:[NSURL URLWithString:imageURL]
                 placeholderImage:placeholderImage
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                          if ( error ) {
                            if ( errorImage ) {
                              imageView.image = errorImage;
                            } else {
                              imageView.image = placeholderImage;
                            }
                          }
                          [weakSelf hideActivityIndicatorView];
                        }];
    } else {
      if ( errorImage ) {
        _imageView.image = errorImage;
      } else {
        _imageView.image = placeholderImage;
      }
    }
  }
}

@end
