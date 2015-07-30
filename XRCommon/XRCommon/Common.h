//
//  Common.h
//  XinRanApp
//
//  Created by tianbo on 14-12-5.
//  Copyright (c) 2014年 deshan.com All rights reserved.
//
//  通用基础功能定义

#ifndef XinRanApp_Common_h
#define XinRanApp_Common_h



//颜色转换
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColor_DefGreen    UIColorFromRGB(0x00a489)
#define UIColor_DefOrange   UIColorFromRGB(0xff5700)
#define UIColor_Background  UIColorFromRGB(0xF2F2F2)

#define degreesToRadian(x) (M_PI * x / 180.0)

//#define DBG_MSG(msg, ...)\
//{\
//DBG_MSG(@"[ %@:(%d)] %@<-- %@ -->",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,[NSString stringWithUTF8String:__FUNCTION__], [NSString stringWithFormat:(msg), ##__VA_ARGS__]);\
//}

#ifdef DEBUG  // 调试阶段
#define DBG_MSG(msg, ...)\
{\
NSLog(@"%@ <- %@ ->",[NSString stringWithUTF8String:__FUNCTION__], [NSString stringWithFormat:(msg), ##__VA_ARGS__]);\
}
#else // 发布阶段
#define DBG_MSG(msg, ...)
#endif


#if __has_feature(objc_arc)
#define ShowMessage(X,Y) UIAlertView *t = [[UIAlertView alloc]initWithTitle:X message:Y delegate:nil \
cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] ; \
[t show];
#else
#define ShowMessage(X,Y) UIAlertView *t = [[UIAlertView alloc]initWithTitle:X message:Y delegate:nil \
cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] ; \
[t show];\
[t release];
#endif

#define SYSVERSION  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

#define ISIOS7LATER   ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 )
#define ISIOS8BEFORE   ( [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0 )
//设备的相关信息
#define deviceWidth  [UIScreen mainScreen].bounds.size.width
#define deviceHeight  [UIScreen mainScreen].bounds.size.height
#define deviceUUID  [[[UIDevice currentDevice] identifierForVendor] UUIDString]

#define KNotifyEnterBackGround   @"enterBackGround"
#define KNotifyBecomeActive      @"becomeActive"


#define KNotifyNetworkStatusChange     @"NetworkStatusChange"
typedef enum XNetworkStatus {
    NotNetwork = 0,
    NetworkViaWiFi,
    NetworkViaWWAN
} XNetworkStatus;


#endif
