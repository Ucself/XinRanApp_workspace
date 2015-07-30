//
//  Order.h
//  XinRanApp
//
//  Created by tianbo on 14-12-16.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//
// 用户订单类

#import "BaseModel.h"

typedef NS_ENUM(int, OrderStatus) {
    OrderStatus_NotPayment = 10,              //未付款
    OrderStatus_Payment    = 20,              //已付款
    OrderStatus_Sent       = 30,              //已发货
    OrderStatus_Received   = 40,              //已收货
    OrderStatus_Commit     = 50,              //已提交
    OrderStatus_Confirm    = 60,              //已确认
    OrderStatus_Cancel     = 70,              //已取消
    OrderStatus_Invalid    = 80,              //已过期
    
};

//typedef NS_ENUM(int, EMPayType)
//{
//    PayType_Ali = 1,
//    PayType_Wechat,
//};

@interface Order : BaseModel




@property(nonatomic, strong) NSString *Id;    	         //订单id
@property(nonatomic, strong) NSString *adid; 	         //所属活动id
@property(nonatomic, strong) NSString *sn;	             //订单编号
@property(nonatomic, assign) OrderStatus status;      	 //状态

@property(nonatomic, strong) NSString *consignee;        //收货人
@property(nonatomic, strong) NSString *area_id;          //收货人区域id
@property(nonatomic, strong) NSString *address;          //收货地址，
@property(nonatomic, strong) NSString *phone;            //收货人电话，
@property(nonatomic, assign) int payment_id;       //支付方式，
@property(nonatomic, strong) NSString *payment_name;      //是否方式名称，
@property(nonatomic, strong) NSString *payment_time;     //支付时间，
@property(nonatomic, strong) NSString *shipping_company; //物流公司，
@property(nonatomic, strong) NSString *shipping_code;    //物流编号，
@property(nonatomic, strong) NSString *shipping_time;    //送货时间，
@property(nonatomic, strong) NSString *finnshed_time;    //订单完成时间
@property(nonatomic, strong) NSString *addTime; 	     //时间
@property(nonatomic, assign) float price;	             //价格
@property(nonatomic, strong) NSString *image;	         //图片
@property(nonatomic, strong) NSString *name;          	 //名字
@property(nonatomic, assign) int num;	                 //数量


@property(nonatomic, strong) NSMutableArray *arGoods;           //订单内商品

@end


@interface OrderPdt : BaseModel

@property(nonatomic, strong) NSString *Id;    	         //订单id
@property(nonatomic, strong) NSString *name;          	 //名字
@property(nonatomic, strong) NSString *desc;             //商品描述
@property(nonatomic, strong) NSString *image;	         //图片
@property(nonatomic, assign) int num;	                 //数量
@property(nonatomic, assign) float price;	             //价格


@end
