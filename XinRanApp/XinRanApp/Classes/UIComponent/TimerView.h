//
//  TimeView.h
//  XinRanApp
//
//  Created by tianbo on 15-1-5.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerView : UIView


-(void)setTotalSeconds:(NSInteger)totalSeconds;
-(void)start;
-(void)stop;

-(void)setFontSize:(int)size;
@end
