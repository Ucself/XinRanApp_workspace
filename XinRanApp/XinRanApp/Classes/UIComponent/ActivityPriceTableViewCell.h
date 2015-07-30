//
//  ActivityPriceTableViewCell.h
//  XinRanApp
//
//  Created by libj on 15/2/3.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductForCmd;

typedef void (^JumpToDetails)(ProductForCmd *productForCmd);

@interface ActivityPriceTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UICollectionView *activityPriceCollectionView;
//collectionView数据源
@property (strong, nonatomic) NSMutableArray *dataArray;
//产品详情跳转
@property (strong, nonatomic) JumpToDetails jumpToDetails;

@end
