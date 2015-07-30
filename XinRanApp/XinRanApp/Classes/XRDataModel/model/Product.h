//
//  Product.h
//  XinRanApp
//
//  Created by tianbo on 14-12-8.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//
// 产品信息类

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "Whouse.h"

//0未开始   1     2已结束   3已抢完
typedef NS_ENUM(int, ProductStatus) {
    ProductStatus_UnStart = 0,
    ProductStatus_Start = 1,
    ProductStatus_End = 2,
    ProductStatus_GrabEnd = 3
};

typedef NS_ENUM(int, ProductLimitGrade)
{
    ProductLimitGrade_1 = 1,
    ProductLimitGrade_2,
    ProductLimitGrade_3,
    ProductLimitGrade_4,
};

@interface Product : BaseModel
{
    
}

@property(nonatomic, strong) NSString *Id;             //商品id
@property(nonatomic, strong) NSString *did;            //活动id
@property(nonatomic, assign) ProductStatus state;      //0未开始   1,3有剩余时间     2已结束
@property(nonatomic, strong) NSString *title;
@property(nonatomic, assign) float price;              //价格
@property(nonatomic, assign) float priceOld;      //活动价格1
@property(nonatomic, strong) NSString *desc;           //描述
@property(nonatomic, strong) NSString *image;          //图片
@property(nonatomic, strong) NSString *startDate;      //开始时间
@property(nonatomic, assign) NSInteger seconds;        //剩余时间
@property(nonatomic, strong) NSString *gc;             //分类类型
@property(nonatomic, assign) int comd;                 //是否推荐
@property(nonatomic, assign) int limit;                //限制数量
@property(nonatomic, assign) int limit_grades;         //限制会员等级

@property(nonatomic, assign) int sale;                 //销量，人气排序依据
@property(nonatomic, assign) NSInteger remaind;              //库存
@property(nonatomic, strong) NSString *agrades_name;

@property(nonatomic, strong) NSString *icon;
@property(nonatomic, strong) NSArray *arImages;
@property(nonatomic, strong) NSString *body;           //详细信息
@property(nonatomic, strong) NSString *video;          //媒体

//相关门店
@property(nonatomic, strong) NSMutableArray *arrayWhouses;

//判断后台返回聚合页和产品详情 状态字段不一致
//-(id)initWithDictionary:(NSDictionary*)dictionary bdetail:(BOOL)bdetail;

@end
