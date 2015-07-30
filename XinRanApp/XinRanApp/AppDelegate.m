//
//  AppDelegate.m
//  XinRanApp
//
//  Created by tianbo on 14-12-4.
//  Copyright (c) 2014年 deshan.com All rights reserved.
//

#import "AppDelegate.h"

//#import "MobClick.h"
#import <XRShareSDK/MobClick.h>
#import <XRShareSDK/XDShareManager.h>

#import <XRCommon/Reachability.h>
#import <XRCommon/JsonUtils.h>
#import <XRCommon/DateUtils.h>
#import "DBHelper.h"
#import "EnvPreferences.h"



/******************************************************
 *  UM SDK Key
 ******************************************************/
#define UMENG_APPKEY @"5576b56667e58e20da002d44"

//微信appid
#define WXAPPID @"wx4764538ac5db617a"

@interface AppDelegate () <UIAlertViewDelegate>
{
    Reachability *internetReachability;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (1) {
        //显示广告
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *mainViewController = [storyboard instantiateInitialViewController];
        self.window.rootViewController = mainViewController;
        [self.window makeKeyAndVisible];
        
        UIImageView *adView = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        [adView setImage:[UIImage imageNamed:@"default"]];
        [self.window addSubview:adView];
        [self.window bringSubviewToFront:adView];
        
        [NSThread sleepForTimeInterval:1];
        [UIView animateWithDuration:1.0 animations:^{
            CGAffineTransform newTransform = CGAffineTransformMakeScale(1.2, 1.2);
            adView.transform = newTransform;
            adView.alpha = 0;
        } completion:^(BOOL finished) {
            [adView removeFromSuperview];
        }];
    }
    
    
    

    //初始化数据库
    [self initDatabase];
    
    //UM 统计
    [self umengTrack];
    
    
    //注册微信支付宝
    [[XDShareManager instance] wechatRegister:WXAPPID];
//    [[XDPayManager instance] aliRegister];
    
    //打开网络状态监测
    [self networkMonitor];
    
    //打印沙盒地址
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    DBG_MSG(@"%@",paths);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotifyEnterBackGround object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotifyEnterBackGround object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotifyBecomeActive object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotifyBecomeActive object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //设置回调方法
    [[XDShareManager instance] application:application handleOpenURL:url];
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //设置回调方法
    [[XDShareManager instance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return YES;
}

#pragma mark- 
-(void) initDatabase
{
    [DBHelper initDB];
}

#pragma mark- 网络状态监测
-(void)networkMonitor
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    internetReachability = [Reachability reachabilityForInternetConnection];
    [internetReachability startNotifier];
    [self updateInterfaceWithReachability:internetReachability];   //执行一次网络监测
}

- (void) reachabilityChanged:(NSNotification *)notification
{
    Reachability* curReach = [notification object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    self.netStatus = (XNetworkStatus)netStatus;
}

#pragma mark - 友盟sdk方法
- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    //    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    DBG_MSG(@"online config has fininshed and note = %@", note.userInfo);
}


@end
