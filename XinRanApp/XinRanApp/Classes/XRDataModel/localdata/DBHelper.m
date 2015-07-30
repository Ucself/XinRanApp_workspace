//
//  DBHelper.m
//  XinRanApp
//
//  Created by tianbo on 15-3-23.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "DBHelper.h"
#import <XRDBManager/FMDBUtils.h>

#import "User.h"
#import "UserWhouse.h"
#import "Whouse.h"
#import "Areas.h"
#import "GoodClass.h"
#import "Brand.h"

@implementation DBHelper

+(void)initDB
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        if (![FMDBUtils checkDB]) {
            if ([FMDBUtils createDB]) {
                [DBHelper createTable];
            }
        }
    });
}

+(void)createTable
{
    [UserWhouse createTable];
    [Whouse createTable];
    [Areas createTable];
    [Brand createTable];
    [GoodClass createTable];
}
@end
