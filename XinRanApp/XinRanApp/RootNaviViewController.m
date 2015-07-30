//
//  NaviViewController.m
//  XinRanApp
//
//  Created by tianbo on 15-1-13.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "RootNaviViewController.h"
#import "User.h"
#import "Whouse.h"
#import "Areas.h"
#import "GoodClass.h"
#import "Brand.h"
#import "EnvPreferences.h"
#import "NetInterfaceManager.h"
#import "ResultDataModel.h"

@interface RootNaviViewController ()

@end

@implementation RootNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //每次启动更新店铺
    //[[NetInterfaceManager sharedInstance] getAreawhouse];
    
    //注册网络请求通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(httpRequestFinished:) name:KNotification_RequestFinished object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(httpRequestFailed:) name:KNotification_RequestFailed object:nil];
    
    //自动登录,这个功能以后应该使用cookie实现
    User *user = [[EnvPreferences sharedInstance] getUserInfo];
    if (user && user.phone.length && user.pwd.length) {
        [[NetInterfaceManager sharedInstance] login:user.phone pwd:user.pwd type:LoginType_Email];
    }
    
    //获取商城基本信息
    [[NetInterfaceManager sharedInstance] getBSUP:[[EnvPreferences sharedInstance] getAVersion]
                                        w_version:[[EnvPreferences sharedInstance] getBVersion]
                                        c_version:[[EnvPreferences sharedInstance] getCVersion]
                                        b_version:[[EnvPreferences sharedInstance] getWVersion]];
    
    //根据版本号区分是否显示引导页
    NSString *locVer = [[EnvPreferences sharedInstance] getAppVersion];
    NSString *curVer = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if (locVer && [curVer isEqualToString:locVer]) {
        UIViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"MainController"];
        [self pushViewController:next animated:NO];
    }
    else {
        UIViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"GuideController"];
        [self pushViewController:next animated:NO];
        [[EnvPreferences sharedInstance] setAppVersion:curVer];
    }

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- http request handler
-(void)httpRequestFinished:(NSNotification *)notification
{
    DBG_MSG(@"enter");
    ResultDataModel *result = notification.object;
    if (!result) {
        DBG_MSG(@"http result is nil!");
        return;
    }
    
    switch (result.requestType) {
//        case KReqestType_Areawhouse:
//        {
//            if (result.resultCode == 0) {
//                //暂时每次登录先清除原来表数据(这里应该后台返回个标记是否有更新)
//                [Whouse clear];
//                [Areas clear];
//                
//                NSArray *arWhouses = result.attachData;
//                NSArray *arAreas = result.data;
//                
//                //更新数据库
//                for (Areas *area in arAreas) {
//                    [Areas addNewModel:area];
//                }
//                
//                for (Whouse *whouse in arWhouses) {
//                    [Whouse addNewModel:whouse];
//                }
//                
//            }
//            else {
//                DBG_MSG(@"http areawhouse failed!");
//            }
//            
//            
//        }
//            break;
        case KReqestType_BSUP:
        {
            if (result.resultCode == 0) {
                NSDictionary *dict = result.data;
                
                NSString *aVersion = [dict objectForKey:KJsonElement_AVersion];
                NSString *bVersion = [dict objectForKey:KJsonElement_BVersion];
                NSString *cVersion = [dict objectForKey:KJsonElement_CVersion];
                NSString *wVersion = [dict objectForKey:KJsonElement_WVersion];
                
                //更新区域信息
                if (aVersion) {
                    [[EnvPreferences sharedInstance] setAVersion:aVersion];
                    NSArray *array = [dict objectForKey:KJsonElement_Areas];
                    
                    [Areas clear];
                    for (Areas *area in array) {
                        [Areas addNewModel:area];
                    }
                }
                
                //更新品牌信息
                if (bVersion) {
                    [[EnvPreferences sharedInstance] setBVersion:bVersion];
                    NSArray *array = [dict objectForKey:KJsonElement_Brands];
                    
                    [Brand clear];
                    for (Brand *brand in array) {
                        [Brand addNewModel:brand];
                    }
                }
                
                //更新分类信息
                if (cVersion) {
                    [[EnvPreferences sharedInstance] setCVersion:cVersion];
                    NSArray *array = [dict objectForKey:KJsonElement_GClass];
                    
                    [GoodClass clear];
                    for (GoodClass *class in array) {
                        [GoodClass addNewModel:class];
                    }
                }
                
                //更新店铺信息
                if (wVersion) {
                    [[EnvPreferences sharedInstance] setWVersion:wVersion];
                    NSArray *array = [dict objectForKey:KJsonElement_Whouses];
                    
                    [Whouse clear];
                    for (Whouse *whouse in array) {
                        [Whouse addNewModel:whouse];
                    }
                }
                
            }
        }
            break;
        default:
            break;
    }
    
}

-(void)httpRequestFailed:(NSNotification *)notification
{
    //return [super httpRequestFailed:notification];
}

@end
