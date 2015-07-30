//
//  Brand.m
//  XinRanApp
//
//  Created by tianbo on 15-2-5.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "Brand.h"

@implementation Brand

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        if ([dictionary isKindOfClass:[NSNull class]] || !dictionary) {
            return self;
        }
        
        self.Id = [dictionary objectForKey:KJsonElement_ID];
        self.name = [dictionary objectForKey:KJsonElement_Name];
        self.desc = [dictionary objectForKey:KJsonElement_BrandsDesc];
    }
    
    return self;
}


#pragma mark- 数据库操作
//表名
+ (NSString * ) tableName{
    return @"T_Brand";
}

//建表sql
+ (NSString * ) createTableSql{
    
    return [NSString stringWithFormat:@"CREATE TABLE %@ (id TEXT PRIMARY KEY  NOT NULL , name TEXT, desc TEXT)", [self tableName]];
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
+(void)addNewModel:(Brand*)model
{
    //dispatch_queue_t concurrentQueue = dispatch_queue_create("add.queue", DISPATCH_QUEUE_CONCURRENT);
    //dispatch_sync(concurrentQueue, ^{
    if ([self exist:[NSString stringWithFormat:@" where id = '%@'", model.Id]]) {
        //DBG_MSG(@"This record was already updated");
        return;
    }
    
    NSString *insertStr = [NSString stringWithFormat:@"(id,name,desc ) values('%@','%@','%@')",
                           model.Id, model.name, model.desc];
    
    [self insert:insertStr];
    //});
    
}

//更新到本地数据库
+(void)updateModel:(Brand*)model{
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
    NSString *desc = [stmt stringForColumnIndex:2];
    
    
    if(Id==nil || [Id length]==0){
        return nil;
    }
    
    Brand * bean = [Brand new];
    bean.Id = Id;
    bean.name =name;
    bean.desc = desc;
    
    return bean;
    
    
}
@end
