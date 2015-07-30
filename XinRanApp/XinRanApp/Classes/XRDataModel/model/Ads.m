//
//  Ads.m
//  XinRanApp
//
//  Created by tianbo on 14-12-17.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "Ads.h"

@implementation Ads

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        if ([dictionary isKindOfClass:[NSNull class]] || !dictionary) {
            return self;
        }
        
//        self.picAddr = [NSString stringWithFormat:@"%@%@", KImageDonwloadAddr, [dictionary objectForKey:KJsonElement_LinkUrl]];
        self.type = [[dictionary objectForKey:KJsonElement_LinkType] intValue];
    
        NSString *picAddr = [NSString stringWithFormat:@"%@%@", KImageDonwloadAddr, [dictionary objectForKey:KJsonElement_Url]];
        self.linkUrl = self.picAddr = picAddr;

    }
    
    return self;
    
}

-(id)initWithUrl:(NSString*)url
{
    self = [super init];
    if (self) {
        self.picAddr = [NSString stringWithFormat:@"%@%@", KImageDonwloadAddr, url];
    }
    
    return self;
    
}

//对象序列化方法
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.picAddr forKey:@"picAddr"];
    [aCoder encodeObject:self.linkUrl forKey:@"linkUrl"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.type] forKey:@"type"];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        self.picAddr = [aDecoder decodeObjectForKey:@"picAddr"];
        self.linkUrl= [aDecoder decodeObjectForKey:@"linkUrl"];
        self.type = [[aDecoder decodeObjectForKey:@"type"] intValue];
    }
    return  self;
}

@end
