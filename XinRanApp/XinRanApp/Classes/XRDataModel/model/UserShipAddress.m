//
//  UserShipAddress.m
//  XRDataModel
//
//  Created by libj on 15/4/28.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "UserShipAddress.h"

@implementation UserShipAddress

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        if ([dictionary isKindOfClass:[NSNull class]] || !dictionary) {
            return self;
        }
        self.shipAddressId = [dictionary objectForKey:KJsonElement_ID];
        self.name = [dictionary objectForKey:KJsonElement_Name];
        self.areaId = [dictionary objectForKey:KJsonElement_Area_Id];
        self.detailAddress = [dictionary objectForKey:KJsonElement_Address];
        self.phone = [dictionary objectForKey:KJsonElement_Phone];
    }
    
    return self;
}

//对象序列化方法
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.shipAddressId forKey:@"shipAddressId"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.areaId forKey:@"areaId"];
    [aCoder encodeObject:self.detailAddress forKey:@"detailAddress"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        self.shipAddressId = [aDecoder decodeObjectForKey:@"shipAddressId"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.areaId = [aDecoder decodeObjectForKey:@"areaId"];
        self.detailAddress = [aDecoder decodeObjectForKey:@"detailAddress"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
    }
    return  self;
}

@end
