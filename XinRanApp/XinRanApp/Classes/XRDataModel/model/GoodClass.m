//
//  GoodClass.m
//  XinRanApp
//
//  Created by tianbo on 15-2-5.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "GoodClass.h"

@implementation GoodClass


-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        if ([dictionary isKindOfClass:[NSNull class]] || !dictionary) {
            return self;
        }
        
        self.Id = [dictionary objectForKey:KJsonElement_ID];
        self.name = [dictionary objectForKey:KJsonElement_GCName];
        self.parentId = [dictionary objectForKey:KJsonElement_GCPID];
        self.iamgePath = [dictionary objectForKey:KJsonElement_Iconfilepath];
        self.sort = [[dictionary objectForKey:KJsonElement_GCSort] intValue];
    }
    
    return self;
}


#pragma mark- 数据库操作
//表名
+ (NSString * ) tableName{
    return @"T_GoodClass";
}

//建表sql
+ (NSString * ) createTableSql{
    
    return [NSString stringWithFormat:@"CREATE TABLE %@ (id TEXT PRIMARY KEY  NOT NULL , name TEXT, parentId TEXT, iamgePath TEXT, sort INTEGER)", [self tableName]];
}

//查询所有
+(NSArray*)modelList
{
    NSString *sql = @"SELECT *";
    NSString *wheresql= @" order by id ";
    
    NSArray *list = [self query:sql where:wheresql];
    
    return list;
}

//添加新条目
+(void)addNewModel:(GoodClass*)model
{
    //dispatch_queue_t concurrentQueue = dispatch_queue_create("add.queue", DISPATCH_QUEUE_CONCURRENT);
    //dispatch_sync(concurrentQueue, ^{
    if ([self exist:[NSString stringWithFormat:@" where id = '%@'", model.Id]]) {
        DBG_MSG(@"This record was already updated");
        return;
    }
    
    NSString *insertStr = [NSString stringWithFormat:@"(id,name,parentId,iamgePath,sort ) values('%@','%@','%@','%@','%d')",
                           model.Id, model.name, model.parentId, model.iamgePath, model.sort];
    
    [self insert:insertStr];
    //});
    
}

//更新到本地数据库
+(void)updateModel:(GoodClass*)model{
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
    
    NSString *Id = [stmt stringForColumnIndex:0];
    NSString *name = [stmt stringForColumnIndex:1];
    NSString *paretId = [stmt stringForColumnIndex:2];
    NSString *iamgePath = [stmt stringForColumnIndex:3];
    int sort = [stmt intForColumnIndex:0];
    
    if(Id==nil || [Id length]==0){
        return nil;
    }
    
    GoodClass * bean = [GoodClass new];
    bean.Id = Id;
    bean.name =name;
    bean.parentId = paretId;
    bean.iamgePath = iamgePath;
    bean.sort = sort;
    
    return bean;
    
    
}
//获取商品分类列表
+(NSArray*)getGoodClassWithParentId:(NSString*)parentId
{
    NSString *sql = @"SELECT *";
    NSString *wheresql= [NSString stringWithFormat:@" where parentId = '%@' %@", parentId,@"order by sort"];
    
    NSArray *goodlist = [self query:sql where:wheresql];
    return goodlist;
}

@end
