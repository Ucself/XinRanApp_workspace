//
//  HomeInfoCache.m
//  XinRanApp
//
//  Created by tianbo on 14-12-18.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "HomeInfoCache.h"
#import <XRCommon/FileManager.h>

@interface HomeInfoCache ()
{
    NSMutableDictionary *dictHome;
}

@end

@implementation HomeInfoCache


+(HomeInfoCache*)sharedInstance
{
    static HomeInfoCache *instance = nil;
    static dispatch_once_t once;
    _dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}


-(void)save
{
    //{{modify by 20150122 tianbo 后台写入数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *fullPath = [FileManager fileFullPathAtDocumentsDirectory:@"HomeInfoCache.plist"];
        if (![NSKeyedArchiver archiveRootObject:dictHome toFile:fullPath]) {
            DBG_MSG(@"wirte file 'Preferences.plist' failed!");
        }
    });
    //}}
}

-(id)init
{
    self = [super init];
    if ( !self )
        return nil;
    
    NSString *fullPath = [FileManager fileFullPathAtDocumentsDirectory:@"HomeInfoCache.plist"];
    dictHome = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
    //dictHome = [[NSMutableDictionary alloc] initWithContentsOfFile:fullPath];
    
    if (dictHome == nil)
    {
        dictHome = [[NSMutableDictionary alloc] init];
    }
    return self;
}


-(void)setHomeInfo:(NSDictionary*)dict
{
    dictHome = [NSMutableDictionary dictionaryWithDictionary:dict];
    //[self save];
    [self performSelectorInBackground:@selector(save) withObject:nil];
}

-(NSDictionary*)getHomeInfo
{
    return dictHome;
}

@end
