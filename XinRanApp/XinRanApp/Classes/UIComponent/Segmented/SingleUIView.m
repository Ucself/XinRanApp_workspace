//
//  SingleUIView.m
//  XibTableViewTest
//
//  Created by libj on 15/1/13.
//  Copyright (c) 2015年 libj. All rights reserved.
//

#import "SingleUIView.h"

@implementation SingleUIView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//-(void) layoutSubviews{
//    
//    if(segmentSystemVersion >= 8.0){
//        //调用父布局
//        [super layoutSubviews];
//        //加载界面
//        [self initInterface];
//    }
//    else{
//        //加载界面
//        [self initInterface];
//        //调用父布局
//        [super layoutSubviews];
//        
//    }
//    
//}
#pragma mark --- customeths

-(void) initInterface {
    //当前排序状态
    self.isUp = NO;
    self.sortImageView.image = self.isUp ?[UIImage imageNamed:@"Upward.png"] :[UIImage imageNamed:@"Down.png"];
    [self.titleUIButton addTarget:self action:@selector(titleUIButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
}
//名称的点击事件
-(void) titleUIButtonTouchUpInside:(id)sender{
    
    //图标方向切换
    self.isUp = !self.isUp;
    //更换图片
    self.sortImageView.image = self.isUp ?[UIImage imageNamed:@"Upward.png"] :[UIImage imageNamed:@"Down.png"];
    //执行代理
    if([self.delegate respondsToSelector:@selector(singleUIView:isUp:)]){
        [self.delegate singleUIView:self isUp:self.isUp];
    }
    
}

@end
