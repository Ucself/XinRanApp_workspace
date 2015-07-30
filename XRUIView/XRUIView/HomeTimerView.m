//
//  HomeTimerView.m
//  XRUIView
//
//  Created by libj on 15/4/6.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "HomeTimerView.h"
#import <CoreText/CTStringAttributes.h>
#import <XRCommon/Common.h>
#import "UIImage+bundle.h"
@interface HomeTimerView ()
{
    UIImage *image;
//    UIView *image;
    int fontSize;
}

@property(nonatomic) NSInteger timeInterval;
@property(nonatomic) NSInteger seconds;
@property(nonatomic) NSInteger minutes;
@property(nonatomic) NSInteger hours;
@property(nonatomic) NSInteger days;
@property(nonatomic, strong) NSTimer *updateTimer;
@end


@implementation HomeTimerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.timeInterval = 1;
    }
    
    return self;
}

- (void)awakeFromNib {
//    image = [UIImage imagesNamedFromBundle:@"bk_timer"];
    image = [self setBackgroundImageByColor:UIColorFromRGB(0xfa2b0a) withFrame:CGRectMake(0, 0, 22, 28)];
    
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
    __block HomeTimerView *blockSelf = self;
    
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
    if (self.timeInterval <= 1)
        return;
    
    [self updateTime];
    
}


- (void) handleTimer
{
    if (self.timeInterval <= 1) {
        [self.updateTimer invalidate];
        self.updateTimer = nil;
        
        self.days = 0;
        self.hours = 0;
        self.minutes = 0;
        self.seconds = 0;
        
        [self.delegate timerViewFinished];
        self.timeInterval = 1;
        [self setNeedsDisplay];
        //[self updateTime];
        
        return;
    }
    
    [self updateTime];
}

-(void)updateTime
{
    self.timeInterval--;
    
    NSTimeInterval temp = 0;
    self.days = self.timeInterval/(3600*24);
    
    temp = self.timeInterval%(3600*24);
    if (temp != 0) {
        self.hours = temp/3600;
    }
    
    temp = self.timeInterval%3600;
    if (temp != 0) {
        self.minutes = temp/60;
    }
    
    temp = self.timeInterval%3600%60;
    self.seconds = temp;
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGRect bounds = [self bounds];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.0);
    //[[UIColor redColor] setStroke];
    //显示时间
    NSString *day = [NSString stringWithFormat:@"%02ld", (long)self.days];
    NSString *dayFirst = [day substringToIndex:1];
    CGSize size = [dayFirst sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}];
    int y = (bounds.size.height-size.height) / 2.0;
    CGRect textRect;
    textRect.origin.x = 0;
    textRect.origin.y = y;
    textRect.size = size;
    
    CGRect imageRect;
    imageRect.origin.x = 0;
    imageRect.origin.y = y;
    imageRect.size = CGSizeMake(size.width*2.5, size.height);
    //天
    textRect = CGRectOffset(textRect, 3, 0);
    [image drawInRect:CGRectInset(imageRect,1, 0)];
    [dayFirst drawInRect:textRect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                                    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    textRect = CGRectOffset(textRect, 7, 0);
    NSString *daySecond = [day substringFromIndex:1];
    [daySecond drawInRect:textRect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                                     NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSString *timeText = @"天";
    CGRect rt = CGRectOffset(textRect, fontSize-3, 0);
    rt.size.width = 20;
    [timeText drawInRect:rt withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                             NSForegroundColorAttributeName:[UIColor redColor]}];
    
    //时
    textRect.origin.x = rt.origin.x + rt.size.width - 2;
    NSString *hour = [NSString stringWithFormat:@"%02ld", (long)self.hours];
    NSString *hourFirst = [hour substringToIndex:1];
    imageRect.origin.x = textRect.origin.x-3;
    [image drawInRect:CGRectInset(imageRect, 1, 0)];
    [hourFirst drawInRect:textRect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                                    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    textRect = CGRectOffset(textRect, 7, 0);
    NSString *hourSecond = [hour substringFromIndex:1];
    [hourSecond drawInRect:textRect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                                     NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    timeText = @"时";
    rt = CGRectOffset(textRect, fontSize-2, 0);
    rt.size.width = 20;
    [timeText drawInRect:rt withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                             NSForegroundColorAttributeName:[UIColor redColor]}];
    
    //分
    textRect.origin.x = rt.origin.x + rt.size.width - 3;
    NSString *minute = [NSString stringWithFormat:@"%02ld", (long)self.minutes];
    NSString *minuteFirst = [minute substringToIndex:1];
    imageRect.origin.x = textRect.origin.x-3;
    [image drawInRect:CGRectInset(imageRect, 1, 0)];
    [minuteFirst drawInRect:textRect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];

    textRect = CGRectOffset(textRect, 7, 0);
    NSString *minuteSecond = [minute substringFromIndex:1];
    [minuteSecond drawInRect:textRect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                                       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    timeText = @"分";
    rt = CGRectOffset(textRect, fontSize-2, 0);
    rt.size.width = 20;
    [timeText drawInRect:rt withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                             NSForegroundColorAttributeName:[UIColor redColor]}];
    
    //秒
    if (self.seconds <= 0) {
        self.seconds = 0;
    }
    textRect.origin.x = rt.origin.x + rt.size.width - 2;
    NSString *second = [NSString stringWithFormat:@"%02ld", (long)self.seconds];
    NSString *secondFirst = [second substringToIndex:1];
    imageRect.origin.x = textRect.origin.x-3;
    [image drawInRect:CGRectInset(imageRect, 1, 0)];
    [secondFirst drawInRect:textRect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];

    textRect = CGRectOffset(textRect, 7, 0);
    NSString *secondSecond = [second substringFromIndex:1];
    [secondSecond drawInRect:textRect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                                       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    timeText = @"秒";
    rt = CGRectOffset(textRect, fontSize-3, 0);
    rt.size.width = 20;
    [timeText drawInRect:rt withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                             NSForegroundColorAttributeName:[UIColor redColor]}];
}

#pragma mark ----

- (UIImage* )setBackgroundImageByColor:(UIColor *)backgroundColor withFrame:(CGRect )rect{
    
    // tcv - temporary colored view
    UIView *tcv = [[UIView alloc] initWithFrame:rect];
    [tcv setBackgroundColor:backgroundColor];
    tcv.layer.cornerRadius = 3;
    tcv.layer.masksToBounds = YES;
    
    // set up a graphics context of button's size
    CGSize gcSize = tcv.frame.size;
    UIGraphicsBeginImageContext(gcSize);
    // add tcv's layer to context
    [tcv.layer renderInContext:UIGraphicsGetCurrentContext()];
    // create background image now
    UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tempImage;
    //    [tcv release];
    
}

@end
