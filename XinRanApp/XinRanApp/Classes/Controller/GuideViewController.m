//
//  GuideViewController.m
//  XinRanApp
//
//  Created by tianbo on 14-12-4.
//  Copyright (c) 2014年 deshan.com All rights reserved.
//

#import "GuideViewController.h"


@interface GuideViewController ()<UITableViewDelegate>{
    //guide1
    UIImageView *guide1Image;
    UIImageView *guide1Text;
    //guide2
    UIImageView *guide2Image;
    UIImageView *guide2Text;
    //guide3
    UIImageView *guide3Image;
    UIImageView *guide3Text;
}

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *uiView1;
@property (weak, nonatomic) IBOutlet UIView *uiView2;
@property (weak, nonatomic) IBOutlet UIView *uiView3;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation GuideViewController


- (void)awakeFromNib{
    
    //初始化界面
}

- (void)viewDidLoad {
    //不显示网络提示
    isShowNetPrompt = NO;
    [super viewDidLoad];
    //滚动试图协议
    self.mainScrollView.delegate = self;
    // Do any additional setup after loading the view.
    [self initInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark --

//初始化界面
-(void) initInterface{
    //宽度
    float tempWidth = deviceWidth - 80.f;
    //宽度
    float tempTextWidth = deviceWidth - 100.f;
    //顶部距离
    float topDistance = 80.f;
    //底部距离
    float bottomDistance = -100.f;
    //设置背景色
    [self.uiView1 setBackgroundColor:UIColorFromRGB(0xffc000)];
    [self.uiView2 setBackgroundColor:UIColorFromRGB(0x7ecef4)];
    [self.uiView3 setBackgroundColor:UIColorFromRGB(0x17ceb0)];
    //设置第一页图片信息
    if (!guide1Image) {
        guide1Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide1"]];
        [self.uiView1 addSubview:guide1Image];
        //设置布局
        [guide1Image makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(tempWidth);
            make.height.equalTo(tempWidth*(431.f/488.f));
            make.centerX.equalTo(self.uiView1.centerX).offset(-10);
            make.top.equalTo(topDistance);
        }];
    }
    if (!guide1Text) {
        guide1Text = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide1Text"]];
        [self.uiView1 addSubview:guide1Text];
        //设置布局
        [guide1Text makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(tempTextWidth);
            make.height.equalTo(tempTextWidth*(110.f/513.f));
            make.centerX.equalTo(self.uiView1.centerX);
            make.bottom.equalTo(bottomDistance);
        }];
    }
    //设置第二页图片信息
    if (!guide2Image) {
        guide2Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide2"]];
        [self.uiView2 addSubview:guide2Image];
        //设置布局
        [guide2Image makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(tempWidth);
            make.height.equalTo(tempWidth*(431.f/488.f));
            make.centerX.equalTo(self.uiView2.centerX);
            make.top.equalTo(topDistance);
        }];
    }
    if (!guide2Text) {
        guide2Text = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide2Text"]];
        [self.uiView2 addSubview:guide2Text];
        //设置布局
        [guide2Text makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(tempTextWidth);
            make.height.equalTo(tempTextWidth*(110.f/513.f));
            make.centerX.equalTo(self.uiView2.centerX);
            make.bottom.equalTo(bottomDistance);
        }];
    }
    //设置第三页图片信息
    if (!guide3Image) {
        guide3Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide3"]];
        [self.uiView3 addSubview:guide3Image];
        //设置布局
        [guide3Image makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(tempWidth);
            make.height.equalTo(tempWidth*(431.f/488.f));
            make.centerX.equalTo(self.uiView3.centerX).offset(-10);
            make.top.equalTo(topDistance);
        }];
    }
    if (!guide3Text) {
        guide3Text = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide3Text"]];
        [self.uiView3 addSubview:guide3Text];
        //设置布局
        [guide3Text makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(tempTextWidth);
            make.height.equalTo(tempTextWidth*(110.f/513.f));
            make.centerX.equalTo(self.uiView3.centerX);
            make.bottom.equalTo(bottomDistance);
        }];
    }
}

- (IBAction)btnToMainClick:(id)sender {
    
    self.uiView1 = nil;
    self.uiView2 = nil;
    self.uiView3 = nil;
    [self performSegueWithIdentifier:@"ToMain" sender:self];
}

#pragma mark --- UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((self.mainScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage=page;
    
}

#pragma mark- http request handler
-(void)httpRequestFinished:(NSNotification *)notification
{
    DBG_MSG(@"enter");
}

-(void)httpRequestFailed:(NSNotification *)notification
{
    //return [super httpRequestFailed:notification];
}
@end
