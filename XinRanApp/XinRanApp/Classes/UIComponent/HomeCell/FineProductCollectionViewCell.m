//
//  FineProductCollectionViewCell.m
//  XinRanApp
//
//  Created by tianbo on 15-4-9.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "FineProductCollectionViewCell.h"
#import <XRUIView/Masonry.h>
#import <XRCommon/DateUtils.h>

@interface FineProductCollectionViewCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *btmView;
@end

@implementation FineProductCollectionViewCell

-(void)dealloc
{
    self.containerView = nil;
    self.topView = nil;
    self.btmView = nil;
    self.thumbView = nil;
    self.title = nil;
    self.price = nil;
    self.saled = nil;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /////////////////////////////////////////////////////////////////
        self.topView = [UIView new];
        [self.contentView addSubview:self.topView];
        [self.topView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_finepdttitle"]];
        [self.topView addSubview:titleView];
        [titleView makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(47);
            make.left.equalTo(self.topView.left).offset(5);
            make.top.equalTo(self.topView.top).offset(12);
            make.height.equalTo(17);
        }];
        
        
        //精选日期
        UILabel *labelTips = [[UILabel alloc] init];
        labelTips.text = @"只选对的, 不选贵的";
        [labelTips setFont:[UIFont systemFontOfSize:13]];
        [labelTips setTextColor:UIColorFromRGB(0xb2b2b3)];
        [self.topView addSubview:labelTips];
        [labelTips makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.topView.width);
            make.left.equalTo(self.topView.left).offset(2);
            make.bottom.equalTo(self.topView.bottom);
            make.height.equalTo(20);
        }];
        
//        UILabel *labelDate = [[UILabel alloc] init];
//        [self.topView addSubview:labelDate];
//        [labelDate makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(self.topView.width);
//            make.left.equalTo(self.topView.left).offset(6);
//            make.bottom.equalTo(self.topView.bottom);
//            make.height.equalTo(20);
//        }];
//        
//        NSString *day = [DateUtils todayfmtDDMM];
//        [labelDate setText:day];
//        [labelDate setFont:[UIFont systemFontOfSize:12]];
//        [labelDate setTextColor:UIColorFromRGB(0xb2b2b3)];
        self.topView.hidden = YES;
        
        
        /////////////////////////////////////////////////////////////////
        self.btmView = [UIView new];
        [self.contentView addSubview:self.btmView];
        [self.btmView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        UILabel *labelBottom = [[UILabel alloc] init];
        [self.btmView addSubview:labelBottom];
        [labelBottom makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.btmView.width);
            make.left.equalTo(self.btmView.left);
            make.bottom.equalTo(self.btmView.bottom);
            make.height.equalTo(30);
        }];
        [labelBottom setText:@"已经到底了!"];
        [labelBottom setTextAlignment:NSTextAlignmentCenter];
        [labelBottom setFont:[UIFont systemFontOfSize:14]];
        [labelBottom setTextColor:UIColorFromRGB(0xb2b2b3)];
        self.btmView.hidden = YES;
        
        
        /////////////////////////////////////////////////////////////////
        self.containerView = [UIView new];
        [self.contentView addSubview:self.containerView];
        [self.containerView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.thumbView = [UIImageView new];
        self.thumbView.image = [UIImage imageNamed:@"icon_defaut_img"];
        [self.containerView addSubview:self.thumbView];
        [self.thumbView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView);
            make.left.equalTo(self.containerView);
            make.width.equalTo(self.containerView.width);
            make.height.equalTo(self.containerView.width);
        }];
        
        self.title = [UILabel new];
        self.title.textColor = [UIColor lightGrayColor];
        self.title.font = [UIFont systemFontOfSize:14];
        
        [self.containerView addSubview:self.title];
        [self.title makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.thumbView.bottom);
            make.left.equalTo(self.thumbView).offset(5);
            make.width.equalTo(self.containerView.width).offset(-10);
            make.height.equalTo(25);
        }];
        
        self.price = [UILabel new];
        self.price.textColor = [UIColor darkGrayColor];
        self.price.font = [UIFont systemFontOfSize:18];
        
        [self.containerView addSubview:self.price];
        [self.price makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.bottom);
            make.left.equalTo(self.thumbView).offset(5);
            make.width.equalTo(150);
            make.height.equalTo(30);
        }];
        
        self.saled = [UILabel new];
        self.saled.textColor = [UIColor lightGrayColor];
        self.saled.font = [UIFont systemFontOfSize:13];
        self.saled.textAlignment = NSTextAlignmentRight;
        
        [self.containerView addSubview:self.saled];
        [self.saled makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.bottom);
            make.right.equalTo(self.containerView.right).offset(-5);
            make.width.equalTo(150);
            make.height.equalTo(30);
        }];
        
    }
    
    return self;
}

-(void)showTopView
{
    [self setBackgroundColor:[UIColor clearColor]];
    self.containerView.hidden = YES;
    self.topView.hidden = NO;
    self.btmView.hidden = YES;
}

-(void)showBottomView
{
    [self setBackgroundColor:[UIColor clearColor]];
    self.containerView.hidden = YES;
    self.topView.hidden = YES;
    self.btmView.hidden = NO;
}

-(void)showProductView
{
    [self setBackgroundColor:[UIColor whiteColor]];
    self.containerView.hidden = NO;
    self.topView.hidden = YES;
    self.btmView.hidden = YES;
}

@end
