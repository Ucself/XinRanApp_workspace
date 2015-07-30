//
//  JsonBuilder.h
//  XinRanApp
//
//  Created by tianbo on 14-12-8.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonBuilder : NSObject
{
    
}

+(JsonBuilder*)sharedInstance;

/**
 *  设置加解密密钥
 *
 *  @param key 密钥
 */
-(void)setCryptKey:(NSString*)key;


//解析json
///////////////////////////////////////////////////////////////

/**
*  解析json数据
*
*  @param json     json字符串
*  @param isDecode 是否需要解密
*  @param key      密钥
*
*  @return dictionary
*/
+(NSDictionary*)dictionaryWithJson:(NSString*)json decode:(BOOL)isDecode key:(NSString*)key;

/**
 *  initAndPlay
 *
 *  @param json     json字符串
 *  @param isDecode 是否需要解密
 *  @param key      密钥
 *
 *  @return string
 */
+(NSString*)stringWithJson:(NSString*)json decode:(BOOL)isDecode key:(NSString*)key;

/**
 *  解析token字符串
 *
 *  @param json     josn字符串
 *  @param isDecode 是否需要解密
 *  @param key      密钥
 *
 *  @return return value description
 */
+(NSString*)tokenStringWithJosn:(NSString*)json decode:(BOOL)isDecode key:(NSString*)key;


//生成
///////////////////////////////////////////////////////////////

/**
 *  生成json字符串
 *
 *  @param dict 字典
 *
 *  @return json字符串
 */
+(NSString*)jsonWithDictionary:(NSDictionary*)dict;




//生成请求json数据
///////////////////////////////////////////////////////////////

-(NSString*)jsonWithLogin:(NSString*)name pwd:(NSString*)pwd type:(int)type;

-(NSString*)jsonWithRegister:(NSString*)name pwd:(NSString*)pwd type:(int)type sphone:(NSString*)sphone code:(NSString*)code;

-(NSString*)jsonWithLogout;

-(NSString*)jsonWithChangePwd:(NSString*)oldPwd new:(NSString*)newPwd;

-(NSString*)jsonWithSendRgeSMS:(NSString*)phoneNumber;

-(NSString*)jsonWithCoupons:(int)type page:(int)page;

-(NSString*)jsonWithGetAct;

-(NSString*)jsonWithGetProductDetail:(NSString*)Id did:(NSString*)did;

-(NSString*)jsonWithGetAreawhouse;

-(NSString*)jsonWithSendrcode:(NSString*)phoneNumber;

-(NSString*)jsonWithChangePwdBCode:(NSString*)phoneNumber code:(NSString*)code newPwd:(NSString*)newPwd;

-(NSString*)jsonWithGetCouponDetail:(NSString*)Id;

-(NSString*)jsonWithSendgfcode:(NSString*)Id;

-(NSString*)jsonWithAdetail:(NSString*)activityId warehouseid:(NSString*)warehouseId;

-(NSString*)jsonWithAdetailClass:(int)type warehouseid:(NSString*)warehouseId;

-(NSString*)jsonWithCheckCode:(NSString*)phoneNumber code:(NSString*)code;

-(NSString*)jsonWithPurchase:(NSString*)goodsid adwid:(NSString*)adwid;

//获取用户默认店铺 接口
-(NSString*)jsonWithGetDefWHouse;

// 设置用户默认店铺 接口
-(NSString*)jsonWithSetDefWHouse:(NSString*)wid;

// 用户获取商城基本信息 接口
-(NSString*)jsonWithBSUP:(NSString*)a_version
               w_version:(NSString*)w_version
               c_version:(NSString*)c_version
               b_version:(NSString*)b_version;

// 用户获取分类商品列表信息 接口
-(NSString*)jsonWithGoodsByClass:(NSString*)cId
                            page:(int)page
                            sort:(int)sort
                         brandId:(NSString*)brandId;

// 用户获取分类商品详细信息 接口
-(NSString*)jsonWithGoods:(NSString*)gId;

// 用户获取活动专题商品列表信息 接口
-(NSString*)jsonWithActGoodsList:(NSString*)sId wId:(NSString*)wId;

// 用户获取订单列表信息 接口
-(NSString*)jsonWithMyOrders:(int)type page:(int)page;

// 用户获取订单详情信息 接口
-(NSString*)jsonWithOrderDetail:(NSString*)Id;

// 用户取消订单 接口
-(NSString*)jsonWithCancelOrder:(NSString*)Id;

/*****************************************************
 Version 1.1
 *****************************************************/

// 获取首页信息
-(NSString*)jsonWithHomeInfo;

// 常规商品购买
-(NSString*)jsonWithBuy:(NSString*)gId wId:(NSString*)wId num:(int)num;
// 常规商品购买  添加收货地址id, 支付类型
-(NSString*)jsonWithBuy2:(NSString*)gId num:(int)num consigneeId:(NSString*)consigneeId payType:(int)payType;

// 秒杀商品购买
-(NSString*)jsonWithSecKillBuy:(NSString*)dId wId:(NSString*)wId;

/*****************************************************
 Version 1.3
 *****************************************************/

//获取收货 人信息列表
-(NSString*)jsonWithGetConsignee;

//修改收货 人信息 接口
-(NSString*)jsonWithUpdateConsignee:(NSString*)Id
                  name:(NSString*)name
                areaId:(NSString*)areaId
                  addr:(NSString*)addr
                 phone:(NSString*)phone;

//确认收货接口
-(NSString*)jsonWithFinishOrder:(NSString*)Id;

//微信支付接口
-(NSString*)jsonWithweixinPay:(NSString*)pdtName price:(NSString*)price orderId:(NSString*)orderId;

//确认微信支付接口
-(NSString*)jsonWithCheckWxPay:(NSString*)orderId;


/*****************************************************
 Version 1.4
 *****************************************************/

//抽奖活动接口
-(NSString*)jsonWithActivityIndex:(NSString*)userId;

//摇一摇接口
-(NSString*)jsonWithActivityLottery:(NSString*)userId;

//奖品列表接口
-(NSString*)jsonWithActivityOrderList:(NSString*)userId page:(int)page;

@end
