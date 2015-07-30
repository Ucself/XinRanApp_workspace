//
//  UserWhouse.h
//  XinRanApp
//
//  Created by tianbo on 15-1-15.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//
// 用户常用店铺类

#import "BaseModel.h"

@interface UserWhouse : BaseModel

@property(strong, nonatomic) NSString *userId;
@property(strong, nonatomic) NSString *whouseId;


//指定userId删除表数据
+(BOOL)removeWithId:(NSString *)userId;

//指定userId查询表数据
+(UserWhouse*)userWhouseWithId:(NSString *)userId;
@end
