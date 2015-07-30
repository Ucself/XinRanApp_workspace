//
//  BaseDetailTableViewCell.h
//  XinRanApp
//
//  Created by mac on 14/12/11.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UILineLabel.h"
#import <XRUIView/UILineLabel.h>
//#import "TimerView.h"
#import <XRUIView/TimerView.h>

@interface ProdcutTableViewCell : UITableViewCell
@property (retain,nonatomic) IBOutlet UIImageView *headImageView;
@property (retain,nonatomic) IBOutlet UILabel *titleLabel;
@property (retain,nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILineLabel *oriPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyNumLabel;

@property (weak, nonatomic) IBOutlet UIImageView *gradeImageView;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;


-(void)setImageUrl:(NSString*)url;

-(void)setTimeInterval:(NSInteger)timeInterval;
@end
