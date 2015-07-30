//
//  Product.m
//  XinRanApp
//
//  Created by tianbo on 14-12-8.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "Product.h"






@implementation Product
-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        if ([dictionary isKindOfClass:[NSNull class]] || !dictionary) {
            return self;
        }
        
        self.Id = [dictionary objectForKey:KJsonElement_ID];
        self.did = [dictionary objectForKey:KJsonElement_Did];
        
        self.state = [[dictionary objectForKey:KJsonElement_Status] intValue];
        self.title = [dictionary objectForKey:KJsonElement_Name];
        self.price = [[dictionary objectForKey:KJsonElement_Price] floatValue];
        self.priceOld = [[dictionary objectForKey:KJsonElement_OldPrice] floatValue];
        self.desc = [dictionary objectForKey:KJsonElement_Desc];
        NSString *picAddr = [NSString stringWithFormat:@"%@%@", KImageDonwloadAddr, [dictionary objectForKey:KJsonElement_Image]];
        self.image = picAddr;
        
        self.startDate = [dictionary objectForKey:KJsonElement_StartDate];
        self.seconds = [[dictionary objectForKey:KJsonElement_Seconds] integerValue];
        
        self.gc = [dictionary objectForKey:KJsonElement_Gc];
        self.comd = [[dictionary objectForKey:KJsonElement_Comd] intValue];
        self.limit = [[dictionary objectForKey:KJsonElement_Limit_buy] intValue];
        
        self.limit_grades = [[dictionary objectForKey:KJsonElement_Limit_grades] intValue];
        
        NSString *strSaled = [dictionary objectForKey:KJsonElement_Saled];
        if (strSaled && ![strSaled isKindOfClass:[NSNull class]]) {
            self.sale = [strSaled intValue];
        }
        
        self.remaind = [[dictionary objectForKey:KJsonElement_Remaind] integerValue];
        self.agrades_name = [dictionary objectForKey:KjsonElement_Agrades_name];
        
        //产品详情
        NSString *body = [dictionary objectForKey:KJsonElement_Body];
        //路径处理
        NSRange range = [body rangeOfString:KImageDonwloadAddr];
        if (range.location == NSNotFound) {
            self.body = [body stringByReplacingOccurrencesOfString:@"\"/media/editors/"
                                                               withString:[NSString stringWithFormat:@"\"%@%@", KImageDonwloadAddr, @"/media/editors/"]];
        }
        else {
            self.body = body;
        }
        
        self.video = [dictionary objectForKey:KJsonElement_Video];
        self.icon = [dictionary objectForKey:KJsonElement_Icon];
        
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:1];
        NSMutableArray *array = [dictionary objectForKey:KJsonElement_Images];
        for (NSString *url in array) {
            NSString *picAddr = [NSString stringWithFormat:@"%@%@", KImageDonwloadAddr, url];
            [images addObject:picAddr];
        }
        self.arImages = images;
        
        //门店信息
        array = [dictionary objectForKey:KJsonElement_Storate];
        if (array && array.count > 0) {
            _arrayWhouses = [NSMutableArray new];
            for (NSDictionary *dict in array) {
                if (dict) {
                    WhouseProduct *whouse = [[WhouseProduct alloc] initWithDictionary:dict];
                    [self.arrayWhouses addObject:whouse];
                }
            }
            
        }
        
    }
    
    return self;
}


//-(id)initWithDictionary:(NSDictionary*)dictionary
//{
//    self = [super init];
//    if (self) {
//    }
//    return self;
//}

-(void)dealloc
{
    //DBG_MSG(@"enter");
}

#pragma mark- 数据库操作
//表名
- (NSString * ) tableName
{
    return @"T_Product";
}

//建表sql
- (NSString * ) createTableSql
{
    return nil;//[NSString stringWithFormat:@"CREATE TABLE %@ (id TEXT PRIMARY KEY  NOT NULL , name TEXT, price FLOAT, desc TEXT, body TEXT, video TEXT, did TEXT, isstart BOOL, seconds INTEGER)", [self tableName]];
}

//查询所有
+(NSArray*)modelList
{
    NSString *sql = @"select *";
    NSString *wheresql= @" order by name ";
    
    NSArray *list = [self query:sql where:wheresql];
    
    return list;
}

//添加新条目
+(void)addNewModel:(Product*)model
{
    NSString *insertStr=[[NSString alloc] initWithFormat:@""];
    
    [self insert:insertStr];
}

//更新到本地数据库
+(void)updateModel:(Product*)model{
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
