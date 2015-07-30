//
//  Whouse.h
//  XinRanApp
//
//  Created by tianbo on 14-12-18.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//
// 门店信息

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface Whouse : BaseModel

@property(nonatomic, strong) NSString *Id;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *areaId;      //所属区域id
@property(nonatomic, strong) NSString *address;     //地址
@property(nonatomic, strong) NSString *longitude;         //经度
@property(nonatomic, strong) NSString *latitude;          //纬度
@property(nonatomic, assign) int remainds;

//指定店铺Id查询表数据
+(Whouse*)whouseWithId:(NSString *)whouseId;
@end


@interface WhouseProduct : Whouse

@property(copy, nonatomic) NSString *adwId;
@property(assign, nonatomic) int goodsn;
@property(assign, nonatomic) int saled;
@end
