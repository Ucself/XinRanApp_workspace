//
//  BrandTableViewCell.h
//  XinRanApp
//
//  Created by libj on 15/2/7.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandTableViewCell : UITableViewCell

@property (assign,nonatomic) BOOL isSelected;
@property (strong,nonatomic) UILabel *lableName;
@property (strong,nonatomic) UIImageView *imageViewIcon;

//图标更换
-(void)setIsSelected:(BOOL)isSelected;
@end
