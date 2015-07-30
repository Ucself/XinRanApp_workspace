//
//  CategoryTableViewCell.m
//  XinRanApp
//
//  Created by libj on 15/4/3.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "CategoryTableViewCell.h"
#import <XRCommon/Common.h>
#import "GoodClass.h"
#import <XRUIView/Masonry.h>
#import <XRShareSDK/XDShareManager.h>

#define CategoryTagStart 201

@interface CategoryTableViewCell (){
    //图片数组
    NSArray *imageArray;
}

@end
@implementation CategoryTableViewCell

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Category" ofType:@"plist"];
        imageArray = [NSMutableArray arrayWithContentsOfFile:path];
        [self initInterface];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark ----
//加载界面数据
- (void) initInterface{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [self addSubview:_scrollView];
        [_scrollView setScrollEnabled:NO];
        [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    //当前页面
//    currentPage = 0;
    //初始化默认数据
    [self.scrollView setContentSize:CGSizeMake(deviceWidth*2, 50)];
    [self layoutCategory];
    
}


//布局类别
-(void)layoutCategory{
    //清楚所有存在的视图
    for(UIView *view in [self.scrollView subviews]){
        [view removeFromSuperview];
    }
    //有数据的时候
    float tempWidth = deviceWidth/4;
    for (int i = 0; i < 4; i++) {
        //设置分类单
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(tempWidth * i, 0, tempWidth, 70)];
        [self.scrollView addSubview:tempView];
        //设置分类图标
//        UIButton *tempImageView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        UIButton *tempImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        [tempImageView setFrame:CGRectMake(0, 0, 50, 50)];
        [tempImageView setCenter:CGPointMake(tempWidth/2, 70/2)];
        NSDictionary *goodImageDic = imageArray[i];
        [tempImageView setBackgroundImage:[UIImage imageNamed:[goodImageDic objectForKey:@"image"]] forState:UIControlStateNormal];
        [tempImageView setBackgroundImage:[UIImage imageNamed:[goodImageDic objectForKey:@"selectedImage"]] forState:UIControlStateHighlighted];

        //添加点击手势
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)];
        [tempImageView addGestureRecognizer:gesture];
        [tempImageView setUserInteractionEnabled:YES];
        [tempImageView setTag:CategoryTagStart+i];
        
        [tempView addSubview:tempImageView];
        //设置分类名称
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, tempWidth, 20)];
        [tempLabel setTextAlignment:NSTextAlignmentCenter];
        tempLabel.textColor = [UIColor darkGrayColor];
        [tempLabel setFont:[UIFont systemFontOfSize:13.0f]];
        tempLabel.text = [goodImageDic objectForKey:@"title"];
        [tempView addSubview:tempLabel];
    }
}

#pragma mark ---
-(void)onClick:(id)sender{
    //手势
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIImageView *tempIamge = (UIImageView *)tap.view;
    
    NSInteger tag = tempIamge.tag - CategoryTagStart;
    
    NSDictionary *goodImageDic = imageArray[tag];
    //执行协议
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCategoryTableViewCell:dicInfor:)] ) {
        [self.delegate clickCategoryTableViewCell:tag dicInfor:goodImageDic];
    }
    
}

@end










