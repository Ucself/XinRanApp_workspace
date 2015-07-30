//
//  MoreDetailViewController.h
//  XinRanApp
//
//  Created by mac on 14/12/16.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"

typedef NS_ENUM(int, MoreDetailViewType)
{
    MoreDetailViewType_PayMethod = 0,
    MoreDetailViewType_DistributionMethod,
    MoreDetailViewType_AuthenticGuarantee,
    MoreDetailViewType_ReturnGoods,
    MoreDetailViewType_AboutUs,
};

@interface MoreDetailViewController : BaseUIViewController

@property (assign, nonatomic) MoreDetailViewType type;

@end
