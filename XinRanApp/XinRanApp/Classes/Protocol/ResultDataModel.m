//
//  ResultDataModel.m
//  XinRanApp
//
//  Created by tianbo on 14-12-9.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "ResultDataModel.h"


#import "Ads.h"
#import "Activity.h"
#import "Order.h"
#import "User.h"
#import "Product.h"
#import "ProductForCmd.h"
#import "Coupon.h"
#import "EnvPreferences.h"
#import "Areas.h"
#import "Whouse.h"
#import "Brand.h"
#import "GoodClass.h"
#import "UserShipAddress.h"

@implementation ResultDataModel

-(void)dealloc
{
    self.desc = nil;
    self.data = nil;
}

-(id)initWithDictionary:(NSDictionary *)dict reqType:(int)reqestType
{
    self = [super init];
    if ([dict isKindOfClass:[NSNull class]] || dict == nil) {
        return self;
    }
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return self;
    }

    if (self) {
        self.data = nil;
        self.requestType = reqestType;
        
        int resultCode = [[dict objectForKey:@"result"] intValue];
        self.resultCode = resultCode;
        
        if (resultCode >= 0) {
            self.desc = @"请求成功";
            [self parseData:dict];
        }
        else {
            NSString *msg = [dict objectForKey:@"msg"];
            self.desc = msg ? msg : @"亲，数据获取失败，请重试!";
        }
    }
    
    return self;
}

-(id)initWithErrorInfo:(NSError*)error reqType:(int)reqestType
{
    self = [super init];
    if (self) {
        self.requestType = reqestType;
        self.resultCode = (int)error.code;
        DBG_MSG(@"http request error code: (%d)", self.resultCode);
        
        switch (self.resultCode) {
            case NSURLErrorNotConnectedToInternet:
                self.desc = @"亲，你的网络不给力，请检查网络!";
                break;
            default:
                self.desc = @"亲，数据获取失败，请重试!";
                break;
        }
        self.data = nil;
    }
    
    return self;
}

-(NSString*)parseErrorCode:(NSInteger)code
{
    NSString *ret = @"";
    switch (code) {

        case 401:
            ret = @"请求失败";
            break;
            
        default:
            break;
    }
    
    return  ret;
}

#pragma mark- 解析数据
//将返回的字典数据转化为相应的类
-(id)parseData:(NSDictionary*)dict
{
    NSDictionary *ret = nil;
    switch (self.requestType) {
        case KReqestType_Index:       //主页请求
        {
            [self parseHomeData:dict];
        }
            break;
        case KReqestType_Gds:
        {
            [self parseProductDetail:dict];
        }
            break;
        case KReqestType_Adetailclass:
        case KReqestType_Adetail:
        {
            [self parseProductData:dict];
        }
            break;
        case KReqestType_Areawhouse:
        {
            [self parseAreaWhouse:dict];
        }
            break;
        case KReqestType_Login://登录请求
        {
            [self parseUserData:dict];
        }
            break;
        case KReqestType_Register://注册请求
        {
            [self parseUserData:dict];
        }
            break;
        
        case KReqestType_Coupons://我的礼品券
        {
            [self parseCouponListData:dict];
        }
            break;
        case KReqestType_Getcoupon://礼品券详情
        {
            [self parseCouponDetailData:dict];
        }
            break;
        case KReqestType_Act:
        {
            
        }
            break;
        case KReqestType_Logout:
        {
            
        }
            break;
        case KReqestType_ChangePwd:
        {
            
        }
            break;
            
        case KReqestType_Sendregsms:
        {
            
        }
            break;
        case KReqestType_Sendrcode:
        {

        }
            break;
        case KReqestType_Changepwdbcode:
        {
            
        }
            break;
        
        case KReqestType_Sendgfcode:
        {
            
        }
            break;
        case KReqestType_CheckCode:
        {
            
        }
            break;
        case KReqestType_Purchase:
        {
            
        }
            break;
        //v1.0 interface
        case KReqestType_Getdefwhouse:
        {
            
        }
            break;
        case KReqestType_SetdefWhouse:
        {
            
        }
            break;
        case KReqestType_BSUP:
        {
            [self parseBSUPData:dict];
        }
            break;
        case KReqestType_GoodsByClass:
        {
            [self parseGoodsByClass:dict];
        }
            break;
        case kreqestType_Goods:
        {
            [self parseGoods:dict];
        }
            break;
        case KReqestType_ActGoodsList:
        {
            [self parseActGoodsList:dict];
        }
            break;
        case KReqestType_MyOrders:
        {
            [self parseMyOrdersData:dict];
        }
            break;
        case KReqestType_OrderDetail:
        {
            [self parseOrderDetailData:dict];
        }
            break;
        case KReqestType_CancelOrder:
        {
            
        }
            break;
        case kReqestType_Home:
        {
            [self parseHomeData:dict];
        }
            break;
        case kReqestType_Buy:
        {
            [self parseBuy:dict];
        }
            break;
        case kReqestType_SekBuy:
        {
            
        }
            break;
        case KReqestType_Getconsignee:
        {
            [self parseGetconsignee:dict];
        }
            break;
        case KReqestType_Updateconsignee:
        {
            [self parseUpdateConsignee:dict];
        }
            break;
        case KReqestType_Finishorder:
        {
            
        }
            break;
        case KReqestType_weixinPay:
        {
            [self parseBuy:dict];
            break;
        }
        case KReqestType_AliPay:
        {
            [self parseBuy:dict];
        }
            break;
        case KReqestType_ActivityIndex:
        {
            [self parseActivityIndex:dict];
        }
            break;
        case KReqestType_ActivityLottery:
        {
            [self parseActivityLottery:dict];
        }
            break;
        case KReqestType_ActivityOrderlist:
        {
            [self parseActivityOrderList:dict];
        }
            break;
        default:
            break;
    }

    return ret;
}

//
- (void)parseHomeData:(NSDictionary *)dict
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    
    //广告数组
    NSArray *array = [dict objectForKey:KJsonElement_Ads];
    if (array) {
        NSMutableArray *arAds = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dict in array) {
            Ads *ads = [[Ads alloc] initWithDictionary:dict];
            [arAds addObject: ads];
        }
        
        [result setObject:arAds forKey:KJsonElement_Ads];
    }
    
    //秒杀数组
    NSDictionary *dictSecKill = [dict objectForKey:KJsonElement_Seckills];
    array = [dictSecKill objectForKey:KJsonElement_Goods];
    if (array) {
        NSMutableArray *arKill = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dict in array) {
            ProductForCmd *pdt = [[ProductForCmd alloc] initWithDictionary:dict];
            [arKill addObject: pdt];
        }
        
        NSString *seconds   = [dictSecKill objectForKey:KJsonElement_Seconds];
        NSString *startdata = [dictSecKill objectForKey:KJsonElement_Start_Date];
        NSString *states    = [dictSecKill objectForKey:KJsonElement_States];
        
        NSDictionary *dictResult = @{KJsonElement_Seconds: seconds,
                                     KJsonElement_Start_Date: startdata,
                                     KJsonElement_States: states, 
                                     KJsonElement_ArrayKills: arKill};
        
        [result setObject:dictResult forKey:KJsonElement_Seckills];
    }
    
    //新品数组
    array = [dict objectForKey:KJsonElement_New_goods];
    if (array) {
        NSMutableArray *arPdt = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dict in array) {
            ProductForCmd *pdt = [[ProductForCmd alloc] initWithDictionary:dict];
            [arPdt addObject: pdt];
        }
        
        [result setObject:arPdt forKey:KJsonElement_New_goods];
    }
    
    //推荐商品数组
    array = [dict objectForKey:KJsonElement_Commond_goods];
    if (array) {
        NSMutableArray *arPdt = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dict in array) {
            ProductForCmd *pdt = [[ProductForCmd alloc] initWithDictionary:dict];
            [arPdt addObject: pdt];
        }
        
        [result setObject:arPdt forKey:KJsonElement_Commond_goods];
    }

    self.data = result;
}

-(void) parseProductData:(NSDictionary*)dict
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    
    //产品数组
    NSArray *array = [dict objectForKey:KJsonElement_Goods];
    if (array) {
        
        NSMutableArray *arProduct = [NSMutableArray arrayWithCapacity:1];

        for (NSDictionary *dict in array) {

            Product *pdt = [[Product alloc] initWithDictionary:dict];
            [arProduct addObject: pdt];
        }
        
        [result setObject:arProduct forKey:KJsonElement_Goods];
    }
    
    //门店数组
    array = [dict objectForKey:KJsonElement_Whouse];
    if (array) {
        NSMutableArray *arWhouse = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dict in array) {
            [arWhouse addObject:dict];
        }
        
        [result setObject:arWhouse forKey:KJsonElement_Whouse];
    }
    
    self.data = result;
}

-(void)parseProductDetail:(NSDictionary*)dict
{
    NSDictionary *data = [dict objectForKey:KJsonElement_Data];
    Product *pdt = [[Product alloc] initWithDictionary:data];
    self.data = pdt;
}

-(void)parseAreaWhouse:(NSDictionary*)dict
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    
    //区域数组
    NSArray *array = [dict objectForKey:KJsonElement_Areas];
    if (array) {
        
        NSMutableArray *arAreas = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dict in array) {
            Areas *area = [[Areas alloc] initWithDictionary:dict];
            [arAreas addObject: area];
        }
        
        [result setObject:arAreas forKey:KJsonElement_Areas];
    }
    
    //店铺数组
    array = [dict objectForKey:KJsonElement_Whouses];
    if (array) {
        
        NSMutableArray *arWhouses = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dict in array) {
            Whouse *whose = [[Whouse alloc] initWithDictionary:dict];
            [arWhouses addObject: whose];
        }
        
        [result setObject:arWhouses forKey:KJsonElement_Whouses];
    }
    
    self.data = result;
}

-(void)parseUserData:(NSDictionary *)dict
{
    //用户信息数组
   NSDictionary *userDict = [dict objectForKey:KJsonElement_User];
    
    User *user = [[User alloc] initWithDictionary:userDict];
    self.data = user;
}

//1.0版本废除
-(void)parseCouponListData:(NSDictionary *)dict
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    
    //礼品券数组
    NSArray *array = [dict objectForKey:KJsonElement_Data];
    if (array) {
        NSMutableArray *arCoupons = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dict in array) {
            Coupon *coupon = [[Coupon alloc] initWithDictionary:dict];
            [arCoupons addObject: coupon];
        }
        
        [result setObject:arCoupons forKey:KJsonElement_Data];
    }
    
    //数量页数
    NSString *count = [dict objectForKey:KJsonElement_Count];
    NSString *pages = [dict objectForKey:KJsonElement_Pages];
    [result setObject:count forKey:KJsonElement_Count];
    [result setObject:pages forKey:KJsonElement_Pages];

    self.data = result;
}

-(void)parseCouponDetailData:(NSDictionary *)dict
{
    NSDictionary *data = [dict objectForKey:KJsonElement_Data];
    Coupon *coupon = [[Coupon alloc] initWithDictionary:data];
    self.data = coupon;

}

-(void)parseMyOrdersData:(NSDictionary *)dict
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    
    //礼品券数组
    NSArray *array = [dict objectForKey:KJsonElement_Data];
    if (array) {
        NSMutableArray *arOrders = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dict in array) {
            Order *order = [[Order alloc] initWithDictionary:dict];
            [arOrders addObject: order];
        }
        
        [result setObject:arOrders forKey:KJsonElement_Data];
    }
    
    //数量页数
    NSString *count = [dict objectForKey:KJsonElement_Count];
    NSString *pages = [dict objectForKey:KJsonElement_Pages];
    
    [result setObject:count forKey:KJsonElement_Count];
    [result setObject:pages forKey:KJsonElement_Pages];
    
    self.data = result;
}

-(void)parseBSUPData:(NSDictionary *)dict
{
    @autoreleasepool {
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithCapacity:1];
        NSString *aVersion = [dict objectForKey:KJsonElement_AVersion];
        NSString *bVersion = [dict objectForKey:KJsonElement_BVersion];
        NSString *cVersion = [dict objectForKey:KJsonElement_CVersion];
        NSString *wVersion = [dict objectForKey:KJsonElement_WVersion];
        
        NSArray *array = nil;
        //区域数据
        if (aVersion) {
            [mutableDict setObject:aVersion forKey:KJsonElement_AVersion];
            
            array = [dict objectForKey:KJsonElement_Areas];
            if (array && array.count != 0) {
                NSMutableArray *arAreas = [NSMutableArray arrayWithCapacity:1];
                
                for (NSDictionary *dict in array) {
                    Areas *area = [[Areas alloc] initWithDictionary:dict];
                    [arAreas addObject: area];
                }
                
                [mutableDict setObject:arAreas forKey:KJsonElement_Areas];
            }
        }
        
        //品牌数据
        if (bVersion) {
            [mutableDict setObject:bVersion forKey:KJsonElement_BVersion];
            
            array = [dict objectForKey:KJsonElement_Brands];
            if (array && array.count != 0) {
                NSMutableArray *arBrands = [NSMutableArray arrayWithCapacity:1];
                
                for (NSDictionary *dict in array) {
                    Brand *brand = [[Brand alloc] initWithDictionary:dict];
                    [arBrands addObject: brand];
                }
                
                [mutableDict setObject:arBrands forKey:KJsonElement_Brands];
            }
        }
        
        //分类数据
        if (cVersion) {
            [mutableDict setObject:cVersion forKey:KJsonElement_CVersion];
            
            array = [dict objectForKey:KJsonElement_GClass];
            if (array && array.count != 0) {
                NSMutableArray *arClasses = [NSMutableArray arrayWithCapacity:1];
                
                for (NSDictionary *dict in array) {
                    GoodClass *class = [[GoodClass alloc] initWithDictionary:dict];
                    [arClasses addObject: class];
                }
                
                [mutableDict setObject:arClasses forKey:KJsonElement_GClass];
            }
        }
        
        //店铺数据
        if (wVersion) {
            [mutableDict setObject:wVersion forKey:KJsonElement_WVersion];
            
            array = [dict objectForKey:KJsonElement_Whouses];
            if (array && array.count != 0) {
                NSMutableArray *arWhouses = [NSMutableArray arrayWithCapacity:1];
                
                for (NSDictionary *dict in array) {
                    Whouse *whose = [[Whouse alloc] initWithDictionary:dict];
                    [arWhouses addObject: whose];
                }
                
                [mutableDict setObject:arWhouses forKey:KJsonElement_Whouses];
            }
        }
        
        self.data = mutableDict;
    }
}

-(void)parseActGoodsList:(NSDictionary*)dict
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    
    //产品数组
    NSArray *array = [dict objectForKey:KJsonElement_Data];
    if (array) {
        
        NSMutableArray *arProduct = [NSMutableArray arrayWithCapacity:1];
        
        for (NSDictionary *dict in array) {
            
            Product *pdt = [[Product alloc] initWithDictionary:dict];
            [arProduct addObject: pdt];
        }
        
        [result setObject:arProduct forKey:KJsonElement_Data];
    }
    
    //门店数组
    array = [dict objectForKey:KJsonElement_WList];
    if (array) {
        NSMutableArray *arWhouse = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dict in array) {
            [arWhouse addObject:dict];
        }
        
        [result setObject:arWhouse forKey:KJsonElement_WList];
    }
    
    self.data = result;
}

-(void)parseOrderDetailData:(NSDictionary *)dict
{
    NSDictionary *data = [dict objectForKey:KJsonElement_Data];
    Order *order = [[Order alloc] initWithDictionary:data];
    self.data = order;
    
}

-(void)parseGoodsByClass:(NSDictionary*)dict
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    
    //产品数组
    NSArray *array = [dict objectForKey:KJsonElement_Data];
    if (array) {
        
        NSMutableArray *arProduct = [NSMutableArray arrayWithCapacity:1];
        
        for (NSDictionary *dict in array) {
            
            Product *pdt = [[Product alloc] initWithDictionary:dict];
            [arProduct addObject: pdt];
        }
        
        [result setObject:arProduct forKey:KJsonElement_Data];
    }
    
    //品牌数组
    array = [dict objectForKey:KJsonElement_Brands];
    if (array) {
        
        NSMutableArray *arBrands = [NSMutableArray arrayWithCapacity:1];
        
        for (NSDictionary *dict in array) {
            
            Brand *brand = [[Brand alloc] initWithDictionary:dict];
            [arBrands addObject: brand];
        }
        
        [result setObject:arBrands forKey:KJsonElement_Brands];
    }
    
    //数量页数
    NSString *count = [dict objectForKey:KJsonElement_Count];
    NSString *pages = [dict objectForKey:KJsonElement_Pages];
    [result setObject:count forKey:KJsonElement_Count];
    [result setObject:pages forKey:KJsonElement_Pages];
    
    self.data = result;
}

-(void)parseGoods:(NSDictionary*)dict
{
    NSDictionary *data = [dict objectForKey:KJsonElement_Data];
    Product *pdt = [[Product alloc] initWithDictionary:data];
    self.data = pdt;
}

-(void)parseGetconsignee:(NSDictionary*)dict
{
//    NSDictionary *data = [dict objectForKey:KJsonElement_Data];
    NSArray *datas = [dict objectForKey:@"datas"];
    if (datas && datas.count != 0) {
        UserShipAddress *usa = [[UserShipAddress alloc] initWithDictionary:(NSDictionary *)datas[0]];
        self.data = usa;
    }
}

-(void)parseUpdateConsignee:(NSDictionary*)dict
{
    NSString *Id = [dict objectForKey:KJsonElement_Consignee_Id];
    self.data = Id;
}

-(void)parseBuy:(NSDictionary*)dict
{
    NSDictionary *data = [dict objectForKey:KJsonElement_Data];
    self.data = data;
}

-(void)parseActivityIndex:(NSDictionary*)dict
{
    NSDictionary *data = [dict objectForKey:KJsonElement_Data];
    self.data = data;
}

-(void)parseActivityLottery:(NSDictionary*)dict
{
    NSDictionary *data = [dict objectForKey:KJsonElement_Data];
    self.data = data;
}
-(void)parseActivityOrderList:(NSDictionary*)dict
{
    NSDictionary *data = dict;
    self.data = data;
}
@end
