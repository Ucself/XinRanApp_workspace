//
//  User.m
//  XinRanApp
//
//  Created by tianbo on 14-12-8.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "User.h"



@implementation User

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
       // [self parseDictionary:dictionary];
        if ([dictionary isKindOfClass:[NSNull class]] || !dictionary) {
            return self;
        }
        
        self.username = [dictionary objectForKey:KJsonElement_UserName];
        self.email = [dictionary objectForKey:KjsonElement_email];
        self.phone = [dictionary objectForKey:KJsonElement_Phone];
        self.grades = [dictionary objectForKey:KjsonElement_grades];
        self.userId = [dictionary objectForKey:KJsonElement_ID];
        self.card_no = [dictionary objectForKey:KJsonElement_Card_no];
        //self.pwd = [dictionary objectForKey:KJsonElement_Pwd];
         
    }
    
    return self;
    
}


//对象序列化方法
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.grades forKey:@"grades"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.pwd forKey:@"pwd"];
    [aCoder encodeObject:self.arUserWhouses forKey:@"arUserWhouses"];
    [aCoder encodeObject:self.card_no forKey:@"card_no"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.grades = [aDecoder decodeObjectForKey:@"grades"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.pwd = [aDecoder decodeObjectForKey:@"pwd"];
        self.arUserWhouses = [aDecoder decodeObjectForKey:@"arUserWhouses"];
        self.card_no = [aDecoder decodeObjectForKey:@"card_no"];
    }
    return  self;
}

#pragma mark- 数据库操作
//表名
+ (NSString * ) tableName{
    return @"T_User";
}

//建表sql
+ (NSString * ) createTableSql{
    return [NSString stringWithFormat:@"CREATE TABLE %@ (userId TEXT PRIMARY KEY  NOT NULL , username TEXT, pwd TEXT, email TEXT, phone TEXT, grades INTEGER, user_id integer, constraint fk_T_User_user_id_T_Whouse_id foreign key(user_id) references T_Whouse(id)", [self tableName]];//fk_T_User_user_id_T_Whouse_id外键约束
}


//查询所有
+(NSArray*)modelList
{
    NSString *sql = @"select *";
    NSString *wheresql= @" order by phone ";
    
    NSArray *list = [self query:sql where:wheresql];
    
    return list;
}

//添加新条目
+(void)addNewModel:(User*)model
{
    if ([self exist:[NSString stringWithFormat:@" where userId='%@'", model.userId]]) {
        //DBG_MSG(@"This record was already updated");
        return;
    }
    
    NSString *insertStr = [NSString stringWithFormat:@"(userId,username,pwd,email,phone,grades ) values('%@','%@','%@','%@','%@','%d')",
                           model.userId, model.username, model.pwd, model.email, model.phone, [model.grades intValue]];
    [self insert:insertStr];
}


//更新到本地数据库
+(void)updateModel:(User*)model{
    NSString *set=[NSString stringWithFormat:@""];
    NSString *wheresql=[NSString stringWithFormat:@" where phone='%@'",model.phone];
    
    [self update:set where:wheresql];
}

//更新到本地数据库
+(void)updateModel:(NSString *)field  value:(NSString *)value Id:(NSString *)Id{
    NSString *set=[NSString stringWithFormat:@"set %@='%@' ",field,value];
    NSString *wheresql=[NSString stringWithFormat:@" where phone='%@' ", Id];
    
    [self update:set where:wheresql];
}
@end
