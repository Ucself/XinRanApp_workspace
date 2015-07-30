//
//  ActivityProductCell.h
//  XinRanApp
//
//  Created by tianbo on 15-2-5.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UILineLabel.h"
#import <XRUIView/UILineLabel.h>
//#import "TimerView.h"
#import <XRUIView/TimerView.h>

@interface ActivityProductCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *lablePriceAct;
@property (weak, nonatomic) IBOutlet UILineLabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet TimerView *timerView;
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;




-(void)setImageUrl:(NSString*)url;

-(void)setTimeInterval:(NSInteger)timeInterval;
@end
