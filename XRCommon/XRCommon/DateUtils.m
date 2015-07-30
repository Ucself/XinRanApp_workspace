//
//  DateUtils.m
//  H8
//
//  Created by tianbo on 14-12-5.
//  Copyright (c) 2014年 deshan.com All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

+(NSDateFormatter*)dateFormatterInstance
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    
    return formatter;
}

+ (BOOL) beforeNow:(NSString *)date{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *formatter = [DateUtils dateFormatterInstance];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *time = [formatter dateFromString:date];
    
    NSComparisonResult result = [now compare:time];
    if(result<0){
        return FALSE;
    }else{
        return TRUE;
    }
}

+ (NSString *) now{
    NSDate *now = [NSDate date];  
    NSDateFormatter *formatter = [DateUtils dateFormatterInstance];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];  
    NSString *time = [formatter stringFromDate:now];
    return time;
}


+ (NSString *) today{
    NSDate *now = [NSDate date];  
    NSDateFormatter *formatter = [DateUtils dateFormatterInstance];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *time = [formatter stringFromDate:now];
    return time;
}

+ (NSString *) todayfmtDDMM
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [DateUtils dateFormatterInstance];
    [formatter setDateFormat:@"dd/MM月"];
    NSString *time = [formatter stringFromDate:now];
    return time;
}

+ (NSString *) afterDays:(int)days date:(NSString *)date{

    //获取时间Time
    NSDateFormatter *formatter = [DateUtils dateFormatterInstance];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *now = [formatter dateFromString:date];
    
    //加days天
    NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([now timeIntervalSinceReferenceDate] + 24*3600*(days-1))];
    
    NSString *time = [formatter stringFromDate:newDate];
    return time;
}

+ (NSString *) clientId:(NSString *)projectId{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [DateUtils dateFormatterInstance];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *time = [formatter stringFromDate:now];
    return [NSString stringWithFormat:@"%@-%@",projectId,time ] ;
}


//转为时间格式
+ (NSDate *)stringToDate:(NSString *)time{
    NSDate *now = nil;//[NSDate date];
    NSDateFormatter *formatter = [DateUtils dateFormatterInstance];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    now = [formatter dateFromString:time];

    return now;
}

+ (NSDate *)stringToDateRT:(NSString *)time
{
    time = [time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDate *now = nil;//[NSDate date];
    NSDateFormatter *formatter = [DateUtils dateFormatterInstance];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    now = [formatter dateFromString:time];
    
    return now;
}

/**
 *  格式化时间到字符串
 *
 *  @param date   要格式化的日间
 *  @param format 指定格式   如：@"yyyy-MM-dd"
 *
 *  @return 格式化后的字符串
 */
+(NSString*) formatDate:(NSDate*)date format:(NSString*)format
{
    NSDateFormatter  *dateformatter = [DateUtils dateFormatterInstance];
    [dateformatter setDateFormat:format];
    NSString *  dateString = [dateformatter stringFromDate:date];
    
    return dateString;
}
@end
