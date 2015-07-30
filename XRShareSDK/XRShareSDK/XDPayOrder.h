//
//  XDPayOrder.h
//  XinRanApp
//
//  Created by tianbo on 15-3-16.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//
//  支付订单类


//微信状态
typedef NS_ENUM(int, PayError)
{
    PaySuccess = 0,
    ErrCodeCommon           = -1,   /**< 普通错误类型    */
    ErrCodeUserCancel       = -2,   /**< 用户点击取消并返回    */
    ErrCodePayProcessing    = -7,   /**< 支付进行中   */
    
    WXNotInstalled = 0x010,
    WXNotSupportApi,
};

@interface XDPayOrder : NSObject

@property(nonatomic, strong) NSString *Id;
@property(nonatomic, strong) NSString *productName;
@property(nonatomic, strong) NSString *productDescription;
@property(nonatomic, strong) NSString *price;

@property(nonatomic, strong) NSString *signString;
@end


/*********************************************************************/
#pragma mark- 微信订单类
@interface XDWeChatOrder : XDPayOrder


//公众账号ID
@property (nonatomic, retain) NSString *appid;
//商户号
@property (nonatomic, retain) NSString *partnerid;
//预支付交易会话ID
@property (nonatomic, retain) NSString *prepayid;
//扩展字段
@property (nonatomic, retain) NSString *package;
//随机字符串
@property (nonatomic, retain) NSString *noncestr;
//时间戳
@property (nonatomic, retain) NSString *timestamp;
//签名
@property (nonatomic, retain) NSString *sign;

@end



/*********************************************************************/
#pragma mark- 支付宝订单类
@interface XDAliOrder : XDPayOrder


/*
 *商户的唯一的parnter和seller。
 *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
 */
//@property(nonatomic, strong) NSString *partner;
//@property(nonatomic, strong) NSString *seller;
//@property(nonatomic, strong) NSString *privateKey;
//@property(nonatomic, copy) NSString * partner;
//@property(nonatomic, copy) NSString * seller;
//@property(nonatomic, copy) NSString * tradeNO;
//@property(nonatomic, copy) NSString * amount;

//@property(nonatomic, copy) NSString * service;
//@property(nonatomic, copy) NSString * paymentType;
//@property(nonatomic, copy) NSString * inputCharset;
//@property(nonatomic, copy) NSString * itBPay;
//@property(nonatomic, copy) NSString * showUrl;
//@property(nonatomic, copy) NSString * notifyURL;
//
//@property(nonatomic, copy) NSString * rsaDate;//可选
//@property(nonatomic, copy) NSString * appID;//可选
//
//@property(nonatomic, readonly) NSMutableDictionary * extraParams;

@property (nonatomic,strong) NSString *aliDescription;

//编码化请求数据
//- (NSString *)description;

@end