//
//  WaitView.m
//  GTunes
//
//  Created by huangzan on 09-5-4.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WaitView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+bundle.h"

@interface WaitView ()
{
    UIImageView *ivBg;
    UIImageView *ivProgress;
    UIImageView *ivLogo;
    UILabel * textLabel;

    NSInteger angle;
    BOOL bStop;
}
@property (nonatomic, retain) UILabel * textLabel;

@end

@implementation WaitView
@synthesize textLabel;

+ (WaitView *) sharedInstance 
{
    static WaitView *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[WaitView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    
    return instance;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) 
	{
		[self setBackgroundColor:[UIColor clearColor]];
		//[self setBackgroundColor:[UIColor redColor]];
        UIImage *image = [UIImage imagesNamedFromBundle:@"loading_bg"];
        ivBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width/2, image.size.height/2)];
        ivBg.image = image;
        [self addSubview:ivBg];
        
        image = [UIImage imagesNamedFromBundle:@"loading_icon"];
        ivLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width/2, image.size.height/2)];
        ivLogo.image = image;
        [ivBg addSubview:ivLogo];
        
        
        image = [UIImage imagesNamedFromBundle:@"loading_progress"];
        ivProgress = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width/2, image.size.height/2)];
        ivProgress.image = image;
        [ivBg addSubview:ivProgress];
		
		textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		textLabel.backgroundColor = [UIColor clearColor];
		textLabel.opaque = NO;
		[textLabel  setTextAlignment:NSTextAlignmentCenter];
		textLabel.baselineAdjustment=UIBaselineAdjustmentAlignCenters;		
		textLabel.textColor = UIColor_DefOrange;
		textLabel.highlightedTextColor = [UIColor blackColor];
		textLabel.font = [UIFont systemFontOfSize:15.0];
        textLabel.text = @"正在努力为您加载...";
		[ivBg addSubview:textLabel];
        [textLabel sizeToFit];

	}
	return self;
}
- (void)layoutSubviews
{
	[super layoutSubviews];
	
    ivBg.center = self.center;
	
    CGRect frame = ivBg.bounds;
    
    ivLogo.frame = CGRectMake((frame.size.width-ivLogo.frame.size.width)/2,
                              (frame.size.height-ivLogo.frame.size.height)/2-10,
                              ivLogo.frame.size.width,
                              ivLogo.frame.size.height);
    
    ivProgress.frame = CGRectMake((frame.size.width-ivProgress.frame.size.width)/2,
                              (frame.size.height-ivProgress.frame.size.height)/2-10,
                              ivProgress.frame.size.width,
                              ivProgress.frame.size.height);

    textLabel.frame = CGRectMake(0,
                                 frame.size.height-30,
                                 frame.size.width,
                                 30);
    
}

- (void)dealloc
{
    self.textLabel = nil;
}

-(void)start{
    
    if (![[[UIApplication sharedApplication] keyWindow] viewWithTag:18990]) {
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        self.tag = 18990;

        angle = 0;
        [self animation];
    }
    
    bStop = NO;
}


-(void)stop{
    bStop = YES;
	[self removeFromSuperview];
}

-(void)animation
{
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    [UIView animateWithDuration:0.03 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        ivProgress.transform = endAngle;
    } completion:^(BOOL finished) {
        if (bStop) {
            return ;
        }
        angle += 10;
        [self animation];
        
    }];
}


-(void)setStateText:(NSString*)text
{
	[textLabel setText:text];
	[self layoutSubviews];
	[self setNeedsDisplay];
}

@end
