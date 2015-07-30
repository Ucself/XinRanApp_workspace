//
//  BaseModel.h
//  XinRanApp
//
//  Created by tianbo on 14-12-5.
//  Copyright (c) 2014年 deshan.com All rights reserved.
//
// 基础数据类

#import <Foundation/Foundation.h>
#import <XRDBManager/FMResultSet.h>


@interface BaseModel : NSObject <NSCoding, NSCopying>
{
    
}

//初始化方法
-(id)initWithDictionary:(NSDictionary*)dictionary;


//解析字典，字典中key的名字必须与类的属性名相同
-(void) parseDictionary:(NSDictionary*)dictionary;

//将对象属性封装到字典，并返回字典
-(NSDictionary *)propertyDictionary;


//创建对象
- (BaseModel *)createBean:(FMResultSet *) stmt;

//表名
+ (NSString * ) tableName;

//建表sql
+ (NSString * ) createTableSql;
+(void)executeCreate:(NSString*)sql;

//建表
+ (void)createTable;

//清除表所有数据
+(BOOL)clear;

//添加新条目
+ (void)addNewModel:(BaseModel*)model;

//数据库插入
+ (BOOL)insert:(NSString *)insertSql;
+ (BOOL)insertWithArray:(NSMutableArray *)sqls;

//数据库插入sql
- (NSString *)insertSql:(NSString *)values ;

//数据库更新
+ (BOOL)update:(NSString *)set where:(NSString *)where ;
+ (BOOL)updateWithArray:(NSMutableArray *)sqls;

//数据库更新sql
+ (NSString *)updateSql:(NSString *)set where:(NSString *)where;

//数据库删除
+ (BOOL)remove:(NSString *)where ;

//是否存在
+(BOOL)exist:(NSString *)where;

//查询结果集
+(NSArray *)query:(NSString *)select  where:(NSString *)where;
+(NSArray *)query:(NSString *)select where:(NSString *)where dbFile:(NSString*)dbFile;
+(NSArray *)queryAllSql:(NSString *)select  dbFile:(NSString*)dbFile;

+(NSArray*)modelList;
@end
