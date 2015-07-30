//
//  BaseDetailTableViewCell.h
//  XinRanApp
//
//  Created by mac on 14/12/11.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <XRUIView/UILineLabel.h>
#import <XRUIView/TimerView.h>

@protocol NewProductChildTableCellDelegate <NSObject>

@optional
//点击秒杀
-(void)clickNewProductCell:(NSInteger)indexPath;

@end

@interface NewProductChildTableViewCell : UITableViewCell
@property (retain,nonatomic) IBOutlet UIImageView *headImageView;
@property (retain,nonatomic) IBOutlet UILabel *titleLabel;
@property (retain,nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *haveBuyLabel;
@property (assign, nonatomic) id delegate;

-(void)setImageUrl:(NSString*)url;
@end
