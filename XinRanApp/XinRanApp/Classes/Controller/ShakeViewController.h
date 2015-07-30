//
//  ShakeViewController.h
//  XinRanApp
//
//  Created by tianbo on 15-5-19.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "BaseUIViewController.h"

@interface ShakeViewController : BaseUIViewController


@property(nonatomic, assign) int remaindNum;   //剩余次数
@property(nonatomic, assign) int type;         //次数类型 1，按次  2，按天
@end
