//
//  Ads.h
//  XinRanApp
//
//  Created by tianbo on 14-12-17.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//
// 广告类

#import "BaseModel.h"

@interface Ads : BaseModel

@property (nonatomic, strong) NSString *picAddr;
@property (nonatomic, strong) NSString *linkUrl;
@property (nonatomic, assign) int type;
@end
