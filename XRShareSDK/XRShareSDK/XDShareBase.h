//
//  XDPayBase.h
//  XinRanApp
//
//  Created by tianbo on 15-3-12.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//
//  支付基础类

#import <Foundation/Foundation.h>
#import "XDPayOrder.h"

typedef void (^ResultBlock)(int code);
@interface XDShareBase : NSObject

{
    
}
@property(nonatomic, copy)ResultBlock resultBlock;

/**
 *  注册
 */
-(void)registerApp:(NSString*)appId;

/**
 *  登录
 */
-(void)login;


/**
 *  支付
 */
-(void)payOrder:(XDPayOrder*)order;

-(void)payOrder:(XDPayOrder*)order result:(void(^)(int))result;
/**
 * 微信与支付宝支付返回码转换
 *
 */
-(PayError)returnCodeConversion:(int)returnCode;

/**
 *  设置回调url
 *
 *  @param url url
 */
//-(void)setHandleOpenUrl:(NSURL*)url;

-(void)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
-(void)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
@end
