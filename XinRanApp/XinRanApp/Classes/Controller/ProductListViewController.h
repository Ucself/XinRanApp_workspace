//
//  ProductListViewController.h
//  XinRanApp
//
//  Created by tianbo on 14-12-11.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
#import "ScrollingNavViewController.h"


//typedef NS_ENUM(int, ListType)
//{
//    ListType_Product = 0,
//    ListType_Category,
//};

@interface ProductListViewController : ScrollingNavViewController

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *cId;   //分类id
@property (strong, nonatomic) id params;     //获取列表请求参数
@end
