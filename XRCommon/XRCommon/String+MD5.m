//
//  String+MD5.m
//  XinRanApp
//
//  Created by tianbo on 14-12-17.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "String+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5String)

- (NSString*)md5
{
    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++)
        [ret appendFormat:@"%02x",result[i]];
    return ret;
}

@end
