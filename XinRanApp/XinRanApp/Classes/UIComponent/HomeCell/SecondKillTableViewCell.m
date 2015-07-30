//
//  SecondKillTableViewCell.m
//  XinRanApp
//
//  Created by libj on 15/4/3.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "SecondKillTableViewCell.h"
#import "ProductForCmd.h"
#import <XRNetInterface/UIImageView+AFNetworking.h>

#define secondKillTagStart 101

@implementation SecondKillTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self initInterface];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//初始化界面
-(void)initInterface{
//    if (!_killDataSource) {
//        _killDataSource = [[NSMutableArray alloc] init];
//    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.killTimerView.delegate = self;
}

//根据数据改变scoll中的图片
-(void)reloadScrollView {
    for(UIView *view in [self.killScrollView subviews]){
        [view removeFromSuperview];
    }
    //数据源中含有数据设置界面
    if(_killDataSource.count==0){
        return;
    }
    //一个图片的宽度
    float tempImageWidth = (deviceWidth - 30)/2;
    //设置容量大小
//    [self.killScrollView setContentSize:CGSizeMake((tempImageWidth+10)*_killDataSource.count + 10, self.killScrollView.bounds.size.height)];
    
    NSArray *arPdt = [self.killDataSource objectForKey:KJsonElement_ArrayKills];
    int i = 0;
    for (ProductForCmd *pdt in arPdt) {
        UIImageView *tempImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_defaut_img"]];
        
        [tempImage setFrame:CGRectMake(i*tempImageWidth + (i+1)*10, 0, tempImageWidth, tempImageWidth)];
        [tempImage setImageWithURL:[NSURL URLWithString:pdt.image]];
        
        //添加点击手势
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSecondKillProduct:)];
        [tempImage addGestureRecognizer:gesture];
        [tempImage setUserInteractionEnabled:YES];
        [tempImage setTag:secondKillTagStart+i];
        [self.killScrollView addSubview:tempImage];
        
        i++;
    }
}

//设置数据源的时候更改界面数据
-(void)setKillDataSource:(NSDictionary *)killDataSource{
    
    if (![_killDataSource isEqualToDictionary:killDataSource]) {
        _killDataSource =  killDataSource;
        [self reloadScrollView];
        
        int status = [[killDataSource objectForKey:KJsonElement_States] intValue];
        switch (status) {
            case 0:
            {
                self.labelStatus.text = @"距开始";
            }
                break;
            case 1:
            case 3:
            {
                self.labelStatus.text = @"距结束";
            }
                break;
            case 2:
            {
                self.labelStatus.text = @"已结束";
                return;
            }
                break;
                
            default:
                break;
        }
        
        [self.killTimerView setTotalSeconds:[[killDataSource objectForKey:KJsonElement_Seconds] intValue]];
        [self.killTimerView start];
    }

}

#pragma mark ---
//点击秒杀执行事件
-(void)clickSecondKillProduct:(id)sender{
    //手势
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIImageView *tempIamge = (UIImageView *)tap.view;
    //执行协议
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickSecondKillCell:)] ) {
        [self.delegate clickSecondKillCell:(tempIamge.tag - secondKillTagStart)];
    }
    
}

-(void)timerViewFinished
{
    //self.labelStatus.text = @"已结束";
    if ([self.delegate respondsToSelector:@selector(secondEnd)]) {
        [self.delegate secondEnd];
    }
}
@end













