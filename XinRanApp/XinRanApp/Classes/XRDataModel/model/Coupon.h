//
//  Coupon.h
//  XinRanApp
//
//  Created by tianbo on 14-12-9.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//
// 礼品券信息类

#import "BaseModel.h"

typedef NS_ENUM(int, CouponStatus) {
    CouponStatus_NoRecive = 0,              //未领取
    CouponStatus_Received = 1,              //已领取
    CouponStatus_Used = 2,                  //已使用
    CouponStatus_Invalid = 3,               //过期失效

};

@interface Coupon : BaseModel


@property(nonatomic, strong) NSString *Id;    	         //编号
@property(nonatomic, strong) NSString *start_date; 	     //创建时间
@property(nonatomic, strong) NSString *create_date; 	 //创建时间
@property(nonatomic, assign) CouponStatus status;      	 //状态
@property(nonatomic, strong) NSString *title;          	 //名字
@property(nonatomic, strong) NSString *image;	         //图片列表
@property(nonatomic, strong) NSArray *arImages;	         //图片列表

@property(nonatomic, strong) NSString *address;	         //领取地址
@property(nonatomic, assign) int num;	                         //数量
@property(nonatomic, strong) NSString *price;	         //价格
@property(nonatomic, strong) NSString *coupon_price;	 //礼品价格


//@property(nonatomic, assign) BOOL isTiming;

@end
