//
//  ProductForCmd.m
//  XinRanApp
//
//  Created by tianbo on 15-2-5.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "ProductForCmd.h"

@implementation ProductForCmd

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        if ([dictionary isKindOfClass:[NSNull class]] || !dictionary) {
            return self;
        }
        
        self.Id = [dictionary objectForKey:KJsonElement_ID];
        self.dId = [dictionary objectForKey:KJsonElement_Did];
        self.state = [[dictionary objectForKey:KJsonElement_Status] intValue];
        self.title = [dictionary objectForKey:KJsonElement_Name];
        self.price = [[dictionary objectForKey:KJsonElement_Price] floatValue];
        self.priceOld = [[dictionary objectForKey:KJsonElement_OldPrice] floatValue];
        NSString *picAddr = [NSString stringWithFormat:@"%@%@", KImageDonwloadAddr, [dictionary objectForKey:KJsonElement_Image]];
        self.image = picAddr;
        self.seconds = [[dictionary objectForKey:KJsonElement_Sconds] integerValue];
        self.limit = [[dictionary objectForKey:KJsonElement_Limit_buy] intValue];
        self.saled = [[dictionary objectForKey:KJsonElement_Saled] intValue];
    }
    
    return self;
}

//对象序列化方法
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.Id forKey:@"Id"];
    [aCoder encodeObject:self.dId forKey:@"dId"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.state] forKey:@"state"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.price] forKey:@"price"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.priceOld] forKey:@"priceActivity"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.seconds] forKey:@"seconds"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.limit] forKey:@"limit"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.saled] forKey:@"saled"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.Id = [aDecoder decodeObjectForKey:@"Id"];
        self.dId = [aDecoder decodeObjectForKey:@"dId"];
        self.state = [[aDecoder decodeObjectForKey:@"state"] intValue];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.price = [[aDecoder decodeObjectForKey:@"price"] floatValue];
        self.priceOld = [[aDecoder decodeObjectForKey:@"priceOld"] floatValue];
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.seconds = [[aDecoder decodeObjectForKey:@"seconds"] integerValue];
        self.limit = [[aDecoder decodeObjectForKey:@"limit"] intValue];
        self.saled = [[aDecoder decodeObjectForKey:@"saled"] intValue];
    }
    return  self;
}

@end
