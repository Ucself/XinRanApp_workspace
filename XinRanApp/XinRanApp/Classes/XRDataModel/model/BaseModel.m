//
//  BaseModel.m
//  XinRanApp
//
//  Created by tianbo on 14-12-5.
//  Copyright (c) 2014年 deshan.com All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>
#import <XRDBManager/FMDBUtils.h>


@implementation BaseModel

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        [self parseDictionary:dictionary];
    }
    
    return self;
    
}

//解析字典，字典中key的名字必须与类的属性名相同
-(void) parseDictionary:(NSDictionary*)dictionary
{
    if ([dictionary isKindOfClass:[NSNull class]] || !dictionary) {
        return;
    }
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i=0; i<outCount; i++) {
        //属性转为字符串
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        //DBG_MSG(@"property[%d] :%@ \n", i, key);
        
        id value = [dictionary objectForKey:key];
        if (![value isKindOfClass:[NSNull class]] && value) {
            key = [NSString stringWithFormat:@"_%@", key];
            
            //设置属性值
            //objc_property_t pt = class_getProperty(self, key.UTF8String);
            [self setValue:value forKey:key];
            //Ivar ivar = object_getInstanceVariable(self, key.UTF8String, NULL);
            //object_setIvar(self, ivar, value);
        }
    }
    
    free(properties);
}

//将对象属性封装到字典，并返回字典
-(NSDictionary *)propertyDictionary
{
    //创建字典
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_t *props = class_copyPropertyList([self class], &outCount);
    for(int i=0;i<outCount;i++){
        objc_property_t prop = props[i];
        NSString *propName = [[NSString alloc]initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
        id propValue = [self valueForKey:propName];
        if(propValue){
            [dict setObject:propValue forKey:propName];
        }
    }
    
    free(props);
    return dict;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
    }
    return  self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id copyInstance = [[[self class] allocWithZone:zone] init];
    size_t instanceSize = class_getInstanceSize([self class]);
    memcpy((__bridge void *)(copyInstance), (__bridge const void *)(self), instanceSize);
    return copyInstance;
}

#pragma mark- database support
- (BaseModel *)createBean:(FMResultSet *) stmt{
    return nil;
}
//创建对象
//- (BaseModel *)createBeanBySqlite:(sqlite3_stmt *)stmt{
//    return nil;
//}

//建表
+ (void)createTable{
    NSString *sql = [self createTableSql];
    [self executeCreate:sql];
}

+(void)executeCreate:(NSString*)sql
{
    [FMDBUtils createTable:sql];
}

//表名
+ (NSString * ) tableName{
    return @"";
}

//建表sql
+ (NSString * ) createTableSql{
    return @"";
}

//添加新条目
+ (void)addNewModel:(BaseModel*)model{
    
}
//清除表所有数据
+(BOOL)clear
{
    NSString *deleteSQL = [@"DELETE from " stringByAppendingString:[self tableName]];
    return [FMDBUtils delete:deleteSQL];
}


//数据库删除
+ (BOOL)remove:(NSString *)where {
    
    NSString *deleteSQL = [@"DELETE from " stringByAppendingString:[[self tableName] stringByAppendingString:where]];
    return [FMDBUtils delete:deleteSQL];
}

//数据库插入
+ (BOOL)insert:(NSString *)insertSql {
    
    NSString *sql = [@"insert into " stringByAppendingString:[[self tableName] stringByAppendingString:insertSql]];
    
    return [FMDBUtils insert:sql];
}

+ (BOOL)insertWithArray:(NSMutableArray *)sqls{
    return [FMDBUtils insertWithArray:sqls];
}


//数据库插入SQL
- (NSString *)insertSql:(NSString *)values {
    
    NSString *sql = [@"insert into " stringByAppendingString:[[BaseModel tableName] stringByAppendingString:values]];
    
    return sql;
}

//数据库更新
+ (BOOL)update:(NSString *)set where:(NSString *)where {
    
    NSString *updateSQL = [[[@"update " stringByAppendingString: [self tableName]] stringByAppendingString:set] stringByAppendingString:where];
    
    return [FMDBUtils update:updateSQL];
}

+ (BOOL)updateWithArray:(NSMutableArray *)sqls{
    return [FMDBUtils updateWithArray:sqls];
}

//数据库更新SQL
+ (NSString *)updateSql:(NSString *)set where:(NSString *)where {
    
    NSString *updateSQL = [[[@"update " stringByAppendingString: [self tableName]] stringByAppendingString:set] stringByAppendingString:where];
    
    return updateSQL;
}

//是否存在
+(BOOL)exist:(NSString *)where{
    NSString *existSql = [@"select 1 from " stringByAppendingString:[[self tableName] stringByAppendingString:where]];
    
    return [FMDBUtils exist:existSql];
}

//查询结果集 //查询一个字段
+(NSArray *)query:(NSString *)select where:(NSString *)where{
    
    NSString *sql = [[[select stringByAppendingString:@" from "]
                      stringByAppendingString: [self tableName]] stringByAppendingString:where];
    
    NSMutableArray *objects = [NSMutableArray array];
    [FMDBUtils query:sql result:^(FMResultSet *rs) {
        BaseModel * value = [[self class] createBean:rs];
        [objects addObject:value];
    }];
    
    return objects;
}

+(NSArray *)query:(NSString *)select where:(NSString *)where dbFile:(NSString*)dbFile{
    NSString *sql = [[[select stringByAppendingString:@" from "]
                      stringByAppendingString: [self tableName]] stringByAppendingString:where];
    
    NSMutableArray *objects = [NSMutableArray array];
    [FMDBUtils query:sql dbFile:dbFile result:^(FMResultSet *rs) {
        BaseModel * value = [[self class] createBean:rs];
        [objects addObject:value];
    }];
    
    return objects;

}
//无需拼接
+(NSArray *)queryAllSql:(NSString *)select  dbFile:(NSString*)dbFile{
    
    NSMutableArray *objects = [NSMutableArray array];
    [FMDBUtils query:select dbFile:dbFile result:^(FMResultSet *rs) {
        BaseModel * value = [[self class] createBean:rs];
        [objects addObject:value];
    }];
    
    return objects;}

+(NSArray*)modelList{
    return nil;
}

@end
