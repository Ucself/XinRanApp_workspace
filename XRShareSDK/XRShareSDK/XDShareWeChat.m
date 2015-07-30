//
//  XDPayWeChat.m
//  XinRanApp
//
//  Created by tianbo on 15-3-12.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//
//  微信支付类

#import "XDShareWeChat.h"
#import "WXApi.h"
#import "payRequsestHandler.h"
#import "TenpayUtil.h"






@interface XDShareWeChat ()<WXApiDelegate>
{
    NSString *appId;
    NSString *secret;
    NSString *access_token;
    NSString *refresh_token;
    NSString *scope;
    NSString *openId;
    
    enum WXScene _scene;
    //Token
    NSString *Token;
    //Token valid time
    long      token_time;
}
@end

@implementation XDShareWeChat

-(void)dealloc
{
    self.resultBlock = nil;
}

/**
 *  类实例方法
 *
 *  @return 类实例
 */
+(XDShareWeChat*)instance
{
    static XDShareWeChat *instance = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        instance = [XDShareWeChat new];
    });
    
    return instance;
}

/**
 *  注册
 */
-(void)registerApp:(NSString*)appId
{
    [WXApi registerApp:appId withDescription:@"xinran_app"];
}

/**
 *  登录
 */
-(void)login
{
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"0744" ;
    [WXApi sendReq:req];
}

/**
 *  支付
 */
-(void)payOrder:(XDPayOrder*)order
{
//    XDWeChatOrder *or = (XDWeChatOrder*)order;
//    //调起微信支付
//    PayReq* req             = [[PayReq alloc] init];
//    req.openID              = or.appid;
//    req.partnerId           = or.partnerid;
//    req.prepayId            = or.prepayid;
//    req.nonceStr            = or.noncestr;
//    req.timeStamp           = [or.timestamp intValue];
//    req.package             = or.package;
//    req.sign                = or.sign;
//    [WXApi sendReq:req];
}

-(void)payOrder:(XDPayOrder*)order result:(void(^)(int))result
{
    self.resultBlock = result;
    
    if (![WXApi isWXAppInstalled]) {
        self.resultBlock(WXNotInstalled);
        return;
    }
    
    if (![WXApi isWXAppSupportApi]) {
        self.resultBlock(WXNotSupportApi);
        return;
    }
    
    XDWeChatOrder *or = (XDWeChatOrder*)order;
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = or.appid;
    req.partnerId           = or.partnerid;
    req.prepayId            = or.prepayid;
    req.nonceStr            = or.noncestr;
    req.timeStamp           = or.timestamp.intValue;
    req.package             = or.package;
    req.sign                = or.sign;
    
    
    [WXApi sendReq:req];
}

/**
 *  设置回调url
 *
 *  @param url url
 */
//-(void)setHandleOpenUrl:(NSURL*)url
//{
//    [WXApi handleOpenURL:url delegate:self];
//}

-(void)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [WXApi handleOpenURL:url delegate:self];
}

-(void)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - WXApiDelegate(optional)
-(void) onReq:(BaseReq*)req
{
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[PayResp class]]){
//        self.resultBlock(resp.errCode);
        //支付成功与失败的回调
        self.resultBlock([self returnCodeConversion:resp.errCode]);
        
        switch (resp.errCode) {
            case WXSuccess:
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                NSLog(@"支付错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    else if ([resp isKindOfClass:[SendAuthResp class]]) {
    }
    
}
@end
