//
//  ScrollingNavViewController.h
//  XinRanApp
//
//  Created by tianbo on 15-3-18.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//
//  导航栏跟随滑动隐藏ViewController

#import "BaseUIViewController.h"

@interface ScrollingNavViewController : BaseUIViewController

-(void)viewDidAppear:(BOOL)animated;

-(void)viewWillDisappear:(BOOL)animated;

//注册滑动的scrollView
-(void)followRollingScrollView:(UIScrollView *)scrollView;

//外部使用显示导航栏
-(void)showNaigationBar:(BOOL)show;

@end
