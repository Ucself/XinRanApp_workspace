//
//  XDPayManager.h
//  XinRanApp
//
//  Created by tianbo on 15-3-12.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//
//  支付接口类

#import <Foundation/Foundation.h>
#import "XDPayOrder.h"

//支付通知结果
#define   KNotifyPayResult               @"NotifyPayResult"

typedef NS_ENUM(int, XSharePayType)
{
    PayType_Ali = 1,           //支付宝支付
    PayType_WeChat,            //微信支付
};

typedef NS_ENUM(int, XShareType)
{
    //PayType_WeChatLogin,     //微信登录
    ShareType_WeChat = 0,           //分享到微信
};



//typedef NS_ENUM(int, ShareType)
//{
//    ShareType_WeChat = 0,    //分享到微信
//};


#define KNotify

@class UIApplication;
@interface XDShareManager : NSObject

/**
 *  类实例方法
 *
 *  @return 类实例
 */
+(XDShareManager*)instance;

/**
 *  微信注册
 */
-(void)wechatRegister:(NSString*)appId;


/**
 *  支付宝注册
 */
-(void)aliRegister;


/**
 *  微信登录
 */
-(void)wechatLogin;


/**
 *  支付方法
 *
 *  @param type  支付类型
 *  @param block 构建订单信息block
 */
-(void)payWithType:(XSharePayType)type order:(void(^)(XDPayOrder *order))block;

-(void)payWithType:(XSharePayType)type order:(void(^)(XDPayOrder *order))orderBlock result:(void(^)(int))resultBlock;


/**
 *  分享方法
 *
 *  @param type  分享类型
 *  @param content 分享内容
 */
-(void)shareWithType:(XSharePayType)type content:(id)content;


/**
 *  微信,支付宝回调处理方法
 *
 *  @param application
 *  @param url
 */
-(void)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
-(void)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
@end
