//
//  Whouse.m
//  XinRanApp
//
//  Created by tianbo on 14-12-18.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "Whouse.h"

@implementation Whouse

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        if ([dictionary isKindOfClass:[NSNull class]] || !dictionary) {
            return self;
        }
        
        self.Id = [dictionary objectForKey:KJsonElement_ID];
        self.name = [dictionary objectForKey:KJsonElement_Name];
        self.areaId = [dictionary objectForKey:KJsonElement_Areaid];
        self.address = [dictionary objectForKey:KJsonElement_Address];
        self.latitude = [dictionary objectForKey:KJsonElement_Latitude];
        self.longitude = [dictionary objectForKey:KJsonElement_Longitude];
        self.remainds = [[dictionary objectForKey:KJsonElement_Remaind] intValue];
    }
    
    return self;
}

//对象序列化方法
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.Id forKey:@"Id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.areaId forKey:@"areaId"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
    [aCoder encodeObject:self.longitude forKey:@"longitude"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        self.Id = [aDecoder decodeObjectForKey:@"Id"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.areaId = [aDecoder decodeObjectForKey:@"areaId"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
        self.longitude = [aDecoder decodeObjectForKey:@"longitude"];
    }
    return  self;
}



#pragma mark- 数据库操作
//表名
+ (NSString * ) tableName{
    return @"T_Whouse";
}

//建表sql
+ (NSString * ) createTableSql{
    
    return [NSString stringWithFormat:@"CREATE TABLE %@ (id TEXT PRIMARY KEY  NOT NULL , name TEXT, areaId TEXT, address TEXT, longitude TEXT, latitude TEXT)", [Whouse tableName]];
}

//查询所有
+(NSArray*)modelList
{
    NSString *sql = @"SELECT *";
    NSString *wheresql= @" order by id ";
    
    NSArray *list = [self query:sql where:wheresql];
    
    return list;
}
+(Whouse*)whouseWithId:(NSString *)whouseId
{
    NSString *sql = @"select *";
    NSString *wheresql= [NSString stringWithFormat: @" where id='%@'",whouseId];
    
    NSArray *list = [self query:sql where:wheresql];
    Whouse *whouse = nil;
    if (list && list.count!=0) {
         whouse = [list objectAtIndex:0];
    }
    return whouse;
}


//添加新条目
+(void)addNewModel:(Whouse*)model
{
    if ([self exist:[NSString stringWithFormat:@" where id='%@'", model.Id]]) {
        //DBG_MSG(@"This record was already updated");
        return;
    }
    
    NSString *insertStr = [NSString stringWithFormat:@"(id,name,areaId,address,longitude,latitude ) values('%@','%@','%@','%@','%@','%@')",
                           model.Id, model.name, model.areaId, model.address, model.longitude, model.latitude];
    
    [self insert:insertStr];
}

//更新到本地数据库
+(void)updateModel:(Whouse*)model{
    NSString *set=@"";
    NSString *wheresql=[NSString stringWithFormat:@" where id='%@'",model.Id];
    
    [self update:set where:wheresql];
}

//更新到本地数据库
+(void)updateModel:(NSString *)field  value:(NSString *)value Id:(NSString *)Id{
    NSString *set=[NSString stringWithFormat:@"set %@='%@' ",field,value];
    NSString *wheresql=[NSString stringWithFormat:@" where id='%@' ", Id];
    
    [self update:set where:wheresql];
}

//生成对象
+ (BaseModel *)createBean:(FMResultSet *) stmt{
    
    NSString *Id = [stmt stringForColumnIndex:0];
    NSString *name = [stmt stringForColumnIndex:1];
    NSString *areaId = [stmt stringForColumnIndex:2];
    NSString *address = [stmt stringForColumnIndex:3];
    NSString *longitude = [stmt stringForColumnIndex:4];
    NSString *latitude = [stmt stringForColumnIndex:5];
    
    if(Id==nil || [Id length]==0){
        return nil;
    }
    
    Whouse * bean = [Whouse new];
    bean.Id = Id;
    bean.name = name;
    bean.areaId = areaId;
    bean.address = address;
    bean.longitude = longitude;
    bean.latitude = latitude;
    
    return bean;
    
    
}

@end

#pragma WhouseInfo class
@implementation WhouseProduct

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        if ([dictionary isKindOfClass:[NSNull class]] || !dictionary) {
            return self;
        }
        
        self.Id = [dictionary objectForKey:KJsonElement_ID];
        self.adwId = [dictionary objectForKey:KJsonElement_Adwid];
        self.areaId = [dictionary objectForKey:KJsonElement_Areaid];
        self.goodsn = [[dictionary objectForKey:KJsonElement_Goodsn] intValue];
        self.saled = [[dictionary objectForKey:KJsonElement_Saled] intValue];
        self.remainds = [[dictionary objectForKey:KJsonElement_Remaind] intValue];
    }
    
    return self;
}

-(void)dealloc
{
    self.adwId = nil;
    self.areaId = nil;
    self.Id = nil;
}

@end
