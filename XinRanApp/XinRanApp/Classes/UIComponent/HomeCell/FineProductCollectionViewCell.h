//
//  FineProductCollectionViewCell.h
//  XinRanApp
//
//  Created by tianbo on 15-4-9.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FineProductCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) UIImageView *thumbView;
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UILabel *price;
@property(nonatomic, strong) UILabel *saled;

-(void)showTopView;
-(void)showBottomView;
-(void)showProductView;
@end
