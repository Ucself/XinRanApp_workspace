//
//  BCBaseObject.h
//  ChangQu
//
//  Created by 牛 方健 on 13-4-17.
//  Copyright (c) 2013年 BC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCBaseObject : NSObject



/*
 *  用正则判断用户名，是否2－16位
 */
+ (BOOL) checkInputUserName:(NSString *)text;


/*
 *  用正则判断邮箱
 */
+ (BOOL) checkInputEmail:(NSString *)text;

/*
 *  用正则判断密码，请输入6-16位字母和数字,符号两种以上组合
 */
+ (BOOL) checkInputPassword:(NSString *)text;

/*
 *  得到字符串长度 中英文混合情况下
 */
+(int)lengthToInt:(NSString*)string;

/*
 *  将字符串进行MD5加密，返回加密后的字符串
 */
+ (NSString *) MD5Hash:(NSString*) aString;

/*
 *  用正则判断手机号
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/*
 *  URL解码
 */
+ (NSString *)URLDecodedString:(NSString*)stringURL;

///*
// *  图片变灰
// */
//+ (UIImage *)grayscaleWithImage:(UIImage *)image;

///*
// *  判断字符串是否是数字组成
// */
+ (BOOL)isNumberStr:(NSString*)string;

/*
 *  判断手机型号是否是iPhone5；
 */
+ (BOOL)isiPhone5Height:(NSInteger)height;

/*
 *  判断是否是身份证
 *  需要-(BOOL)isNumberStr:(NSString*)string配合
 */
+(BOOL)isPersonCard:(NSString*)string;

/*
 *  判断String中是否都是数字
 */
-(BOOL)isNumberStr:(NSString*)string;


/**
 *  判断字符串是否全是数字与字母
 */
+(BOOL)isNumberandLetterStr:(NSString*)string;
/*
 *  请输入6-16位字母和数字,符号两种以上组合
 */
+ (BOOL)isChineseStr:(NSString *)string;


/**
 *  判断字符串是否包含中文
 */
+(BOOL)isHasChineseCharacter:(NSString*)string;
@end
