//
//  JsonBuilder.m
//  XinRanApp
//
//  Created by tianbo on 14-12-8.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "JsonBuilder.h"

#import <XRCommon/Data+Encrypt.h>
#import <XRCommon/String+MD5.h>
#import <XRCommon/JsonUtils.h>

@interface JsonBuilder ()

@property(nonatomic, strong) NSString *strKey;
@end

@implementation JsonBuilder

+(JsonBuilder*)sharedInstance
{
    static JsonBuilder *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

-(void)setCryptKey:(NSString*)key
{
    self.strKey = key;
}

//转换byte
+(NSData*) hexToBytes:(NSString*)str {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

+(NSString*)decrypt:(NSString*)json key:(NSString*)key
{
    NSData *cipher = [self hexToBytes:json];
    NSData *plain = [cipher AESDecryptWithKey:key];
    
    NSString *dest = [[NSString alloc] initWithData:plain encoding:NSUTF8StringEncoding];
    return dest;
}

#pragma mark- 解析json
+(NSDictionary*)dictionaryWithJson:(NSString*)json decode:(BOOL)isDecode key:(NSString*)key
{
    if (isDecode) {
        json = [self decrypt:json key:key];
    }

    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        return nil;
    }
    
    return [JsonUtils jsonDataToDcit:data];
}

+(NSString*)stringWithJson:(NSString*)json decode:(BOOL)isDecode key:(NSString*)key
{
    NSString *strRet = nil;
    if (isDecode) {
        strRet = [self decrypt:json key:key];
    }
    return strRet;
}

+(NSString*)tokenStringWithJosn:(NSString*)json decode:(BOOL)isDecode key:(NSString*)key
{
    NSString *token;
    NSDictionary *dict = [self dictionaryWithJson:json decode:isDecode key:key];
    if (dict) {
        token = [dict objectForKey:@"token"];
    }
    
    return token;
}

//生成json
+(NSString*)jsonWithDictionary:(NSDictionary*)dict
{
    JsonBuilder *parse = [[JsonBuilder alloc] init];
    NSString *json = [parse generateJsonWithDictionary:dict];
    return json;
}

#pragma mark- 生成json
-(NSString*)generateJsonWithDictionary:(NSDictionary*)dict;
{
    if (!dict) {
        return nil;
    }
    
    return [JsonUtils dictToJson:dict];
}

#pragma  mark- 生成请求数据
-(NSString*)getVersion
{
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSRange range = [version rangeOfString:@"."];
    NSString *mainVersion = [version substringToIndex:range.location];
    
    NSString *temp = [version substringFromIndex:range.location+1];
    NSString *subVersion = [[temp componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];;
    
    return [NSString stringWithFormat:@"%@.%@", mainVersion, subVersion];
}

-(NSString*)jsonWithLogin:(NSString*)name pwd:(NSString*)pwd type:(int)type
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:name forKey:KJsonElement_Name];
    [dict setObject:pwd forKey:KJsonElement_Pwd];
    [dict setObject:[NSString stringWithFormat:@"%d", type] forKey:KJsonElement_Type];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

//-(NSString*)jsonWithRegister:(NSString*)name pwd:(NSString*)pwd type:(int)type sphone:(NSString*)sphone
//{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
//    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
//    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
//    [dict setObject:name forKey:KJsonElement_Name];
//    [dict setObject:pwd forKey:KJsonElement_Pwd];
//    [dict setObject:[NSString stringWithFormat:@"%d", type] forKey:KJsonElement_Type];
//    if (sphone && sphone.length>0) {
//        [dict setObject:sphone forKey:KJsonElement_SPhone];
//    }
//    
//    
//    NSString *jsonString = [self generateJsonWithDictionary:dict];
//    return jsonString;
//
//}
-(NSString*)jsonWithRegister:(NSString*)name pwd:(NSString*)pwd type:(int)type sphone:(NSString*)sphone code:(NSString*)code
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:[self getVersion] forKey:KJsonElement_Version];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:name forKey:KJsonElement_Name];
    [dict setObject:pwd forKey:KJsonElement_Password];
    [dict setObject:code forKey:KJsonElement_Code];
    [dict setObject:[NSString stringWithFormat:@"%d", type] forKey:KJsonElement_Type];
    if (sphone && sphone.length>0) {
        [dict setObject:sphone forKey:KJsonElement_SPhone];
    }
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
    
}

-(NSString*)jsonWithLogout
{
    
    NSString *jsonString = @"";
    return jsonString;
}

-(NSString*)jsonWithChangePwd:(NSString*)oldPwd new:(NSString*)newPwd
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:oldPwd forKey:KJsonElement_OldPwd];
    [dict setObject:newPwd forKey:KJsonElement_NewPwd];

    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

-(NSString*)jsonWithSendRgeSMS:(NSString*)phoneNumber
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:phoneNumber forKey:KJsonElement_Phone];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

-(NSString*)jsonWithCoupons:(int)type page:(int)page
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:[NSString stringWithFormat:@"%d", type] forKey:KJsonElement_Type];
    [dict setObject:[NSString stringWithFormat:@"%d", page] forKey:KJsonElement_Page];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

-(NSString*)jsonWithGetAct
{
    NSString *jsonString = @"";
    return jsonString;
}

-(NSString*)jsonWithGetProductDetail:(NSString*)Id did:(NSString*)did
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    if (Id) {
        [dict setObject:Id forKey:KJsonElement_ID];
    }
    if (did) {
        [dict setObject:did forKey:KJsonElement_Did];
    }
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

-(NSString*)jsonWithGetAreawhouse
{
    NSString *jsonString = @"";
    return jsonString;
}

-(NSString*)jsonWithSendrcode:(NSString*)phoneNumber
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:phoneNumber forKey:KJsonElement_Phone];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

-(NSString*)jsonWithChangePwdBCode:(NSString*)phoneNumber code:(NSString*)code newPwd:(NSString*)newPwd
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:phoneNumber forKey:KJsonElement_Phone];
    [dict setObject:code forKey:KJsonElement_Code];
    [dict setObject:newPwd forKey:KJsonElement_NewPwd];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

-(NSString*)jsonWithGetCouponDetail:(NSString*)Id
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:Id forKey:KJsonElement_ID];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

-(NSString*)jsonWithSendgfcode:(NSString*)Id
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:Id forKey:KJsonElement_ID];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}


-(NSString*)jsonWithAdetail:(NSString*)activityId warehouseid:(NSString*)warehouseId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:activityId forKey:KJsonElement_ActivityId];
    [dict setObject:warehouseId forKey:KJsonElement_Warehouseid];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

-(NSString*)jsonWithAdetailClass:(int)type warehouseid:(NSString*)warehouseId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:[NSString stringWithFormat:@"%d", type] forKey:KJsonElement_Type];
    [dict setObject:warehouseId forKey:KJsonElement_Warehouseid];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

-(NSString*)jsonWithCheckCode:(NSString*)phoneNumber code:(NSString*)code
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:phoneNumber forKey:KJsonElement_Phone];
    [dict setObject:code forKey:KJsonElement_Code];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

-(NSString*)jsonWithPurchase:(NSString*)goodsid adwid:(NSString*)adwid
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:goodsid forKey:KJsonElement_GoodsId];
    if (adwid) {
        [dict setObject:adwid forKey:KJsonElement_Adwid];
    }
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

//获取用户默认店铺 接口
-(NSString*)jsonWithGetDefWHouse
{
    NSString *jsonString = @"";
    return jsonString;
}

// 设置用户默认店铺 接口
-(NSString*)jsonWithSetDefWHouse:(NSString*)wid
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:wid forKey:KJsonElement_WID];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

// 用户获取商城基本信息 接口
-(NSString*)jsonWithBSUP:(NSString*)a_version
               w_version:(NSString*)w_version
               c_version:(NSString*)c_version
               b_version:(NSString*)b_version
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    a_version  = a_version ? a_version : @"";
    b_version  = b_version ? b_version : @"";
    c_version  = c_version ? c_version : @"";
    w_version  = w_version ? w_version : @"";
    
    [dict setObject:a_version forKey:KJsonElement_AVersion];
    [dict setObject:w_version forKey:KJsonElement_WVersion];
    [dict setObject:c_version forKey:KJsonElement_CVersion];
    [dict setObject:b_version forKey:KJsonElement_BVersion];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

// 用户获取分类商品列表信息 接口
-(NSString*)jsonWithGoodsByClass:(NSString*)cId page:(int)page sort:(int)sort brandId:(NSString*)brandId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:cId forKey:KJsonElement_CID];
    [dict setObject:[NSString stringWithFormat:@"%d", page] forKey:KJsonElement_Page];
    [dict setObject:[NSString stringWithFormat:@"%d", sort] forKey:KJsonElement_Sort];
    [dict setObject:brandId forKey:KJsonElement_BrandId];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

// 用户获取活动专题商品列表信息 接口
-(NSString*)jsonWithActGoodsList:(NSString*)sId wId:(NSString*)wId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:sId forKey:KJsonElement_SID];
    if (wId && wId.length != 0) {
        [dict setObject:wId forKey:KJsonElement_WID];
    }
    
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

// 用户获取订单列表信息 接口
-(NSString*)jsonWithMyOrders:(int)type page:(int)page
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:[NSString stringWithFormat:@"%d", type] forKey:KJsonElement_Type];
    [dict setObject:[NSString stringWithFormat:@"%d", page] forKey:KJsonElement_Page];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

// 用户获取订单详情信息 接口
-(NSString*)jsonWithOrderDetail:(NSString*)Id
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:Id forKey:KJsonElement_ID];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

// 用户取消订单 接口
-(NSString*)jsonWithCancelOrder:(NSString*)Id
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:Id forKey:KJsonElement_ID];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

// 用户获取分类商品详细信息 接口
-(NSString*)jsonWithGoods:(NSString*)gId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:gId forKey:KJsonElement_GID];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}


/*****************************************************
 Version 1.1
 *****************************************************/

-(NSString*)jsonWithHomeInfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    //[dict setObject:KTerminalCode forKey:KJsonElement_Terminal];
    [dict setObject:@"2" forKey:KJsonElement_Terminal];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

// 常规商品购买
-(NSString*)jsonWithBuy:(NSString*)gId wId:(NSString*)wId num:(int)num
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:gId forKey:KJsonElement_GID];
    //[dict setObject:wId forKey:KJsonElement_WID];
    [dict setObject:[NSString stringWithFormat:@"%d", num] forKey:KJsonElement_Num];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

-(NSString*)jsonWithBuy2:(NSString*)gId num:(int)num consigneeId:(NSString*)consigneeId payType:(int)payType
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:gId forKey:KJsonElement_GID];
    [dict setObject:[NSString stringWithFormat:@"%d", num] forKey:KJsonElement_Num];
    [dict setObject:consigneeId forKey:KJsonElement_Consignee_Id];
    [dict setObject:[NSString stringWithFormat:@"%d", payType] forKey:KJsonElement_Pay_Type];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

// 秒杀商品购买
-(NSString*)jsonWithSecKillBuy:(NSString*)dId wId:(NSString*)wId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:dId forKey:KJsonElement_Did];
    [dict setObject:wId forKey:KJsonElement_WID];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

//获取收货 人信息列表
-(NSString*)jsonWithGetConsignee
{
    NSString *jsonString = @"";
    return jsonString;
}

//修改收货 人信息 接口
-(NSString*)jsonWithUpdateConsignee:(NSString*)Id
                  name:(NSString*)name
                areaId:(NSString*)areaId
                  addr:(NSString*)addr
                 phone:(NSString*)phone
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    if (Id && Id.length != 0) {
        [dict setObject:Id forKey:KJsonElement_ID];
    }
    
    [dict setObject:name forKey:KJsonElement_Name];
    [dict setObject:areaId forKey:KJsonElement_Area_Id];
    [dict setObject:addr forKey:KJsonElement_Address];
    [dict setObject:phone forKey:KJsonElement_Phone];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

//确认收货接口
-(NSString*)jsonWithFinishOrder:(NSString*)Id
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:Id forKey:KJsonElement_ID];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

//微信和支付宝序列化支付接口
-(NSString*)jsonWithweixinPay:(NSString*)pdtName price:(NSString*)price orderId:(NSString*)orderId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:pdtName forKey:KJsonElement_Body];
    [dict setObject:price forKey:KJsonElement_TotalFee];
    [dict setObject:orderId forKey:KJsonElement_Trade_no];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

//确认微信支付接口
-(NSString*)jsonWithCheckWxPay:(NSString*)orderId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    if (orderId && orderId.length > 0) {
        [dict setObject:orderId forKey:KJsonElement_Trade_no];
    }
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

/*****************************************************
 Version 1.4
 *****************************************************/

//抽奖活动接口
-(NSString*)jsonWithActivityIndex:(NSString*)userId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:userId forKey:KJsonElement_UId];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

//摇一摇接口
-(NSString*)jsonWithActivityLottery:(NSString*)userId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:userId forKey:KJsonElement_UId];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}

//奖品列表接口
-(NSString*)jsonWithActivityOrderList:(NSString*)userId page:(int)page
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:userId forKey:KJsonElement_UId];
    
    NSString *jsonString = [self generateJsonWithDictionary:dict];
    return jsonString;
}
@end
