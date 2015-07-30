//
//  NetInterfaceManager.h
//  XinRanApp
//
//  Created by tianbo on 14-12-8.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NetInterfaceManager : NSObject


+(NetInterfaceManager*)sharedInstance;

/**
 *  设置网络请求标识
 *
 *  @param controller name
 */
-(void)setReqControllerId:(NSString*)cId;
-(NSString*)getReqControllerId;

/**
 *  重新加载一次数据
 */
-(void) reloadRecordData;

/**
 *  登录接口
 *
 *  @param name 用户手机号或邮箱
 *  @param pwd  密码
 *  @param type 1：手机号码；2：邮箱
 */
-(void)login:(NSString*)name pwd:(NSString*)pwd type:(int)type;

/**
 *  注册接口
 *
 *  @param name 用户手机号或邮箱
 *  @param pwd  密码
 *  @param type 1：手机号码；2：邮箱
 *  @param sphone 密保手机号码
 */
-(void)regist:(NSString*)name pwd:(NSString*)pwd type:(int)type sphone:(NSString*)sphone code:(NSString*)code;

/**
 *  注销接口
 */
-(void)logout;

/**
 *  修改密码
 *
 *  @param old  旧密码
 *  @param newp 新密码
 */
-(void)changePwd:(NSString*)old new:(NSString*)newp;

/**
 *  用户快速注册密码发送接口
 *
 *  @param phoneNumber 手机号码
 */
-(void)sendRgeSMS:(NSString*)çç;

/**
 *  用户礼品券接口
 *
 *  @param type 类型：0全部，1未领取，2已领取
 *  @param page 当前页，不传默认为第一页
 */
-(void)coupons:(int)type page:(int)page;

/**
 *  获取当前活动信息
 */
-(void)getAct;

/**
 *  获取商品详细情况信息
 *
 *  @param Id  商品id
 *  @param did 商品所在活动id
 */
-(void)getProductDetail:(NSString*)Id did:(NSString*)did;

/**
 *  获取门店和区域详细情况信息
 */
-(void)getAreawhouse;

/**
 *  发送短信验证码接口
 *
 *  @param phoneNumber 手机号码
 */
-(void)sendrcode:(NSString*)phoneNumber;

/**
 *  用于忘记密码重新设置密码
 *
 *  @param phoneNumber 手机号码
 *  @param code        验证码
 *  @param newPwd      新密码
 */
-(void)changePwdBCode:(NSString*)phoneNumber code:(NSString*)code newPwd:(NSString*)newPwd;

/**
 *  获取礼品券详情信息
 *
 *  @param Id 礼品券id
 */
-(void)getCouponDetail:(NSString*)Id;

/**
 *  发送礼品券验证码
 *
 *  @param Id 礼品券id
 */
-(void)sendgfcode:(NSString*)Id;

/**
 *  获取专题详细信息
 *
 *  @param terminalCode 终端类型：1安卓，2：ios，3安卓平板，4：ios平板
 *  @param activityId   专题活动id
 *  @param warehouseId  店铺id
 */
-(void)adetail:(NSString*)activityId warehouseid:(NSString*)warehouseId;

/**
 *  获取一个分类的所有商品信息
 *
 *  @param terminalCode 终端类型：1安卓，2：ios，3安卓平板，4：ios平板
 *  @param type         商品类型
 *  @param warehouseId  店铺id
 */
-(void)adetailClass:(int)type warehouseid:(NSString*)warehouseId;

/**
 *  验证短信验证码
 *
 *  @param phoneNumber 手机号码
 *  @param code        短信验证码
 */
-(void)checkCode:(NSString*)phoneNumber code:(NSString*)code;

/**
 *  购买
 *
 *  @param goodId 商品Id
 *  @param adwid  门店Id
 */
-(void)purchase:(NSString*)goodId adwid:(NSString*)adwid;

/**
 *  获取用户默认店铺
 */
-(void)getDefWhouse;

/**
 *  设置用户默认店铺
 *
 *  @param wid  店铺 id
 */
-(void)setDefWhouse:(NSString*)wid;

/**
 *  用户获取商城基本信息
 *
 *  @param a_version 区域版本号
 *  @param w_version 门店版本号
 *  @param c_version 分类版本号
 *  @param b_version 品牌版本号
 */
-(void)getBSUP:(NSString*)a_version
     w_version:(NSString*)w_version
     c_version:(NSString*)c_version
     b_version:(NSString*)b_version;

/**
 *  用户获取分类商品列表信息
 *
 *  @param cid     分类 id
 *  @param page    页码
 *  @param sort    排序类型： 1 价格降序， 2 价格升序， 3 上架时间升序， 4 上架时间升序， 5 点击升序， 6 点击升序
 *  @param branId  品牌 id
 */
-(void)goodsByClass:(NSString*)cId page:(int)page sort:(int)sort brandId:(NSString*)brandId;

/**
 *  获取普通商品详情
 *
 *  @param gId 商品id
 */
-(void)goods:(NSString*)gId;

/**
 *     用户获取活动专题商品列表信息
 *
 *  @param sId  专题 id
 *  @param wId  门店 id
 */
-(void)actGoodsList:(NSString*)sId wId:(NSString*)wId;

/**
 *      用户获取订单列表信息
 *
 *  @param type 类型 0 全部， 1 未领取， 2 已领取， 3 已取消
 *  @param page 页码
 */
-(void)myOrders:(int)type page:(int)page;

/**
 *   用户获取订单详情信息
 *
 *  @param Id 订单id
 */
-(void)orderDetail:(NSString*)Id;

/**
 *   用户取消订单
 *
 *  @param Id 订单id
 */
-(void)cancelOrder:(NSString*)Id;

/**
 *  获取首页相关信息
 *
 */
-(void)homeInfo;

/**
 *  常规商品购买
 *
 *  @param gid 商品id
 *  @param wid 店铺id
 *  @param num 购买数量
 *  @param consigneeId 收货人id
 *  @param payType 支付方式
 */
//-(void)commonBuy:(NSString*)gid wid:(NSString*)wid num:(int)num;
-(void)commonBuy:(NSString*)gId num:(int)num consigneeId:(NSString*)consigneeId payType:(int)payType;

/**
 *  秒杀购买
 *
 *  @param did 活动id
 *  @param wid 店铺id
 */
-(void)secKillBuy:(NSString*)did wid:(NSString*)wid;


/**
 *   获取收货 人信息列表
 */
-(void)getConsignee;

/**
 *   修改收货 人信息 接口
 *
 *  @param Id     Id
 *  @param name    收货人 名字
 *  @param areaId  收货人 所在区域 id
 *  @param addr    收货人详细 地址
 *  @param phone   收货 人电话
 */
-(void)updateConsignee:(NSString*)Id
                  name:(NSString*)name
                areaId:(NSString*)areaId
                  addr:(NSString*)addr
                 phone:(NSString*)phone;


/**
 *  确认收货接口
 *
 *  @param Id 订单id
 *
 */
-(void)finishOrder:(NSString*)Id;

/**
 *  微信支付接口
 *
 *  @param pdtName  商品名称
 *  @param price 总价
 *  @param orderId  订单id
 */
-(void)weixinPay:(NSString*)pdtName price:(NSString*)price orderId:(NSString*)orderId;

/**
 *  微信支付确认接品
 *
 *  @param orderId 订单id
 */
-(void)checkWXPay:(NSString*)orderId;
/**
 *  微信支付接口
 *
 *  @param pdtName  商品名称
 *  @param price 总价
 *  @param orderId  订单id
 */
-(void)aliPay:(NSString*)pdtName price:(NSString*)price orderId:(NSString*)orderId;


/*****************************************************
 Version 1.4
 *****************************************************/

/**
 *  抽奖活动接口
 *
 *  @param uid 用户id
 */
-(void)activityIndex:(NSString*)uid;

/**
 *  摇一摇接口
 *
 *  @param uid 用户id
 */
-(void)activityLottery:(NSString*)uid;

/**
 *  奖品列表接口
 *
 *  @param uid 用户id
 */
-(void)activityOrderList:(NSString*)uid page:(int)page;
@end
