//
//  Shake.h
//  XRDataModel
//
//  Created by tianbo on 15-5-26.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//
// 抽奖活动类
#import "BaseModel.h"


//  0，进行中  1，无活动  2，未开始（下期预告）  3，已结束（无下期，上期回顾）
typedef NS_ENUM(int, ShakeType)
{
    ShakeType_Beginning = 0,
    ShakeType_NoShake,
    ShakeType_NotBegin,
    ShakeTYpe_end,
};

@interface Shake : BaseModel


@property (nonatomic,strong) NSString *Id;
@property (nonatomic,strong) NSString *addr;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *remaindNum;        //剩余次数
@end
