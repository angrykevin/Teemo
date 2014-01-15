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
  UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
  nv.navigationBarHidden = YES;
  [self presentViewController:nv animated:YES completion:NULL];
}

- (void)dismiss:(id)sender
{
  [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}



- (void)disappearForDismiss
{
  TKPRINT(@"%d消失：当前页面消失，可能是Pop或Dismiss", _pid);
}

- (void)disappearForForward
{
  TKPRINT(@"%d消失：当前页面消失，显示新页面，可能是Push或Present", _pid);
}



- (void)appearForBack
{
  TKPRINT(@"%d显示：其它页面消失，当前页面显示，可能是Pop或Dismiss", _pid);
}

- (void)appearForPresent
{
  TKPRINT(@"%d显示：显示当前面页，可能是Push或Present", _pid);
}

@end
