//
//  Areas.h
//  XinRanApp
//
//  Created by tianbo on 14-12-22.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//
// 区域信息

#import "BaseModel.h"

typedef NS_ENUM(int, AreasState)
{
    AreasState_Selelcted = 0,
    AreasState_Normol = 1,
};

@interface Areas : BaseModel

@property(nonatomic, strong) NSString *Id;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *pId;     //上级id
@property(nonatomic, assign) int state;
@property(nonatomic, assign) int order;         //订单数量

+(NSArray*)provinceList;
+(NSArray*)cityList:(NSString*)provinceId;
+(NSArray*)districtList:(NSString*)cityId;
+(Areas*)getArearWithId:(NSString*)Id;
@end
