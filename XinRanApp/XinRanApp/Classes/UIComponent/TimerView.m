//
//  TimeView.m
//  XinRanApp
//
//  Created by tianbo on 15-1-5.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "TimerView.h"
#import <CoreText/CTStringAttributes.h>


@interface TimerView ()
{
    UIImage *image;
    int fontSize;
}

@property(nonatomic) NSInteger timeInterval;
@property(nonatomic) NSInteger seconds;
@property(nonatomic) NSInteger minutes;
@property(nonatomic) NSInteger hours;
@property(nonatomic, strong) NSTimer *updateTimer;
@end

@implementation TimerView


-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)awakeFromNib {
    image = [UIImage imageNamed:@"bk_timer"];
    self.backgroundColor = [UIColor clearColor];
    
    fontSize = 15;
}

-(void)dealloc
{
    [self stop];
}

-(void)start
{
    if (self.updateTimer != nil)
    {
        [self.updateTimer invalidate];
        self.updateTimer = nil;
    }
    __block TimerView *blockSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        blockSelf->_updateTimer=[NSTimer scheduledTimerWithTimeInterval:1.0
                                                                 target:blockSelf
                                                               selector:@selector(handleTimer)
                                                               userInfo:nil
                                                                repeats:YES] ;
        
        [[NSRunLoop currentRunLoop] addTimer:blockSelf->_updateTimer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
        
    });
}
-(void)stop
{
    if (self.updateTimer != nil)
    {
        [self.updateTimer invalidate];
        self.updateTimer = nil;
    }
}

-(void)setFontSize:(int)size
{
    fontSize = size;
}

-(void)setTotalSeconds:(NSInteger)totalSeconds
{
    self.timeInterval = totalSeconds;
    [self updateTime];

}


- (void) handleTimer
{
    if (self.timeInterval < 0 || self.hours >= 72) {
        [self.updateTimer invalidate];
        return;
    }
    
    [self updateTime];
}

-(void)updateTime
{
    self.timeInterval--;
    self.hours = self.timeInterval/3600;
    self.minutes = self.timeInterval%3600/60;
    self.seconds = self.timeInterval%3600%60;
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGRect bounds = [self bounds];
    
    if (self.hours >= 72) {
        //NSString *text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)self.hours, self.minutes, self.seconds];
        NSString *text = @"三天以上";
        
        CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        int y = (bounds.size.height-size.height) / 2.0;
        
        CGRect rt;
        rt.origin.x = 0;
        rt.origin.y = y;
        rt.size = size;
        [text drawInRect:rt withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                             NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    //[[UIColor redColor] setStroke];
    //显示时间
    NSString *hour = [NSString stringWithFormat:@"%02ld", (long)self.hours];
    NSString *hourFirst = [hour substringToIndex:1];
    
    CGSize size = [hourFirst sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}];
    int y = (bounds.size.height-size.height) / 2.0;
    CGRect textRect;
    textRect.origin.x = 0;
    textRect.origin.y = y;
    textRect.size = size;
    
    textRect = CGRectOffset(textRect, 3, 0);
    [image drawInRect:CGRectInset(textRect, -3, 0)];
    [hourFirst drawInRect:textRect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                                    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    textRect = CGRectOffset(textRect, 15, 0);
    NSString *hourSecond = [hour substringFromIndex:1];
    [image drawInRect:CGRectInset(textRect, -3, 0)];
    [hourSecond drawInRect:textRect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                                     NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSString *timeText = @"时";
    CGRect rt = CGRectOffset(textRect, fontSize+2, 0);
    rt.size.width = 20;
    [timeText drawInRect:rt withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                                     NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    
    //分
    textRect = CGRectOffset(textRect, fontSize*3-5, 0);
    NSString *minute = [NSString stringWithFormat:@"%02ld", (long)self.minutes];
    NSString *minuteFirst = [minute substringToIndex:1];
    [image drawInRect:CGRectInset(textRect, -3, 0)];
    [minuteFirst drawInRect:textRect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    textRect = CGRectOffset(textRect, 15, 0);
    NSString *minuteSecond = [minute substringFromIndex:1];
    [image drawInRect:CGRectInset(textRect, -3, 0)];
    [minuteSecond drawInRect:textRect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                                       NSForegroundColorAttributeName:[UIColor whiteColor]}];

    timeText = @"分";
    rt = CGRectOffset(textRect, fontSize+2, 0);
    rt.size.width = 20;
    [timeText drawInRect:rt withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                             NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    
    //秒
    textRect = CGRectOffset(textRect, fontSize*3-5, 0);
    NSString *second = [NSString stringWithFormat:@"%02ld", (long)self.seconds];
    NSString *secondFirst = [second substringToIndex:1];
    [image drawInRect:CGRectInset(textRect, -3, 0)];
    [secondFirst drawInRect:textRect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    textRect = CGRectOffset(textRect, 15, 0);
    NSString *secondSecond = [second substringFromIndex:1];
    [image drawInRect:CGRectInset(textRect, -3, 0)];
    [secondSecond drawInRect:textRect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                                       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    timeText = @"秒";
    rt = CGRectOffset(textRect, 17, 0);
    rt.size.width = 20;
    [timeText drawInRect:rt withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                             NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    

//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGRect bounds = [self bounds];
//    CGPoint center;
//    center.x = bounds.origin.x + bounds.size.width / 2.0;
//    center.y = bounds.origin.y + bounds.size.height / 2.0;
//    
//    
//    
//    CGRect textRect;
//    textRect.origin.x = 0;
//    textRect.origin.y = 0;
//    textRect.size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
//    
//    [[UIColor redColor] setFill];
//    [text drawInRect:textRect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
}

@end
