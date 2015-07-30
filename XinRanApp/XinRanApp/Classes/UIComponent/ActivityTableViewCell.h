//
//  BaseUITableViewCell.h
//  XinRanApp
//
//  Created by mac on 14/12/10.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//   自定义的首页的表格视图

#import <UIKit/UIKit.h>

@interface ActivityTableViewCell : UITableViewCell

@property (retain,nonatomic) IBOutlet UIImageView *bkImageView;
@property (retain,nonatomic) IBOutlet UILabel *LableTitle;
@property (retain,nonatomic) IBOutlet UILabel *LableState;


-(void)setImageUrl:(NSString*)url;
@end
