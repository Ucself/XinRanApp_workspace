//
//  PhoneQuery.m
//  XinRanApp
//
//  Created by tianbo on 15-1-28.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "PhoneQuery.h"
#import "JsonUtils.h"


@implementation PhoneQuery

+ (void)query:(NSString*)phonenumber finished:(void(^)(NSString *addr))finished
{
    //查询api
    //http://tcc.taobao.com/cc/json/mobile_tel_segment.htm?tel=15850781443
    
    NSString *url =@"http://tcc.taobao.com/cc/json/mobile_tel_segment.htm";
    url = [NSString stringWithFormat:@"%@?tel=%@", url, phonenumber];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   DBG_MSG(@"获取手机号归属地失败!");
                                   
                                   if (finished) {
                                       finished(@"");
                                   }
                                   
                               }else{
                                   NSData *recData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                                   if (recData) {
                                       //服务器正常返回数据
                                       //GBK编码
                                       NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                                       NSString *strings = [[NSString alloc] initWithData:recData encoding:gbkEncoding];
                                       strings= [strings stringByReplacingOccurrencesOfString:@"__GetZoneResult_ =" withString:@""];
                                       strings= [strings stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                       strings= [strings stringByReplacingOccurrencesOfString:@"mts" withString:@"\"mts\""];
                                       strings= [strings stringByReplacingOccurrencesOfString:@"province" withString:@"\"province\""];
                                       strings= [strings stringByReplacingOccurrencesOfString:@"catName" withString:@"\"catName\""];
                                       strings= [strings stringByReplacingOccurrencesOfString:@"telString" withString:@"\"telString\""];
                                       strings= [strings stringByReplacingOccurrencesOfString:@"areaVid" withString:@"\"areaVid\""];
                                       strings= [strings stringByReplacingOccurrencesOfString:@"ispVid" withString:@"\"ispVid\""];
                                       strings= [strings stringByReplacingOccurrencesOfString:@"carrier" withString:@"\"carrier\""];
                                       strings= [strings stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
                                       
                                       
                                       NSDictionary *dicInfor = [JsonUtils jsonToDcit:strings];
                                       if (finished && [[dicInfor allKeys] containsObject:@"province"]) {
                                           finished([dicInfor objectForKey:@"province"]);
                                           return;
                                       }
                                       if (finished) {
                                           finished(@"");
                                       }
                                   }
                               }
                           }];
}
@end
