//
//  GetDynaPwdButton.m
//  ELive
//
//  Created by apple on 12-11-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DynaButton.h"

@interface DynaButton ()
{
    double seconds;
    int fSeconds;
}

@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) UIImageView *bkImageView;
@property(nonatomic, strong) NSTimer *timer;
@end

@implementation DynaButton


//返回单例对象用于只请求不要返回数据
+ (NSMutableDictionary *)dataInstance{
    static NSMutableDictionary *singleInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        singleInstance = [[NSMutableDictionary alloc] init];
    });
    return singleInstance;
}
 
//- (id)initWithFrame:(CGRect)frame normalImage:(UIImage*)nImage highImage:(UIImage*)hImage
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//        self.normalImage = nImage;
//        self.highImage = hImage;
//        
//        _bkImageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        _bkImageView.image = nImage;
//        [self addSubview:_bkImageView];
//        
//        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
//        _textLabel.backgroundColor = [UIColor clearColor];
//        _textLabel.textColor = [UIColor whiteColor];
//        _textLabel.textAlignment = NSTextAlignmentCenter;
//        _textLabel.font = [UIFont systemFontOfSize:14];
//        _textLabel.text = @"";
//        [self addSubview:_textLabel];
//        
//        bEnable = NO;
//        bWait = NO;
//        self.timeInterval = 120;
//    }
//    return self;
//}

-(void)awakeFromNib
{
    //初始化属性
    self.timeInterval = 120;
    self.buttonCode = @"";
    self.isTiming = NO;
    
    self.backgroundColor = [UIColor clearColor];
    
    _bkImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_bkImageView];
    
    [_bkImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = UIColor_DefGreen;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.text = @"";
    [self addSubview:_textLabel];
    
    [_textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    //注册一个通知
}
-(void)setTitle:(NSString*)title normalImage:(UIImage*)nImage highImage:(UIImage*)hImage
{
    self.textLabel.text = title;
    self.bkImageView.image = nImage;
    self.normalImage = nImage;
    self.highImage = hImage;
    self.title = title;
}

-(void)setTitle:(NSString*)title textColor:(UIColor*)textColor normalImage:(UIImage*)nImage highImage:(UIImage*)hImage
{
    self.textLabel.text = title;
    self.textLabel.textColor = textColor;
    self.textColor = textColor;
    self.bkImageView.image = nImage;
    self.normalImage = nImage;
    self.highImage = hImage;
    self.title = title;
}
-(void)setStyle:(UIColor*)textColor normalImage:(UIImage*)nImage highImage:(UIImage*)hImage{
    self.textLabel.textColor = textColor;
    self.textColor = textColor;
    self.bkImageView.image = nImage;
    self.normalImage = nImage;
    self.highImage = hImage;
}


- (void) dealloc
{
    [self stopTimer];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_isTiming) {
        [self.bkImageView setImage:self.highImage];
        self.textLabel.textColor = [UIColor whiteColor];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (!_isTiming) {
        //[self beginTimer];
        self.textLabel.textColor = self.textColor;//UIColorFromRGB(0x00a489);
        [self.bkImageView setImage:self.normalImage];
        
        if ([self.delegate respondsToSelector:@selector(dynaButtonClick:)]) {
            [self.delegate performSelector:@selector(dynaButtonClick:) withObject:self];
        }
    }
}

- (void)beginTimer:(NSString *) buttonCode
{
    
    if (_isTiming) {
        return;
    }
    //获取当前时间
    NSDate *currentTime =[NSDate date];
    NSDate *recordTime = currentTime;
    //点击后发送显示
    if (buttonCode) {
        self.buttonCode = buttonCode;
        //记录一次
        [[DynaButton dataInstance] setObject:currentTime forKey:self.buttonCode];
        seconds = self.timeInterval;
        //这是点击进入的获取兑换卷
        if ([self.delegate respondsToSelector:@selector(clickTiming)]) {
            [self.delegate performSelector:@selector(clickTiming)];
        }
    }
    //已经发送过显示，初次加载
    else if(!buttonCode&&[[[DynaButton dataInstance] allKeys] containsObject:self.buttonCode]){
        recordTime = (NSDate *)[[DynaButton dataInstance] objectForKey:self.buttonCode];
        double intervalSecond = self.timeInterval - [currentTime timeIntervalSinceDate:recordTime];
        seconds = intervalSecond;
        if (intervalSecond < 0) {
            return;
        }
    }
    else{
        return;
    }
    
    _isTiming = YES;
    self.textLabel.textColor = [UIColor lightGrayColor];
    self.textLabel.font = [UIFont systemFontOfSize:12];
    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                              target:self
//                                            selector:@selector(timerPro)
//                                            userInfo: nil
//                                             repeats:YES];
//    _timer = [[NSTimer alloc] initWithFireDate:nil interval:1.0 target:self selector:@selector(timerPro) userInfo:nil repeats:YES];
//    [_timer fire];
//    [_timer invalidate];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        _timer = [NSTimer timerWithTimeInterval:1.0
//                                      target:self
//                                    selector:@selector(timerPro)
//                                    userInfo:nil
//                                     repeats:YES];
//    
//    // 当需要调用时,可以把计时器添加到事件处理循环中
//        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
//        [[NSRunLoop currentRunLoop] run];
//    });
    
    [_timer invalidate];
    __block DynaButton *blockSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        blockSelf->_timer=[NSTimer timerWithTimeInterval:0.1
                                                  target:blockSelf
                                                selector:@selector(timerPro)
                                                userInfo:nil
                                                 repeats:YES] ;
        
        [[NSRunLoop currentRunLoop] addTimer:blockSelf->_timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
        
    });
}

- (void) stopTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.textLabel.text = self.title;
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.textColor = self.textColor;
    _isTiming = NO;
    seconds = 0;
}


-(void)timerPro
{
    
    if (seconds > 0.0 && _isTiming) {
        
        fSeconds ++;
        if (fSeconds == 10) {
            seconds--;
            fSeconds = 0;
        }
        self.textLabel.text = [NSString stringWithFormat:@"倒计时%d秒", (int)seconds];
        //这是点击进入的获取兑换卷
        if ([self.delegate respondsToSelector:@selector(timingButton:)]) {
            [self.delegate performSelector:@selector(timingButton:)];
        }
        
    }
    else
    {
        [self stopTimer];
    }
}


@end
