//
//  GoodClass.h
//  XinRanApp
//
//  Created by tianbo on 15-2-5.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//
//  产品分类类

#import "BaseModel.h"

@interface GoodClass : BaseModel


@property(nonatomic, strong) NSString *Id;
@property(nonatomic, strong) NSString *parentId;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *iamgePath;
@property(nonatomic, assign) int sort;




//获取商品分类列表
+(NSArray*)getGoodClassWithParentId:(NSString*)parentId;
@end
