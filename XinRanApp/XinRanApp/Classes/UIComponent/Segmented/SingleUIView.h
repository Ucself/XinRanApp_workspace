//
//  SingleUIView.h
//  XibTableViewTest
//
//  Created by libj on 15/1/13.
//  Copyright (c) 2015年 libj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIView.h"

#define segmentSystemVersion  [[[UIDevice currentDevice] systemVersion] floatValue]
@class SingleUIView;

@protocol SingleUIViewDelegate <NSObject>

@optional
//点击时候的协议
- (void)singleUIView:(SingleUIView *)singleUIView  isUp:(BOOL)isUp;

@end

@interface SingleUIView : BaseUIView

@property (weak, nonatomic) IBOutlet UILabel *titleUITitle;

@property (weak, nonatomic) IBOutlet UIButton *titleUIButton;

@property (weak, nonatomic) IBOutlet UIImageView *sortImageView;

@property (assign, nonatomic) BOOL isUp;   //是否是向上

@property (assign, nonatomic) id <SingleUIViewDelegate> delegate;

@property (assign,nonatomic) int index;

-(void) initInterface;
@end
