//
//  HomeViewController.h
//  XinRanApp
//
//  Created by tianbo on 14-12-5.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "BaseUIViewController.h"
//#import "RefreshTableView.h"
#import <XRUIView/RefreshTableView.h>

@interface HomeViewController : BaseUIViewController

@property (weak, nonatomic) IBOutlet RefreshTableView *tableView;

@end
