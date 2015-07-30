//
//  MyOrderViewController.h
//  XinRanApp
//
//  Created by mac on 14/12/16.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//
// 我的礼品券

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
#import "ScrollingNavViewController.h"

typedef NS_ENUM(int, statusType) {
    statusType_All = 0,                   //全部
    statusType_NoRecive = 1,              //待领取
    statusType_Received = 2,              //已领取
    statusType_Cancel = 3,               //已取消
    
};
@interface MyOrderViewController : ScrollingNavViewController


@end
