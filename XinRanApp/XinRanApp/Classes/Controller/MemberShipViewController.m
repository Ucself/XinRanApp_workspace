//
//  MemberShipViewController.m
//  XinRanApp
//
//  Created by mac on 14/12/31.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "MemberShipViewController.h"
#import "User.h"

@interface MemberShipViewController ()

@end

@implementation MemberShipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}
- (void)setupUI
{
    User *user = [[EnvPreferences sharedInstance] getUserInfo];
    NSString *userName = user.username;
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",userName];
    switch ([user.grades intValue]) {
        case UserGrade_1:
            self.gradeLabel.text = [NSString stringWithFormat:@"会员等级 : %@",@"养生平民"];
            self.headeImageView.image = [UIImage imageNamed:@"icon_grade1"];
            break;
        case UserGrade_2:
            self.gradeLabel.text = [NSString stringWithFormat:@"会员等级 : %@",@"养生专家"];
            self.headeImageView.image = [UIImage imageNamed:@"icon_grade2"];
            
            break;
        case UserGrade_3:
            self.gradeLabel.text = [NSString stringWithFormat:@"会员等级 : %@",@"养生硕士"];
            self.headeImageView.image = [UIImage imageNamed:@"icon_grade3"];
            
            break;
        case UserGrade_4:
            self.gradeLabel.text = [NSString stringWithFormat:@"会员等级 : %@",@"养生博士"];
            self.headeImageView.image = [UIImage imageNamed:@"icon_grade4"];
            
            break;
            
        default:
            break;
    }

}

@end
