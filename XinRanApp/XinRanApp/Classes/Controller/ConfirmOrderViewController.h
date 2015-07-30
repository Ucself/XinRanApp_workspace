//
//  ConfirmOrderViewController.h
//  XinRanApp
//
//  Created by tianbo on 14-12-25.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "BaseUIViewController.h"
#import "Product.h"
#import "Whouse.h"
#import "Order.h"

@interface ConfirmOrderViewController : BaseUIViewController

@property (strong, nonatomic) Product *product;
@property (strong, nonatomic) Whouse *whouse;
@property (assign, nonatomic) int buyNum;

@end
