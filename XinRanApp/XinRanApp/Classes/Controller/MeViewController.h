//
//  MeViewController.h
//  XinRanApp
//
//  Created by tianbo on 14-12-5.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "BaseUIViewController.h"

@interface MeViewController : BaseUIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)registerButton:(id)sender;
- (IBAction)loginButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *NoLoginView;
@property (weak, nonatomic) IBOutlet UIView *LoginView;
@end
