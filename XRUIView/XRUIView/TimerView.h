//
//  TimeView.h
//  XinRanApp
//
//  Created by tianbo on 15-1-5.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimerViewDelegate <NSObject>

-(void)timerViewFinished;

@end

@interface TimerView : UIView
{
    
}
@property(nonatomic, assign) id delegate;

-(void)setTotalSeconds:(NSInteger)totalSeconds;
-(void)start;
-(void)stop;

-(void)setFontSize:(int)size;
@end
