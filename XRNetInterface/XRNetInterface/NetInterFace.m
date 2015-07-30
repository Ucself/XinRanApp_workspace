//
//  XRNetwork.m
//  XinRanApp
//
//  Created by tianbo on 14-12-5.
//  Copyright (c) 2014年 deshan.com All rights reserved.
//

#import "NetInterface.h"
#import "AFNetworking.h"
#import "AFURLRequestSerialization.h"
#import "AFURLResponseSerialization.h"

#import <XRCommon/JsonUtils.h>

@interface NetInterface ()

@property (nonatomic, retain) NSString *curUrl;
@property (nonatomic, retain) NSString *curBody;
@end



@implementation NetInterface

+ (NetInterface*)sharedInstance
{
    static NetInterface *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

-(instancetype)init
{
    self = [super init];
    if (self) {

    }
    
    return self;
}


#pragma mark-
- (int)reach
{
    __block int ret = 0;
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        DBG_MSG(@"%ld", status);
        ret = status;
    }];
    
    return ret;
}


- (void)httpPostRequest:(NSString*)strUrl
                   body:(NSString*)strBody
           suceeseBlock:(void(^)(NSString*))suceese
            failedBlock:(void(^)(NSError*))failed
{
    //初始化http
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    //设置token
    if (self.token && self.token.length>0) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"token %@", self.token] forHTTPHeaderField:@"Authorization"];
        DBG_MSG(@"http reqest header: %@", manager.requestSerializer.HTTPRequestHeaders);
    }
    
    DBG_MSG(@"http post request url=%@",strUrl);
    DBG_MSG(@"http post request body=%@",strBody);
    
    //请求json内容
    NSDictionary *parameters = nil;
    if(strBody && strBody.length>0) {
        parameters = [JsonUtils jsonToDcit:strBody];//[JsonBuilder dictionaryWithJson:strBody decode:NO key:nil];
    }

    //发送请求
    [manager POST:strUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = responseObject;
        NSString *strings =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        DBG_MSG(@"Http response string: %@", strings);
        
        if (suceese) {
            suceese(strings);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DBG_MSG(@"Http reqest error: %@", error);
        
        if (failed) {
            failed(error);
        }
    }];
}

- (void)httpGetRequest:(NSString*)strUrl
                  body:(NSString*)strBody
          suceeseBlock:(void(^)(NSString* msg))suceese
           failedBlock:(void(^)(NSError* msg))failed
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    //设置token

    if (self.token && self.token.length>0) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"token %@", self.token] forHTTPHeaderField:@"Authorization"];
        DBG_MSG(@"http reqest header: %@", manager.requestSerializer.HTTPRequestHeaders);
    }
    
    DBG_MSG(@"http get request url=%@",strUrl);
    DBG_MSG(@"http get request body=%@",strBody);
    
    //请求json内容
    NSDictionary *parameters = nil;
    if(strBody && strBody.length>0) {
        parameters = [JsonUtils jsonToDcit:strBody];//[JsonBuilder dictionaryWithJson:strBody decode:NO key:nil];
    }
    [manager GET:strUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = responseObject;
        NSString *strings =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        DBG_MSG(@"Http response string: %@", strings);
        
        if (suceese) {
            suceese(strings);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DBG_MSG(@"Http reqest error: %@", error);
        
        if (failed) {
            failed(error);
        }
        
    }];

}



@end
