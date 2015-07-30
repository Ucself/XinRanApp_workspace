//
//  User.h
//  XinRanApp
//
//  Created by tianbo on 14-12-8.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//
// 用户类

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "Whouse.h"

typedef NS_ENUM(int, USERTYPE)
{
    USERTYPE_Junior = 0,
    USERTYPE_Senior,
};

typedef NS_ENUM(int, UserGrade)
{
    UserGrade_1 = 1,
    UserGrade_2,
    UserGrade_3,
    UserGrade_4,
};

@interface User : BaseModel
{
    
}

@property(nonatomic, strong) NSString *userId;              //用户id
@property(nonatomic, strong) NSString *username;           //用户名
@property(nonatomic, strong) NSString *pwd;                //密码
@property(nonatomic, strong) NSString *phone;              //手机号码
@property(nonatomic, strong) NSString *email;              //邮箱
@property(nonatomic, assign) NSNumber *grades;             //级别
@property(nonatomic, strong) NSString *card_no;            //会员卡号


@property(nonatomic, strong) NSArray *arUserWhouses;           //用户使用过的店铺Id
@end


