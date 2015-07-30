//
//  Activity.m
//  XinRanApp
//
//  Created by tianbo on 14-12-16.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "Activity.h"

@implementation Activity

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        if ([dictionary isKindOfClass:[NSNull class]] || !dictionary) {
            return self;
        }
        
        self.Id = [dictionary objectForKey:KJsonElement_ID];
        self.title = [dictionary objectForKey:KJsonElement_Activity_title];
        self.state = [[dictionary objectForKey:KJsonElement_State] intValue];
        self.startDate = [dictionary objectForKey:KJsonElement_Activity_start_date];
        self.endDate = [dictionary objectForKey:KJsonElement_Activity_end_date];
        self.desc = [dictionary objectForKey:KJsonElement_Activity_desc];
        NSString *picAddr = [NSString stringWithFormat:@"%@%@", KImageDonwloadAddr, [dictionary objectForKey:KJsonElement_Activity_banner]];
        self.banner = picAddr;

    }
    
    return self;
    
}

//对象序列化方法
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.Id forKey:@"Id"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.state] forKey:@"state"];
    [aCoder encodeObject:self.startDate forKey:@"startDate"];
    [aCoder encodeObject:self.endDate forKey:@"endDate"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
    [aCoder encodeObject:self.banner forKey:@"banner"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        self.Id = [aDecoder decodeObjectForKey:@"Id"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.state = [[aDecoder decodeObjectForKey:@"state"] intValue];
        self.startDate = [aDecoder decodeObjectForKey:@"startDate"];
        self.endDate = [aDecoder decodeObjectForKey:@"endDate"];
        self.desc = [aDecoder decodeObjectForKey:@"desc"];
        self.banner = [aDecoder decodeObjectForKey:@"banner"];
    }
    return  self;
}

@end
