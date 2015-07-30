//
//  ActivityListViewController.h
//  XinRanApp
//
//  Created by tianbo on 15-2-5.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ScrollingNavViewController.h"

@interface ActivityListViewController : ScrollingNavViewController


@property (nonatomic, strong) NSString *title;
@property (strong, nonatomic) id params;     //获取列表请求参数
@end
