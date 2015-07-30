//
//  MainViewController.m
//  XinRanApp
//
//  Created by tianbo on 14-12-4.
//  Copyright (c) 2014年 deshan.com All rights reserved.
//

#import "MainViewController.h"
#import "MyOrderViewController.h"
#import "OftenStoreViewController.h"
#import "SelectStoreViewController.h"

#import <XRCommon/PhoneQuery.h>

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabController];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoMyCouponsControler) name:@"NotifiyGotoMyCoupons" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoSelectStoreController:) name:@"NotifiyGotoMySelectStore" object:nil];
}

//初始化主页面
-(void)initTabController
{
    //设置字体
    [[UITabBarItem appearance] setTitleTextAttributes: @{NSFontAttributeName: [UIFont systemFontOfSize:13]}
                                             forState: UIControlStateNormal];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    UINavigationController *homeController = [storyboard instantiateInitialViewController];
    //UINavigationController *categoryController = [storyboard instantiateViewControllerWithIdentifier:@"CategoryNavigation"];
    
    storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    UINavigationController *meController = [storyboard instantiateInitialViewController];
    
    storyboard = [UIStoryboard storyboardWithName:@"More" bundle:nil];
    UINavigationController *moreController = [storyboard instantiateInitialViewController];
    
    NSArray *controllers = [NSArray arrayWithObjects:homeController,meController, moreController, nil];
    
    [self setViewControllers:controllers];
    
    self.tabBar.selectedImageTintColor = UIColor_DefGreen;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

//跳转到我的订单
-(void)gotoMyCouponsControler
{
    self.selectedIndex = 1;
    
    UINavigationController *naviController = [self.viewControllers objectAtIndex:1];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    MyOrderViewController *c = [storyboard instantiateViewControllerWithIdentifier:@"MyOrderViewController"];
    [naviController popToRootViewControllerAnimated:NO];
    [naviController.topViewController.navigationController pushViewController:c animated:YES];
}

//跳转到选择常用地址
-(void)gotoSelectStoreController:(NSNotification*)notification
{
    DBG_MSG(@"enter");
    
    NSString *phoneNumber = notification.object;
    
    [PhoneQuery query:phoneNumber finished:^(NSString *addr) {
        UINavigationController *naviController = [self.viewControllers objectAtIndex:2];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        OftenStoreViewController *c = [storyboard instantiateViewControllerWithIdentifier:@"OftenStoreViewController"];
        c.goSelStore = YES;
        c.arearName = addr;
        [naviController.topViewController.navigationController pushViewController:c animated:NO];
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
