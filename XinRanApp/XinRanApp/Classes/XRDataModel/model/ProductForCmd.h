//
//  ProductForCmd.h
//  XinRanApp
//
//  Created by tianbo on 15-2-5.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//
//  首页返回的推荐商品类

#import "BaseModel.h"

//0未开始   1,3有剩余时间     2已结束
typedef NS_ENUM(int, ProductForCmdStatus) {
    ProductForCmdStatus_UnStart = 0,
    ProductForCmdStatus_Start = 1,
    ProductForCmdStatus_End = 2,
    ProductForCmdStatus_HasTime = 3
};

@interface ProductForCmd : BaseModel

@property(nonatomic, strong) NSString *Id;             //商品Did
@property(nonatomic, strong) NSString *dId;             //商品活动Did
@property(nonatomic, assign) int state;                 //0未开始   1,3有剩余时间     2已结束
@property(nonatomic, strong) NSString *title;
@property(nonatomic, assign) float price;              //价格
@property(nonatomic, assign) float priceOld;           //原价格
@property(nonatomic, strong) NSString *image;          //图片
@property(nonatomic, assign) int saled;                //
@property(nonatomic, assign) NSInteger seconds;        //剩余时间
@property(nonatomic, assign) int limit;                //限制数量

@end
