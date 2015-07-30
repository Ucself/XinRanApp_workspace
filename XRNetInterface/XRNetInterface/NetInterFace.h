//
//  XRNetwork.h
//  XinRanApp
//
//  Created by tianbo on 14-12-5.
//  Copyright (c) 2014年 deshan.com All rights reserved.
//
//
//  网络通信类

#import <Foundation/Foundation.h>

@interface NetInterface : NSObject
{
    
}

@property(nonatomic, strong) NSString *token;

//实例化
+ (NetInterface*)sharedInstance;

/**
 *  检测当前网络状态
 *
 *  @return 0：没有网络  1：移动数据  2：WIFI
 */
- (int)reach;

/**
 *  发送http post请求
 *
 *  @param strUrl  url
 *  @param strBody 发送内容
 *  @param suceese 成功回调
 *  @param failed  失败回调
 */

- (void)httpPostRequest:(NSString*)strUrl
                   body:(NSString*)strBody
           suceeseBlock:(void(^)(NSString* msg))suceese
            failedBlock:(void(^)(NSError* msg))failed;

/**
 *  发送http get请求
 *
 *  @param strUrl  url
 *  @param strBody 发送内容
 *  @param suceese 成功回调
 *  @param failed  失败回调
 */
- (void)httpGetRequest:(NSString*)strUrl
                   body:(NSString*)strBody
           suceeseBlock:(void(^)(NSString* msg))suceese
            failedBlock:(void(^)(NSError* msg))failed;

@end
