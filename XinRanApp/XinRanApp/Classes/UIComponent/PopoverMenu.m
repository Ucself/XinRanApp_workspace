//
//  PopoverMenu.m
//  XinRanApp
//
//  Created by tianbo on 15-2-3.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "PopoverMenu.h"

#define DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)

@interface PopoverMenu () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) UIControl *blackOverlay;
@property (nonatomic, weak)   UIView *containerView;

@property (nonatomic, assign) CGSize arrowSize;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGPoint arrowShowPoint;

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation PopoverMenu

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arrowSize = CGSizeMake(11.0, 9.0);
        self.cornerRadius = 7.0;
        self.backgroundColor = [UIColor clearColor];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.scrollEnabled = NO;
        self.tableView.layer.cornerRadius = 7;
        
        [self setShadow];
    }
    return self;
}

- (void)setShadow
{
    self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];
    self.layer.shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.9].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 2.0;
}

- (void)showAtPoint:(CGPoint)point inView:(UIView *)view items:(NSArray*)items
{
    if (!self.blackOverlay) {
        self.blackOverlay = [[UIControl alloc] init];
        self.blackOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.blackOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    }
    self.blackOverlay.frame = view.bounds;
    
    self.items = items;
    self.arrowShowPoint = point;
    self.containerView = [[UIApplication sharedApplication] keyWindow]; //先使用keywindow  //view;
    [self.containerView addSubview:self.blackOverlay];
    [self.blackOverlay addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    [self show];
}

- (void)show
{
    [self setNeedsDisplay];
    
    int heigth = (int)self.items.count * 35;
    self.tableView.frame = CGRectMake(0, self.arrowSize.height, 100, heigth);
    [self addSubview:self.tableView];
    [self.containerView addSubview:self];
    
    
    self.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {

    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3f animations:^{
        //self.alpha = 0.1f;
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    } completion:^(BOOL finished) {
        [self.blackOverlay removeFromSuperview];
        [self removeFromSuperview];
        
        if (self.dismissHandler) {
            self.dismissHandler();
        }
    }];
}

- (void)drawRect:(CGRect)rect
{
    //画背景
    UIBezierPath *arrow = [[UIBezierPath alloc] init];
    UIColor *contentColor = [UIColor whiteColor];
    //the point in the ourself view coordinator
    CGPoint arrowPoint = [self.containerView convertPoint:self.arrowShowPoint toView:self];
    
    [arrow moveToPoint:CGPointMake(arrowPoint.x, 0)];
    [arrow addLineToPoint:CGPointMake(arrowPoint.x+self.arrowSize.width*0.5, self.arrowSize.height)];
    [arrow addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds)-self.cornerRadius, self.arrowSize.height)];
    [arrow addArcWithCenter:CGPointMake(CGRectGetWidth(self.bounds)-self.cornerRadius, self.arrowSize.height+self.cornerRadius) radius:self.cornerRadius startAngle:DEGREES_TO_RADIANS(270.0) endAngle:DEGREES_TO_RADIANS(0) clockwise:YES];
    [arrow addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-self.cornerRadius)];
    [arrow addArcWithCenter:CGPointMake(CGRectGetWidth(self.bounds)-self.cornerRadius, CGRectGetHeight(self.bounds)-self.cornerRadius) radius:self.cornerRadius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90.0) clockwise:YES];
    [arrow addLineToPoint:CGPointMake(0, CGRectGetHeight(self.bounds))];
    [arrow addArcWithCenter:CGPointMake(self.cornerRadius, CGRectGetHeight(self.bounds)-self.cornerRadius) radius:self.cornerRadius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(180.0) clockwise:YES];
    [arrow addLineToPoint:CGPointMake(0, self.arrowSize.height+self.cornerRadius)];
    [arrow addArcWithCenter:CGPointMake(self.cornerRadius, self.arrowSize.height+self.cornerRadius) radius:self.cornerRadius startAngle:DEGREES_TO_RADIANS(180.0) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
    [arrow addLineToPoint:CGPointMake(arrowPoint.x-self.arrowSize.width*0.5, self.arrowSize.height)];
    
    [contentColor setFill];
    [arrow fill];
}


- (void)layoutSubviews
{
    CGRect frame = self.tableView.frame;
    frame.size.height = (int)self.items.count * 35 -1;
    
    CGFloat frameMidx = self.arrowShowPoint.x-CGRectGetWidth(frame)*0.5;
    frame.origin.x = frameMidx;
    
    CGFloat sideEdge = 10.0;
    CGFloat outerSideEdge = CGRectGetMaxX(frame)-CGRectGetWidth(self.containerView.bounds);
    if (outerSideEdge > 0) {
        frame.origin.x -= (outerSideEdge+sideEdge);
    }else {
        if (CGRectGetMinX(frame)<0) {
            frame.origin.x += abs(CGRectGetMinX(frame))+sideEdge;
        }
    }
    
    self.frame = frame;
    
    CGPoint arrowPoint = [self.containerView convertPoint:self.arrowShowPoint toView:self];
    frame.origin.y = self.arrowShowPoint.y;
    CGPoint anchorPoint = CGPointMake(arrowPoint.x/CGRectGetWidth(frame), 0);
    
    CGPoint lastAnchor = self.layer.anchorPoint;
    self.layer.anchorPoint = anchorPoint;
    self.layer.position = CGPointMake(self.layer.position.x+(anchorPoint.x-lastAnchor.x)*self.layer.bounds.size.width, self.layer.position.y+(anchorPoint.y-lastAnchor.y)*self.layer.bounds.size.height);
    
    frame.size.height += self.arrowSize.height;
    self.frame = frame;
}

#pragma mark- UITableView Delegate mothed
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CellMenu";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        
//        if (indexPath.row < self.items.count -1) {
//            UIView *line = [UIView new];
//            line.tag = 101;
//            line.frame = CGRectMake(0, 35, cell.frame.size.width, 0.3);
//            line.backgroundColor = [UIColor lightGrayColor];
//            [cell addSubview:line];
//        }
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor darkTextColor];
    cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.selectHandler) {
        self.selectHandler((int)indexPath.row);
    }
    
    [self dismiss];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}
@end
