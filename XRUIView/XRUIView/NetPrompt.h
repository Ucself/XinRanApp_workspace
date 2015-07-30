//
//  NetPrompt.h
//  XinRanApp
//
//  Created by tianbo on 15-3-12.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "BaseUIView.h"

@protocol NetPromptDelegate <NSObject>

-(void)requestNetReloadClick;

@end

@interface NetPrompt : NSObject

//顶部网络提示
@property (nonatomic) UIView *topUIView;
//中部请求提示
@property (nonatomic) UIView *middleUIView;

@property (nonatomic,assign) BOOL isShowTopUIView;
@property (nonatomic,assign) BOOL isShowMiddleUIView;

@property (nonatomic,assign) int top;

//协议
@property (nonatomic, assign) id<NetPromptDelegate> delegate;


- (instancetype)initWithView:(UIView *)uiView;


- (instancetype)initWithView:(UIView *)uiView
               showTopUIView:(BOOL)showTopUIView
            showMiddleUIView:(BOOL)showMiddleUIView;
@end
