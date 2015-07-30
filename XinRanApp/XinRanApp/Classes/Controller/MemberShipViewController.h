//
//  MemberShipViewController.h
//  XinRanApp
//
//  Created by mac on 14/12/31.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "BaseUIViewController.h"

@interface MemberShipViewController : BaseUIViewController
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headeImageView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong,nonatomic) NSString *phoneNumber;
@property (strong,nonatomic) NSString *headImage;
@property (strong,nonatomic) NSString *gradeName;
@end
