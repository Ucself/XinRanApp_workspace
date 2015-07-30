//
//  XDPayOrder.m
//  XinRanApp
//
//  Created by tianbo on 15-3-16.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "XDPayOrder.h"

@implementation XDPayOrder

@end


/*********************************************************************/
#pragma mark- 微信订单类
@implementation XDWeChatOrder : XDPayOrder

@end


/*********************************************************************/
#pragma mark- 支付宝订单类

@implementation XDAliOrder : XDPayOrder

-(instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

//- (NSString *)description {
//    NSMutableString * discription = [NSMutableString string];
//    if (self.partner) {
//        [discription appendFormat:@"partner=\"%@\"", self.partner];
//    }
//    
//    if (self.seller) {
//        [discription appendFormat:@"&seller_id=\"%@\"", self.seller];
//    }
//    if (self.Id) {
//        [discription appendFormat:@"&out_trade_no=\"%@\"", self.Id];
//    }
//    if (self.productName) {
//        [discription appendFormat:@"&subject=\"%@\"", self.productName];
//    }
//    
//    if (self.productDescription) {
//        [discription appendFormat:@"&body=\"%@\"", self.productDescription];
//    }
//    if (self.price) {
//        [discription appendFormat:@"&total_fee=\"%@\"", self.price];
//    }
//    if (self.notifyURL) {
//        [discription appendFormat:@"&notify_url=\"%@\"", self.notifyURL];
//    }
//    
//    if (self.service) {
//        [discription appendFormat:@"&service=\"%@\"",self.service];//mobile.securitypay.pay
//    }
//    if (self.paymentType) {
//        [discription appendFormat:@"&payment_type=\"%@\"",self.paymentType];//1
//    }
//    
//    if (self.inputCharset) {
//        [discription appendFormat:@"&_input_charset=\"%@\"",self.inputCharset];//utf-8
//    }
//    if (self.itBPay) {
//        [discription appendFormat:@"&it_b_pay=\"%@\"",self.itBPay];//30m
//    }
//    if (self.showUrl) {
//        [discription appendFormat:@"&show_url=\"%@\"",self.showUrl];//m.alipay.com
//    }
//    if (self.rsaDate) {
//        [discription appendFormat:@"&sign_date=\"%@\"",self.rsaDate];
//    }
//    if (self.appID) {
//        [discription appendFormat:@"&app_id=\"%@\"",self.appID];
//    }
//    for (NSString * key in [self.extraParams allKeys]) {
//        [discription appendFormat:@"&%@=\"%@\"", key, [self.extraParams objectForKey:key]];
//    }
//    return discription;
//}

@end