//
//  Brand.h
//  XinRanApp
//
//  Created by tianbo on 15-2-5.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//
//  品牌类

#import "BaseModel.h"

@interface Brand : BaseModel
{
    
}

@property(nonatomic, strong) NSString *Id;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *desc;

@end
