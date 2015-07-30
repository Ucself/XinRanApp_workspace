//
//  Encryption.h
//  DownloadFile
//
//  Created by  on 12-1-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSString;

@interface NSData(Encrypt)

- (NSData *)AESEncryptWithKey:(NSString *)key;   //加密
- (NSData *)AESDecryptWithKey:(NSString *)key;  //解密
- (NSString *)newStringInBase64FromData:(NSData*)data;           //追加64编码
+ (NSString*)base64encode:(NSString*)str;           //同上64编码

@end
