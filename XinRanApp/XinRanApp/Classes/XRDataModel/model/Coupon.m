//
//  Coupon.m
//  XinRanApp
//
//  Created by tianbo on 14-12-9.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//
//  礼品券类

#import "Coupon.h"

@implementation Coupon

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        
        if ([dictionary isKindOfClass:[NSNull class]] || !dictionary) {
            return self;
        }
        
        self.Id = [dictionary objectForKey:KJsonElement_ID];
        self.status = [[dictionary objectForKey:KJsonElement_Status] intValue];
        self.title = [dictionary objectForKey:KJsonElement_Name];
        self.price = [dictionary objectForKey:KJsonElement_Price];
        self.start_date = [dictionary objectForKey:KJsonElement_Start_Date];
        self.create_date = [dictionary objectForKey:KJsonElement_CreateDate];
        self.address = [dictionary objectForKey:KJsonElement_Address];
        self.num = [[dictionary objectForKey:KJsonElement_Num] intValue];
        self.image = [NSString stringWithFormat:@"%@%@",KImageDonwloadAddr,[dictionary objectForKey:KJsonElement_Image]];
        self.coupon_price = [dictionary objectForKey:KJsonElement_CouponPrice];
        
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:1];
        NSMutableArray *array = [dictionary objectForKey:KJsonElement_Images];
        for (NSString *url in array) {
            NSString *picAddr = [NSString stringWithFormat:@"%@%@", KImageDonwloadAddr, url];
            [images addObject:picAddr];
        }
        self.arImages = images;
    }
    
    return self;
    
}

#pragma mark- 数据库操作
//表名
- (NSString * ) tableName{
    return @"T_Coupon";
}

//建表sql
- (NSString * ) createTableSql{
    return [NSString stringWithFormat:@"CREATE TABLE %@ (id TEXT PRIMARY KEY  NOT NULL , create_date DATETIME, name TEXT, images TEXT, addr TEXT, num INTEGER, price FLOAT, coupon_price FLOAT)", [self tableName]];
}

//查询所有
+(NSArray*)modelList
{
    NSString *sql = @"select * ";
    NSString *wheresql= @" order by id ";
    
    NSArray *list = [self query:sql where:wheresql];
    
    return list;
}

//添加新条目
+(void)addNewModel:(Coupon*)model
{
    NSString *insertStr=[[NSString alloc] initWithFormat:@""];
    
    [self insert:insertStr];
}

//更新到本地数据库
+(void)updateModel:(Coupon*)model{
    NSString *set=[NSString stringWithFormat:@""];
    NSString *wheresql=[NSString stringWithFormat:@" where id='%@'",model.Id];
    
    [self update:set where:wheresql];
}

//更新到本地数据库
+(void)updateModel:(NSString *)field  value:(NSString *)value Id:(NSString *)Id{
    NSString *set=[NSString stringWithFormat:@"set %@='%@' ",field,value];
    NSString *wheresql=[NSString stringWithFormat:@" where id='%@' ", Id];
    
    [self update:set where:wheresql];
}
@end
