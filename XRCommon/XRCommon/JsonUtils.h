//
//  JsonUtils.h
//  XinRanApp
//
//  Created by tianbo on 14-12-5.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonUtils : NSObject

/**
 *  字典转为json
 *
 *  @param dcit 字典类型数据
 *
 *  @return json字符串
 */
+ (NSString*) dictToJson:(NSDictionary*)dcit;

/**
 *  json字符串转为字典
 *
 *  @param json json字符串
 *
 *  @return 字典类型数据
 */
+ (NSDictionary*) jsonToDcit:(NSString*)json;

/**
 *  json data 转为字典
 *
 *  @param json json data
 *
 *  @return 字典类型数据
 */
+ (NSDictionary*) jsonDataToDcit:(NSData *)data;
@end
