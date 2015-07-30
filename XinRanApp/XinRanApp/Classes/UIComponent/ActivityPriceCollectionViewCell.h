//
//  ActivityPriceCollectionViewCell.h
//  XinRanApp
//
//  Created by libj on 15/2/3.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityPriceCollectionViewCell : UICollectionViewCell
//@interface ActivityPriceCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityInforUILable;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceUILable;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceUILable;

@end
