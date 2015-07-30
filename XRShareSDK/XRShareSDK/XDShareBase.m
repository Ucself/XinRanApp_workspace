//
//  XDPayBase.m
//  XinRanApp
//
//  Created by tianbo on 15-3-12.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "XDShareBase.h"
#import "XDPayOrder.h"


@implementation XDShareBase

/**
 *  注册
 */
-(void)registerApp:(NSString*)appId
{

}

/**
 *  登录
 */
-(void)login
{
    
}

/**
 *  支付
 */
-(void)payOrder:(XDPayOrder*)order
{
    
}

-(void)payOrder:(XDPayOrder*)order result:(void(^)(int))result
{
    
}
/**
 * 微信与支付宝支付返回码转换
 *
 */
-(PayError)returnCodeConversion:(int)returnCode{
    PayError payReturn;
    switch (returnCode) {
        case 9000:
            payReturn = PaySuccess; //支付宝的成功
            break;
        case 8000:
            payReturn = ErrCodePayProcessing; //支付宝正在处理
            break;
        case 4000:
            payReturn = ErrCodeCommon; //支付宝支付失败
            break;
        case 6001:
            payReturn = ErrCodeUserCancel; //支付宝用户中途取消
            break;
        case 6002:
            payReturn = ErrCodeCommon; //支付宝用户网络错误的失败
            break;
        case 0:
            payReturn = PaySuccess; //微信支付的成功
            break;
        case -1:
            payReturn = ErrCodeCommon; //微信支付的普通错误
            break;
        case -2:
            payReturn = ErrCodeUserCancel; //微信支付用户中途取消
            break;
        case -3:
            payReturn = ErrCodeCommon; //微信支付发送失败
            break;
        case -4:
            payReturn = ErrCodeCommon; //微信支付注册授权失败
            break;
        case -5:
            payReturn = ErrCodeCommon; //微信支付不支持
            break;
        default:
            break;
    }
    
    return payReturn;
}

//WXSuccess           = 0,    /**< 成功    */
//WXErrCodeCommon     = -1,   /**< 普通错误类型    */
//WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
//WXErrCodeSentFail   = -3,   /**< 发送失败    */
//WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
//WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
/**
 *  设置回调url
 *
 *  @param url url
 */
//-(void)setHandleOpenUrl:(NSURL*)url
//{
//    
//}

-(void)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
}

-(void)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
}
@end
