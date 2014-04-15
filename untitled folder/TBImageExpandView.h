//
//  TBImageExpandView.h
//  Teemo
//
//  Created by Wu Kevin on 4/2/14.
//  Copyright (c) 2014 Telligenty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBActionSheet.h"

@interface TBImageExpandView : UIView {
  NSDictionary *_item;
  BOOL _startLoadingAfterPresented;
  
  UIImageView *_imageView;
  UIActivityIndicatorView *_activityIndicatorView;
  TBActionSheet *_actionSheet;
  
  UILongPressGestureRecognizer *_longPressGestureRecognizer;
  UITapGestureRecognizer *_tapGestureRecognizer;
}

/*
 {
   @"image": UIImage
   @"imageURL": NSString
   @"placeholderImage": UIImage
   @"errorImage": UIImage
 }
 */
@property (nonatomic, strong, readonly) NSDictionary *item;

@property (nonatomic, assign) BOOL startLoadingAfterPresented;

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong, readonly) TBActionSheet *actionSheet;


- (id)initWithItem:(NSDictionary *)item;

- (void)presentInView:(UIView *)inView fromView:(UIView *)fromView;
- (void)startLoading;

@end
