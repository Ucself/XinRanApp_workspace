//
//  XDPayAli.m
//  XinRanApp
//
//  Created by tianbo on 15-3-12.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//
//  支付宝支付类

#import "XDShareAli.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"


@interface XDShareAli ()
{
    
}
@end


@implementation XDShareAli


/**
 *  类实例方法
 *
 *  @return 类实例
 */
+(XDShareAli*)instance
{
    static XDShareAli *instance = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        instance = [XDShareAli new];
    });
    
    return instance;
}

/**
 *  注册
 */
-(void)registerApp:(NSString*)appId
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
    self.resultBlock = result;
    XDAliOrder *or = (XDAliOrder*)order;
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"ali2088911514126033";
    if (or.aliDescription != nil) {
        [[AlipaySDK defaultService] payOrder:or.aliDescription fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
            //支付宝返回回调
            int code = [[resultDic objectForKey:@"resultStatus"] intValue];
            //回调
            self.resultBlock([self returnCodeConversion:code]);
        }];
    }
}

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
    if ([url.host isEqualToString:@"safepay"]) {
        
        NSLog(@"");
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                             NSLog(@"result = %@",resultDic);
//                                             NSString *resultStr = resultDic[@"result"];
                                         }];
        
    }
}
@end
