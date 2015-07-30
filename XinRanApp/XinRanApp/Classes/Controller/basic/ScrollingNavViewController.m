//
//  ScrollingNavViewController.m
//  XinRanApp
//
//  Created by tianbo on 15-3-18.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "ScrollingNavViewController.h"
#define NavBarFrame self.navigationController.navigationBar.frame


@interface ScrollingNavViewController ()<UIGestureRecognizerDelegate>{

}

//实现上下滑动隐藏显示导航栏效果
@property (weak, nonatomic) UIScrollView *scrollView;
@property (retain, nonatomic)UIPanGestureRecognizer *panGesture;
//用来navigationBar中的内容
@property (retain, nonatomic)UIView *overLay;
//判断当前导航栏是否隐藏
@property (assign, nonatomic)BOOL isHidden;

@end

@implementation ScrollingNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar bringSubviewToFront:self.overLay];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.overLay.alpha=0;
    self.isHidden= NO;
    
    int top = 64+40;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect navBarFrame=NavBarFrame;
        navBarFrame.origin.y = 20;
        NavBarFrame = navBarFrame;
        self.navigationItem.hidesBackButton = NO;
        [self.scrollView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(top);
        }];
        
        [self.view layoutIfNeeded];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


-(void)followRollingScrollView:(UIScrollView *)scrollView
{
    self.scrollView = scrollView;
    
    self.panGesture = [[UIPanGestureRecognizer alloc] init];
    self.panGesture.delegate=self;
    self.panGesture.minimumNumberOfTouches = 1;
    [self.panGesture addTarget:self action:@selector(handlePanGesture:)];
    [self.scrollView addGestureRecognizer:self.panGesture];
    
    self.overLay = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.bounds];
    self.overLay.alpha = 0;
    self.overLay.backgroundColor = self.navigationController.navigationBar.barTintColor;
    [self.navigationController.navigationBar addSubview:self.overLay];
    [self.navigationController.navigationBar bringSubviewToFront:self.overLay];
}



-(void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    if (self.scrollView.contentSize.height <= self.scrollView.frame.size.height && !self.isHidden) {
        return;
    }
    CGPoint translation = [panGesture translationInView:[self.scrollView superview]];
    //显示
    if (translation.y >= 5 && self.isHidden) {
        [self showNaigationBar:YES];
    }
    //隐藏
    if (translation.y <= -20 && !self.isHidden) {
        [self showNaigationBar:NO];
    }
}

-(void)showNaigationBar:(BOOL)show
{
    
    int y = show ? 20 : -20;
    int top = show ? 64+40 : 20;
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = NavBarFrame;
        frame.origin.y = y;
        NavBarFrame = frame;
        self.navigationItem.hidesBackButton = !show;
        [self.scrollView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(top).priorityHigh();
        }];
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if (show) {
            self.overLay.alpha=0;
        }
        else {
            self.overLay.alpha=1;
        }
        
    }];
    
    self.isHidden= !show;
}
@end
