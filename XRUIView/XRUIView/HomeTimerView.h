//
//  HomeTimerView.h
//  XRUIView
//
//  Created by libj on 15/4/6.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeTimerViewDelegate <NSObject>

-(void)timerViewFinished;

@end

@interface HomeTimerView : UIView
{
    
}
@property(nonatomic, assign) id delegate;

-(void)setTotalSeconds:(NSInteger)totalSeconds;
-(void)start;
-(void)stop;

-(void)setFontSize:(int)size;

@end
