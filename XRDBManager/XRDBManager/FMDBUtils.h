//
//  FMDBUtils.h
//  XinRanApp
//
//  Created by tianbo on 15-3-3.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMResultSet;
@interface FMDBUtils : NSObject

+(void)dropDB;

//创建数据库
+(BOOL)checkDB;
+(BOOL)createDB;

//得到数据库文件
+(NSString *)getDBFile;

//建表
+ (void)createTable:(NSString *)sql;

//根据Where删除数据
+ (BOOL)delete:(NSString *)deleteSql;

//查询
+ (void)query:(NSString *)querySql result:(void(^)(FMResultSet *rs))result;
//查询, 指定数据库文件
+ (void)query:(NSString *)querySql dbFile:(NSString*)dbFile result:(void(^)(FMResultSet *rs))result;

//插入数据
+(BOOL)insert:(NSString *)insertSql;

//插入数据
+(BOOL)insertWithArray:(NSMutableArray *)sqls;

//更新数据
+(BOOL)update:(NSString *)updateSql;

//插入数据
+(BOOL)updateWithArray:(NSMutableArray *)sqls;

//判断是否存在
+(BOOL)exist:(NSString *)existSql;
@end
