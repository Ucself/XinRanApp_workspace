//
//  ResultDataModel.h
//  XinRanApp
//
//  Created by tianbo on 14-12-9.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//
// 返回数据类

#import <Foundation/Foundation.h>

@interface ResultDataModel : NSObject

@property(nonatomic, assign) int requestType;
//结果码
@property(nonatomic, assign) int resultCode;
//描述信息
@property (nonatomic,copy) NSString *desc;
//返回业务数据
@property (nonatomic, strong) id data;


//初始化方法
-(id)initWithDictionary:(NSDictionary*)dict reqType:(int)reqestType;

-(id)initWithErrorInfo:(NSError*)error reqType:(int)reqestType;
@end
