//
//  ConfigInfo.m
//  XinRanApp
//
//  Created by tianbo on 14-12-5.
//  Copyright (c) 2014年 deshan.com All rights reserved.
//

#import "EnvPreferences.h"
#import "User.h"
//#import <XRCommon/XRCommon.h>
#import <XRCommon/FileManager.h>

@interface EnvPreferences ()
{
    NSMutableDictionary  *preDict;
    
}

@property (copy, nonatomic) NSString *token;
@end


@implementation EnvPreferences

+(EnvPreferences*)sharedInstance
{
    static EnvPreferences *instance = nil;
    static dispatch_once_t once;
    _dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}


-(void)save
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *fullPath = [FileManager fileFullPathAtDocumentsDirectory:@"Preferences.plist"];
        
        if (![NSKeyedArchiver archiveRootObject:preDict toFile:fullPath]) {
            DBG_MSG(@"wirte file 'Preferences.plist' failed!");
        }
    });
    //[FileManager writeToFile:preDict fileName:@"Preferences.plist"];
}

-(id)init
{
    self = [super init];
    if ( !self )
        return nil;
    
//    NSString *fullPath = [FileManager fileFullPathAtDocumentsDirectory:@"Preferences.plist"];
//    preDict = [[NSMutableDictionary alloc] initWithContentsOfFile:fullPath];
    NSString *fullPath = [FileManager fileFullPathAtDocumentsDirectory:@"Preferences.plist"];
    preDict = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
    if (preDict == nil)
    {
        preDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}


-(void)dealloc
{
    [self save];
}


#pragma mark-

-(NSString*)getAppVersion
{
    NSString *version = [preDict valueForKey:@"Version"];
    DBG_MSG(@"The local version is %@", version);
    return version;
}

-(void)setAppVersion:(NSString*)version
{
    [preDict  setValue:version forKey:@"Version"];
    [self save];
}


-(void)setToken:(NSString *)token
{
    //[preDict  setValue:token forKey:@"token"];
    //[self save];
    if (![_token isEqualToString:token]) {
        _token = token;
    }
}

-(NSString*)getToken
{
    //return [preDict objectForKey:@"token"];
    return self.token;
}

-(void)setUserInfo:(User *)userInfo
{
//    User *user = [preDict objectForKey:@"userInfo"];
//    if (user) {
//        if (userInfo.userId) {
//            user.userId = userInfo.userId;
//        }
//        if (userInfo.username) {
//            user.username = userInfo.username;
//        }
//        if (userInfo.phone) {
//            user.phone = userInfo.phone;
//        }
//        if (userInfo.email) {
//            user.email = userInfo.email;
//        }
//        if (userInfo.grades) {
//            user.grades = userInfo.grades;
//        }
//    }
//    else {
//        [preDict setValue:userInfo forKey:@"userInfo"];
//    }
    
    [preDict setValue:userInfo forKey:@"userInfo"];
    [self save];
}

-(User*)getUserInfo
{
    return [preDict objectForKey:@"userInfo"];
}

//检查更新日期
-(void)setCheckData:(NSString*)data
{
    [preDict setValue:data forKey:@"CheckData"];
    [self save];
}

-(NSString*)getCheckData
{
    return [preDict objectForKey:@"CheckData"];
}


-(void)setAVersion:(NSString*)ver
{
    [preDict setValue:ver forKey:@"AVersion"];
    [self save];
}
-(NSString*)getAVersion
{
    return [preDict objectForKey:@"AVersion"];
}
-(void)setBVersion:(NSString*)ver
{
    [preDict setValue:ver forKey:@"BVersion"];
    [self save];
}
-(NSString*)getBVersion
{
    return [preDict objectForKey:@"BVersion"];
}
-(void)setCVersion:(NSString*)ver
{
    [preDict setValue:ver forKey:@"CVersion"];
    [self save];
}
-(NSString*)getCVersion
{
    return [preDict objectForKey:@"CVersion"];
}
-(void)setWVersion:(NSString*)ver
{
    [preDict setValue:ver forKey:@"WVersion"];
    [self save];
}
-(NSString*)getWVersion
{
    return [preDict objectForKey:@"WVersion"];
}

//-(void)setUserConsignee:(UserShipAddress*)addr
//{
//    [preDict setValue:addr forKey:@"UserConsignee"];
//}
//-(UserShipAddress*)getUserConsignee
//{
//    return [preDict objectForKey:@"UserConsignee"];
//}
@end
