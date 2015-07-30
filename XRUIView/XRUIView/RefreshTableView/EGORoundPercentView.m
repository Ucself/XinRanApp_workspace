//
//  EGORoundPercentView.m
//  MDRadialProgress
//
//  Created by libj on 15/5/8.
//  Copyright (c) 2015年 Marco Dinacci. All rights reserved.
//

#import "EGORoundPercentView.h"
@implementation EGORoundPercentUIColor

-(instancetype)init{
    
    if (self = [super init]) {
        _completedColor = [UIColor grayColor];
        _incompletedColor = [[UIColor alloc] initWithRed:242.f/255 green:242.f/255 blue:242.f/255 alpha:1.0];
        _centerColor = [[UIColor alloc] initWithRed:242.f/255 green:242.f/255 blue:242.f/255 alpha:1.0];
    }
    
    return self;
}

@end

@interface EGORoundPercentView (){

    NSInteger lineWidth;
}

@end

@implementation EGORoundPercentView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        //设置默认值
        _progressTotal = 100.f;
        _progressCounter = 0.f;
        _clockwise = YES;
        _themeColors = [[EGORoundPercentUIColor alloc] init];
        //默认进度线条为一像素
        lineWidth = 1;
    }

    return self;
}
//设置总数
-(void)setProgressTotal:(float)progressTotal{
    //重置总数的时候清空当前数
    _progressCounter = 0.f;
    //重置总数
    _progressTotal = progressTotal;
}
//设置当前进度数
-(void)setProgressCounter:(float)progressCounter{
    //超出了总数，直接返回 留一点缝隙
    if (progressCounter > _progressTotal - 5.f) {
        return;
    }
    _progressCounter = progressCounter;
    //重新绘制
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}
- (void)setIsIndeterminateProgress:(BOOL)isIndeterminateProgress
{
    _isIndeterminateProgress = isIndeterminateProgress;
    
    if(_isIndeterminateProgress){
        [self startAnimationForIndeterminateMode];
    }
    else{
        [self stopAnimationForIndeterminateMode];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) drawRect:(CGRect)rect{
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGSize viewSize = self.bounds.size;
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    
    // Always attempt to draw, even if there is no progress because one might want to display the empty progress.
    double radius = MIN(viewSize.width, viewSize.height) / 2;
    [self drawSlicesWithRadius:radius center:center inContext:contextRef];
    
    // Draw the slice separators, unless the sliceDividerHidden property is true.
//    [self drawSlicesSeparators:contextRef withViewSize:viewSize andCenter:center];
    
    // Draw the center.
    [self drawCenter:contextRef withViewSize:viewSize andCenter:center];
}

# pragma mark - Indeterminate Mode ANimations

- (void) startAnimationForIndeterminateMode
{
    // store progress counter value for use at the end of animation
    self.progressCounterTemp = self.progressCounter;
    
    // Change progress counter value to value reasonably suited or indeterminate animation
//    self.progressCounter = 0.91181818 * (float)_progressTotal;
    self.progressCounter = _progressTotal - 5.f;
    
    // Spin forever .. or at least until we stop it
    [self runSpinAnimationOnView:self duration:10 rotations:1 repeat:HUGE_VALF];
}

- (void) stopAnimationForIndeterminateMode
{
    // stop spinning animation
    [self.layer removeAnimationForKey:@"rotationAnimation"];
    
    // return progress counter to the vaue it had before the animation
    self.progressCounter = self.progressCounterTemp;
}

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
#pragma mark - Drawing
- (void)drawSlicesWithRadius:(double)circleRadius
                      center:(CGPoint)center
                   inContext:(CGContextRef)context
{
    // If there's no progress, just draw the incomplete arc.
    if (self.progressCounter == 0) {
        [self drawArcInContext:context
                        center:center
                        radius:circleRadius
                    startAngle:0
                      endAngle:M_PI * 2
                         color:_themeColors.incompletedColor.CGColor
                     clockwise:!_clockwise];
        return;
    }
        // Draw just two arcs, one for the completed slices (if any) and one for the
        // uncompleted ones.
    double originAngle, endAngle;
    double sliceAngle = (2 * M_PI) / self.progressTotal;
    double startingAngle = sliceAngle;
    double progressAngle = sliceAngle * self.progressCounter;
    
    if (self.clockwise) {
        originAngle = - M_PI_2 + startingAngle;
        endAngle = originAngle + progressAngle;
    } else {
        originAngle = - M_PI_2 - startingAngle;
        endAngle = originAngle - progressAngle;
    }
        
        // Draw the arcs grouped instead of individually to avoid
        // artifacts between one slice and another.
        
        // Completed slices.
    [self drawArcInContext:context
                    center:center
                    radius:circleRadius
                startAngle:originAngle
                  endAngle:endAngle
                     color:_themeColors.completedColor.CGColor
                 clockwise:!_clockwise];
    
    if (self.progressCounter < self.progressTotal) {
            // Incompleted slices
        [self drawArcInContext:context
                        center:center
                        radius:circleRadius
                    startAngle:endAngle
                      endAngle:originAngle
                         color:_themeColors.incompletedColor.CGColor
                     clockwise:!_clockwise];
    }
    
}

- (void)drawSlicesSeparators:(CGContextRef)contextRef withViewSize:(CGSize)viewSize andCenter:(CGPoint)center
{
    int outerDiameter = MIN(viewSize.width, viewSize.height);
    double outerRadius = outerDiameter / 2.0 - 5.f;
    int innerDiameter = outerDiameter - 10.f;
    double innerRadius = innerDiameter / 2.0;
    int sliceCount = (int)self.progressTotal;
    double sliceAngle = (2 * M_PI) / sliceCount;
    
    CGContextSetLineWidth(contextRef, 10.f);
    CGContextSetStrokeColorWithColor(contextRef, _themeColors.incompletedColor.CGColor);
    CGContextMoveToPoint(contextRef, center.x, center.y);
    
    for (int i = 0; i < sliceCount; i++) {
        CGContextBeginPath(contextRef);
        
        double startAngle = sliceAngle * i - M_PI_2;
        double endAngle = sliceAngle * (i + 1) - M_PI_2;
        
        // Draw the outer slice arc clockwise.
        CGContextAddArc(contextRef, center.x, center.y, outerRadius, startAngle, endAngle, 0);
        // Draw the inner slice arc in the opposite direction. The separator line is drawn automatically when moving
        // from the point where the outer arc ended to the point where the inner arc starts.
        CGContextAddArc(contextRef, center.x, center.y, innerRadius, endAngle, startAngle, 1);
        CGContextStrokePath(contextRef);
    }
}
//画中心圆
- (void)drawCenter:(CGContextRef)contextRef withViewSize:(CGSize)viewSize andCenter:(CGPoint)center
{
    int innerDiameter = MIN(viewSize.width, viewSize.height) - lineWidth*2;
    double innerRadius = innerDiameter / 2.0;
    
    CGContextSetLineWidth(contextRef, 1.f);
    CGRect innerCircle = CGRectMake(center.x - innerRadius, center.y - innerRadius,
                                    innerDiameter, innerDiameter);
    CGContextAddEllipseInRect(contextRef, innerCircle);
    CGContextClip(contextRef);
    CGContextClearRect(contextRef, innerCircle);
    CGContextSetFillColorWithColor(contextRef,_themeColors.centerColor.CGColor);
    CGContextFillRect(contextRef, innerCircle);
}

- (void)drawArcInContext:(CGContextRef)context center:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle
                endAngle:(CGFloat)endAngle color:(CGColorRef)color clockwise:(BOOL)cgClockwise
{
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, center.x, center.y);
    CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, cgClockwise);
    CGContextSetFillColorWithColor(context, color);
    CGContextFillPath(context);
}


@end
