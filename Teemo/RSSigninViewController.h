//
//  RSSigninViewController.h
//  Teemo
//
//  Created by Wu Kevin on 11/6/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RSSigninViewController : RSViewController {
  
  UIScrollView *_scrollView;
  
  UILabel *_titleLabel;
  RSBoxViewLine *_passportLine;
  RSBoxViewLine *_passwordLine;
  UIButton *_signinButton;
  
}

@end
