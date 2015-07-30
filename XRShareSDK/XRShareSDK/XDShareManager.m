//
//  XDPayManager.m
//  XinRanApp
//
//  Created by tianbo on 15-3-12.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "XDShareManager.h"
#import "XDShareAli.h"
#import "XDShareWeChat.h"

@interface XDShareManager ()
{
    //XDPayBase *xdPay;
    
}

@property(nonatomic, strong) NSString *wechatAPPID;
@end

@implementation XDShareManager

/**
 *  类实例方法
 *
 *  @return 类实例
 */
+(XDShareManager*)instance
{
    static XDShareManager *instance = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        instance = [XDShareManager new];
    });
    
    return instance;
}

-(XDShareBase*)payInstanceWithType:(int)type
{
    XDShareBase *xdPay;
    switch (type) {
        case PayType_WeChat: {
            xdPay = [XDShareWeChat instance];
        }
            break;
        case PayType_Ali: {
            xdPay = [XDShareAli instance];
        }
            break;
        case ShareType_WeChat: {

        }
            break;
            
        default:
            break;
    }
    
    return xdPay;
}

/**
 *  微信注册
 */
-(void)wechatRegister:(NSString*)appId
{
    self.wechatAPPID = appId;
    [[XDShareWeChat instance] registerApp:appId];
}


/**
 *  支付宝注册
 */
-(void)aliRegister
{
    //[[XDPayAli instance] registerApp:@""];
}

-(void)wechatLogin
{
    [[XDShareWeChat instance] login];
}

-(void)payWithType:(XSharePayType)type order:(void(^)(XDPayOrder *order))block
{
    XDPayOrder *order;
    switch (type) {
        case PayType_Ali:
            order = [XDAliOrder new];
            break;
        case PayType_WeChat:
            order = [XDWeChatOrder new];
            break;
        default:
            break;
    }
    block(order);
    [[self payInstanceWithType:type] payOrder:order];
}

-(void)payWithType:(XSharePayType)type order:(void(^)(XDPayOrder *order))orderBlock result:(void(^)(int code))resultBlock;
{
    XDPayOrder *order;
    switch (type) {
        case PayType_Ali:
            order = [XDAliOrder new];
            break;
        case PayType_WeChat:
            order = [XDWeChatOrder new];
            break;
        default:
            break;
    }
    
    //生成订单数据
    orderBlock(order);
    
    //调用相应支付接口
    [[self payInstanceWithType:type] payOrder:order result:resultBlock];
}

/**
 *  分享方法
 *
 *  @param type  分享类型
 *  @param content 分享内容
 */
-(void)shareWithType:(XSharePayType)type content:(id)content
{
    
}

/**
 *  微信,支付宝回调处理方法
 *
 *  @param application
 *  @param url
 */
-(void)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [[XDShareWeChat instance] application:application handleOpenURL:url];
}

-(void)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *urls = [url absoluteString];
    if([urls rangeOfString:self.wechatAPPID].location !=NSNotFound) {
         [[XDShareWeChat instance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    else {
         [[XDShareAli instance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
   
   
}


@end
