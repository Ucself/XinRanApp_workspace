//
//  SecondKillTableViewCell.h
//  XinRanApp
//
//  Created by libj on 15/4/3.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XRUIView/HomeTimerView.h>

@protocol SecondKillTableViewCellDelegate <NSObject>

@optional
//点击秒杀
-(void)clickSecondKillCell:(NSInteger)indexPath;
-(void)secondEnd;

@end

@interface SecondKillTableViewCell : UITableViewCell

//时间控件
@property (weak, nonatomic) IBOutlet HomeTimerView *killTimerView;
//秒杀商品列表
@property (weak, nonatomic) IBOutlet UIScrollView *killScrollView;
//请求的数据源
@property (nonatomic, strong) NSDictionary *killDataSource;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;

//协议
@property (assign,nonatomic) id delegate;
-(void)reloadScrollView;
////设置数据源的时候更改界面数据
//-(void)setKillDataSource:(NSMutableArray *)killDataSource;
@end
