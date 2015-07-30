//
//  ConfigInfo.h
//  XinRanApp
//
//  Created by tianbo on 14-12-5.
//  Copyright (c) 2014年 deshan.com All rights reserved.
//
//  系统环境参数类

#import <Foundation/Foundation.h>
//#import "UserShipAddress.h"

@class User;
@class UserShipAddress;
@interface EnvPreferences : NSObject
{
    
}
//用户的收获地址数据信息
@property (nonatomic,strong) UserShipAddress *userShipAddress;

+(EnvPreferences*)sharedInstance;

//本地保存的app版本
-(NSString*)getAppVersion;
-(void)setAppVersion:(NSString*)version;

//用户登录信息
-(void)setToken:(NSString *)token;
-(NSString*)getToken;

-(void)setUserInfo:(User *)userInfo;
-(User*)getUserInfo;

//检查更新日期
-(void)setCheckData:(NSString*)data;
-(NSString*)getCheckData;

-(void)setAVersion:(NSString*)ver;
-(NSString*)getAVersion;
-(void)setBVersion:(NSString*)ver;
-(NSString*)getBVersion;
-(void)setCVersion:(NSString*)ver;
-(NSString*)getCVersion;
-(void)setWVersion:(NSString*)ver;
-(NSString*)getWVersion;

////用户收货地址
//-(void)setUserConsignee:(UserShipAddress*)addr;
//-(UserShipAddress*)getUserConsignee;
@end
