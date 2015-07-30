//
//  Order.m
//  XinRanApp
//
//  Created by tianbo on 14-12-16.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "Order.h"

@implementation OrderPdt

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        if ([dictionary isKindOfClass:[NSNull class]] || !dictionary) {
            return self;
        }
        
        self.Id = [dictionary objectForKey:KJsonElement_ID];
        self.image = [NSString stringWithFormat:@"%@%@",KImageDonwloadAddr,[dictionary objectForKey:KJsonElement_Image]];
        self.num = [[dictionary objectForKey:KJsonElement_Num] intValue];
        self.price = [[dictionary objectForKey:KJsonElement_Price] floatValue];
        self.name = [dictionary objectForKey:KJsonElement_Name];
        self.desc = [dictionary objectForKey:KJsonElement_Desc];

    }
    
    return self;
    
}


@end


@implementation Order

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        if ([dictionary isKindOfClass:[NSNull class]] || !dictionary) {
            return self;
        }
        
        self.Id = [dictionary objectForKey:KJsonElement_ID];
        self.adid = [dictionary objectForKey:KJsonElement_ADid];
        if (![[dictionary objectForKey:KJsonElement_SN] isKindOfClass:[NSNull class]])
            self.sn = [dictionary objectForKey:KJsonElement_SN];
        self.status = [[dictionary objectForKey:KJsonElement_State] intValue];
        self.name = [dictionary objectForKey:KJsonElement_Name];
        self.price = [[dictionary objectForKey:KJsonElement_Price] floatValue];
        self.addTime = [dictionary objectForKey:KJsonElement_AddTime];
        self.num = [[dictionary objectForKey:KJsonElement_Num] intValue];
        self.image = [NSString stringWithFormat:@"%@%@",KImageDonwloadAddr,[dictionary objectForKey:KJsonElement_Image]];
        
        self.address = [dictionary objectForKey:KJsonElement_Address];
        self.area_id = [dictionary objectForKey:KJsonElement_Area_Id];
        
        self.consignee = [dictionary objectForKey:KJsonElement_consignee];
        if (![[dictionary objectForKey:KJsonElement_finnshed_time] isKindOfClass:[NSNull class]])
            self.finnshed_time = [dictionary objectForKey:KJsonElement_finnshed_time];
        if (![[dictionary objectForKey:KJsonElement_payment_id] isKindOfClass:[NSNull class]])
            self.payment_id = [[dictionary objectForKey:KJsonElement_payment_id] intValue];
        if (![[dictionary objectForKey:KJsonElement_payment_name] isKindOfClass:[NSNull class]])
            self.payment_name = [dictionary objectForKey:KJsonElement_payment_name];
        if (![[dictionary objectForKey:KJsonElement_payment_time] isKindOfClass:[NSNull class]])
            self.payment_time = [dictionary objectForKey:KJsonElement_payment_time];
        if (![[dictionary objectForKey:KJsonElement_Phone] isKindOfClass:[NSNull class]])
            self.phone = [dictionary objectForKey:KJsonElement_Phone];
        if (![[dictionary objectForKey:KJsonElement_shipping_code] isKindOfClass:[NSNull class]])
            self.shipping_code = [dictionary objectForKey:KJsonElement_shipping_code];
        if (![[dictionary objectForKey:KJsonElement_shipping_company] isKindOfClass:[NSNull class]])
            self.shipping_company = [dictionary objectForKey:KJsonElement_shipping_company];
        if (![[dictionary objectForKey:KJsonElement_shipping_time] isKindOfClass:[NSNull class]])
            self.shipping_time = [dictionary objectForKey:KJsonElement_shipping_time];
        
        
        NSArray *array = [dictionary objectForKey:KJsonElement_Goods];
        if (array && array.count != 0) {
            self.arGoods = [NSMutableArray new];
            
            for (NSDictionary *dict in array) {
                OrderPdt *orderPdt = [[OrderPdt alloc] initWithDictionary:dict];
                [self.arGoods addObject:orderPdt];
            }
        }
        
    }
    
    return self;
    
}


@end
