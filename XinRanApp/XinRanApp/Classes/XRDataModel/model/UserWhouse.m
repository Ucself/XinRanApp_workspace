//
//  UserWhouse.m
//  XinRanApp
//
//  Created by tianbo on 15-1-15.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//
// 用户使用过的店铺

#import "UserWhouse.h"
#import "User.h"

@implementation UserWhouse

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        if ([dictionary isKindOfClass:[NSNull class]] || !dictionary) {
            return self;
        }
        
        self.userId = [dictionary objectForKey:@"userId"];
        self.whouseId = [dictionary objectForKey:@"whouseId"];
    }
    
    return self;
}


#pragma mark- 数据库操作
//表名
+ (NSString * ) tableName{
    return @"T_UserWhouse";
}

//建表sql
+ (NSString * ) createTableSql{
    return  [NSString stringWithFormat:@"CREATE TABLE %@ (userId TEXT NOT NULL , whouseId TEXT NOT NULL , PRIMARY KEY (userId, whouseId))", [self tableName]];
}

//查询所有
+(NSArray*)modelList
{
    NSString *sql = @"select *";
    NSString *wheresql= @" order by userId ";
    
    NSArray *list = [self query:sql where:wheresql];
    
    return list;
}

+(UserWhouse*)userWhouseWithId:(NSString *)userId
{
    NSString *sql = @"select *";
    NSString *wheresql= [NSString stringWithFormat: @"  where userId = '%@'",userId];
    
    NSArray *list = [self query:sql where:wheresql];
    UserWhouse *userWhouse = nil;
    if (list && list.count!=0) {
        userWhouse = [list objectAtIndex:0];
    }
    
    return userWhouse;
}

//添加新条目
+(void)addNewModel:(UserWhouse*)model
{
    if ([self exist:[NSString stringWithFormat:@" where userId='%@' whouseId='%@'", model.userId, model.whouseId]]) {
        //DBG_MSG(@"This record was already updated");
        return;
    }
    
    NSString *insertStr = [NSString stringWithFormat:
                           @"(userId, whouseId ) values('%@','%@')",
                           model.userId, model.whouseId];
    [self insert:insertStr];
}

//生成对象
+ (BaseModel *)createBean:(FMResultSet *) stmt{
    
    NSString *userId = [stmt stringForColumnIndex:0];
    NSString *whouseId = [stmt stringForColumnIndex:1];
    
    if(userId==nil || [userId length]==0){
        return nil;
    }
    
    UserWhouse * bean = [UserWhouse new];
    bean.userId = userId;
    bean.whouseId = whouseId;

    
    return bean;
    
    
}

+(BOOL)removeWithId:(NSString *)userId
{
    NSString *deleteSQL = [NSString stringWithFormat:@" where userId = '%@';",userId];
   return  [self remove:deleteSQL];
   
}

@end
