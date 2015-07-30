//
//  Areas.m
//  XinRanApp
//
//  Created by tianbo on 14-12-22.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "Areas.h"
#import <XRCommon/Common.h>
#import "ProtocolDefine.h"

@interface Areas (){


}

@end
@implementation Areas
-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        if ([dictionary isKindOfClass:[NSNull class]] || !dictionary) {
            return self;
        }
        
        self.Id = [dictionary objectForKey:KJsonElement_ID];
        self.name = [dictionary objectForKey:KJsonElement_Name];
        self.state = [[dictionary objectForKey:KJsonElement_Status] intValue];
        self.pId = [dictionary objectForKey:KJsonElement_Pid];
        self.order = [[dictionary objectForKey:KJsonElement_Order] intValue];
        
    }
    
    return self;
    
}
//对象序列化方法
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.Id forKey:@"Id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.state] forKey:@"state"];
    [aCoder encodeObject:self.pId forKey:@"pId"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.order] forKey:@"order"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.Id = [aDecoder decodeObjectForKey:@"Id"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.state = [[aDecoder decodeObjectForKey:@"state"] intValue];
        self.pId = [aDecoder decodeObjectForKey:@"pId"];
        self.order = [[aDecoder decodeObjectForKey:@"order"] intValue];
    }
    return  self;
}
#pragma mark- 数据库操作

+(NSString *) dbFilePath{
    return [[NSBundle mainBundle] pathForResource:@"AraeDB" ofType:@"sqlite"];
}

//表名
+ (NSString * ) tableName{
    return @"T_Areas";
    
}

//建表sql
+ (NSString * ) createTableSql{
    
    return [NSString stringWithFormat:@"CREATE TABLE %@ (id TEXT PRIMARY KEY  NOT NULL , name TEXT, pid TEXT, state INTEGER, orders INTEGER)", [self tableName]];
}

//查询所有
+(NSArray*)modelList
{
    NSString *sql = @"SELECT *";
    NSString *wheresql= @" order by id ";
    
    NSArray *list = [self query:sql where:wheresql dbFile:[self dbFilePath]];
    
    return list;
}

+(NSArray*)provinceList
{
    NSString *sql = @"SELECT *";
    NSString *wheresql= @" where parent_id = '0' ";
    NSArray *list = [self query:sql where:wheresql dbFile:[self dbFilePath]];
    return list;
}
+(NSArray*)cityList:(NSString*)provinceId
{
    NSString *sql = @"SELECT *";
    NSString *wheresql= [NSString stringWithFormat:@" where parent_id = '%@' ", provinceId];
    
    NSArray *list = [self query:sql where:wheresql dbFile:[self dbFilePath]];
    
    return list;
}

+(NSArray*)districtList:(NSString*)cityId
{
    NSString *sql = @"SELECT *";
    NSString *wheresql= [NSString stringWithFormat:@" where parent_id = '%@' ", cityId];
    
    NSArray *list = [self query:sql where:wheresql dbFile:[self dbFilePath]];
    
    return list;
}

+(Areas*)getArearWithId:(NSString*)Id
{
    NSString *sql = @"SELECT *";
    NSString *wheresql= [NSString stringWithFormat:@" where id = '%@' ", Id];
    
    NSArray *list = [self query:sql where:wheresql dbFile:[self dbFilePath]];
    Areas *areas = nil;
    if (list && list.count!=0) {
        areas = [list objectAtIndex:0];
    }
    return areas;
}

//添加新条目
+(void)addNewModel:(Areas*)model
{
    //dispatch_queue_t concurrentQueue = dispatch_queue_create("add.queue", DISPATCH_QUEUE_CONCURRENT);
    //dispatch_sync(concurrentQueue, ^{
        if ([self exist:[NSString stringWithFormat:@" where id = '%@'", model.Id]]) {
            DBG_MSG(@"This record was already updated");
            return;
        }
        
        NSString *insertStr = [NSString stringWithFormat:@"(id,name,pid,state,orders ) values('%@','%@','%@','%d','%d')",
                               model.Id, model.name, model.pId, model.state, model.order];
    
        [self insert:insertStr];
    //});
    
}

//更新到本地数据库
+(void)updateModel:(Areas*)model{
    NSString *set=@"";
    NSString *wheresql=[NSString stringWithFormat:@" where id='%@'",model.Id];
    
    [self update:set where:wheresql];
}

//更新到本地数据库
+(void)updateModel:(NSString *)field  value:(NSString *)value Id:(NSString *)Id{
    NSString *set=[NSString stringWithFormat:@"set %@='%@' ",field,value];
    NSString *wheresql=[NSString stringWithFormat:@" where id='%@' ",Id];
    
    [self update:set where:wheresql];
}

//生成对象
+ (BaseModel *)createBean:(FMResultSet *) stmt{

    NSString *Id =  [stmt stringForColumnIndex:0];
    NSString *name = [stmt stringForColumnIndex:1];
    int state = [stmt intForColumnIndex:2];
    NSString *pId = [stmt stringForColumnIndex:3];
    int order = [stmt intForColumnIndex:4];
  
    
    if(Id==nil || [Id length]==0){
        return nil;
    }

    Areas * bean = [Areas new];
    bean.Id = Id;
    bean.name =name;
    bean.state = state;
    bean.pId = pId;
    bean.order = order;

    return bean;
    
    
}
//创建对象
//- (BaseModel *)createBeanBySqlite:(sqlite3_stmt *)stmt{
//    
//    NSString *Id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
//    NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
//    int state = sqlite3_column_int(stmt, 2);
//    NSString *pId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
//    int order = sqlite3_column_int(stmt, 4);
//    if(Id==nil || [Id length]==0){
//        return nil;
//    }
//    Areas * bean = [Areas new];
//    bean.Id = Id;
//    bean.name =name;
//    bean.state = state;
//    bean.pId = pId;
//    bean.order = order;
//    
//    return bean;
//
//}
@end
