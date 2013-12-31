//
//  RSAddBuddyViewController.h
//  Teemo
//
//  Created by Wu Kevin on 11/18/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSBoxViewLine.h"

@interface RSAddBuddyViewController : TBViewController<
    UITextFieldDelegate
> {
  UIScrollView *_scrollView;
  
  RSBoxViewLine *_jidLine;
  RSBoxViewLine *_displayednameLine;
  RSBoxViewLine *_messageLine;
  
}

@end
