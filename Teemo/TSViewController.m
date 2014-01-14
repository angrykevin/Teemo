//
//  TSViewController.m
//  Teemo
//
//  Created by Wu Kevin on 1/14/14.
//  Copyright (c) 2014 xbcx. All rights reserved.
//

#import "TSViewController.h"

@implementation TSViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  static int pid = 0;
  
  UILabel *label = [UILabel labelWithFont:[UIFont systemFontOfSize:14.0]
                                textColor:[UIColor blackColor]
                          backgroundColor:[UIColor clearColor]
                            textAlignment:NSTextAlignmentCenter
                            lineBreakMode:NSLineBreakByTruncatingTail
                adjustsFontSizeToFitWidth:NO
                            numberOfLines:1];
  [_contentView addSubview:label];
  label.frame = CGRectMake(10.0, 10.0, 300.0, 30.0);
  [label showBorderWithBrownColor];
  
  pid++;
  _pid = pid;
  
  label.text = [NSString stringWithFormat:@"%d", _pid];
  
  
  UIButton *button = [[UIButton alloc] init];
  button.normalTitle = @"Push";
  button.normalTitleColor = [UIColor blackColor];
  [button addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
  [_contentView addSubview:button];
  button.frame = CGRectMake(10.0, 50.0, 300.0, 40.0);
  [button showBorderWithRedColor];
  
  button = [[UIButton alloc] init];
  button.normalTitle = @"Pop";
  button.normalTitleColor = [UIColor blackColor];
  [button addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
  [_contentView addSubview:button];
  button.frame = CGRectMake(10.0, 100.0, 300.0, 40.0);
  [button showBorderWithRedColor];
  
  button = [[UIButton alloc] init];
  button.normalTitle = @"Present";
  button.normalTitleColor = [UIColor blackColor];
  [button addTarget:self action:@selector(present:) forControlEvents:UIControlEventTouchUpInside];
  [_contentView addSubview:button];
  button.frame = CGRectMake(10.0, 150.0, 300.0, 40.0);
  [button showBorderWithRedColor];
  
  button = [[UIButton alloc] init];
  button.normalTitle = @"Dismiss";
  button.normalTitleColor = [UIColor blackColor];
  [button addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
  [_contentView addSubview:button];
  button.frame = CGRectMake(10.0, 200.0, 300.0, 40.0);
  [button showBorderWithRedColor];
  
}

- (void)push:(id)sender
{
  TSViewController *vc = [[TSViewController alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)pop:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)present:(id)sender
{
  TSViewController *vc = [[TSViewController alloc] init];
  [self presentViewController:vc animated:YES completion:NULL];
}

- (void)dismiss:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:NULL];
}



- (void)disappearForDismiss
{
  TKPRINT(@"消失：按了返回当前页面消失 %d", _pid);
}

- (void)disappearForForward
{
  TKPRINT(@"消失：被别的页面挡住了 %d", _pid);
}



- (void)appearForBack
{
  TKPRINT(@"显示：因为返回显示了 %d", _pid);
}

- (void)appearForPresent
{
  TKPRINT(@"显示：系统准备显示 %d", _pid);
}

@end
