//
//  Activity.h
//  XinRanApp
//
//  Created by tianbo on 14-12-16.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//
//  活动主题信息类

#import "BaseModel.h"

typedef NS_ENUM(int, ActivityState)
{
    ActivityState_Unkown = -1,
    ActivityState_Ongoing,       //进行中
    ActivityState_End,           //已结束
    ActivityState_WillBegin,     //将要开始
};

@interface Activity : BaseModel

@property(nonatomic, strong) NSString *Id;
@property(nonatomic, assign) ActivityState state;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *desc;
@property(nonatomic, strong) NSString *startDate;
@property(nonatomic, strong) NSString *endDate;
@property(nonatomic, strong) NSString *banner;
@end
