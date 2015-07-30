//
//  DiscoverViewController.m
//  XinRanApp
//
//  Created by tianbo on 15-5-21.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "DiscoverViewController.h"
#import "MeLoginViewController.h"
#import "ShakeViewController.h"

#import <XRUIView/OutlineLabel.h>
#import <XRUIView/UILabel+StringFrame.h>
#import "User.h"
#import "Shake.h"


@interface DiscoverViewController()
{
    int remaindNum;    //抽奖剩余次数
    int type;          //剩余次数类型  1，按次  2，按天
}

@property(weak, nonatomic) IBOutlet OutlineLabel *labelShop;
@property(weak, nonatomic) IBOutlet OutlineLabel *labelActivity;
@property(weak, nonatomic) IBOutlet UILabel *labelAddr;
@property(weak, nonatomic) IBOutlet UILabel *labelTime;
@property(weak, nonatomic) IBOutlet UIButton *btnShake;
@property(weak, nonatomic) IBOutlet UIButton *btnRecrod;
@end

@implementation DiscoverViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.labelShop.font = [UIFont fontWithName:@"FZJianZhi-M23S" size:30];
    self.labelActivity.font = [UIFont fontWithName:@"FZJianZhi-M23S" size:24];
    
    self.labelTime.backgroundColor = UIColorFromRGB(0xfb5b61);
    self.labelAddr.backgroundColor = UIColorFromRGB(0xfb5b61);

    CGSize size = [self.labelTime boundingRectWithSize:CGSizeMake(0, 0)];
    [self.labelTime remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(size.width+10).priorityHigh();
    }];
    
    self.btnShake.enabled = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbkwhite"] forBarMetrics:UIBarMetricsDefault];
    remaindNum = 0;
    
    NSString *token = [[EnvPreferences sharedInstance] getToken];
    if (!token || token.length == 0){
        self.btnShake.enabled = NO;
        
        self.labelActivity.text = @"欢乐抽奖";
        self.labelTime.text = @"当前活动仅支持门店会员";
        [self.labelAddr remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0).priorityHigh();
        }];
    }
    else {
        User *user = [[EnvPreferences sharedInstance] getUserInfo];
        [[NetInterfaceManager sharedInstance] activityIndex:user.userId];     //@"1502040949101110000002"
        [self startWait];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ShakeViewController *controller = [segue destinationViewController];
    if ([controller isKindOfClass:[ShakeViewController class]]) {
        controller.remaindNum = remaindNum;
        controller.type = type;
    }
}

#pragma mark-
- (IBAction)btnShakeClick:(id)sender {
    
    [self performSegueWithIdentifier:@"toShake" sender:nil];
}

- (IBAction)btnRecordClick:(id)sender {
    
    NSString *token = [[EnvPreferences sharedInstance] getToken];
    if (!token || token.length == 0){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        MeLoginViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        login.bReturnToRoot = NO;
        [self.navigationController pushViewController:login animated:YES];
        return;
    }

    [self performSegueWithIdentifier:@"toShakeRecrod" sender:nil];
}

#pragma mark- http request handler
-(void)httpRequestFinished:(NSNotification *)notification
{
    DBG_MSG(@"enter");
    [self stopWait];
    ResultDataModel *result = notification.object;
    if (!result) {
        DBG_MSG(@"http result is nil!");
        return;
    }
    
    
    switch (result.requestType) {
        //result  0，进行中  1，无活动  2，未开始（下期预告）  3，已结束（无下期，上期回顾）
        case KReqestType_ActivityIndex:
            
            
            if (result.resultCode == ShakeType_Beginning ||
                result.resultCode == ShakeType_NotBegin ||
                result.resultCode == ShakeTYpe_end) {
                
                NSDictionary *dict = result.data;
                
                self.btnShake.enabled = YES;
                self.labelActivity.text = [dict objectForKey:@"title"];
                self.labelAddr.text = [NSString stringWithFormat:@"活动门店: %@", [dict objectForKey:@"warehouse_name"]] ;
                self.labelTime.text = [NSString stringWithFormat:@"活动时间: %@", [dict objectForKey:@"activity_time"]];
                remaindNum = [[dict objectForKey:@"residue"] intValue];
                type = [[dict objectForKey:@"active_type"] intValue];
                
                CGSize strSize = [self.labelAddr.text sizeWithAttributes:@{NSFontAttributeName:self.labelAddr.font}];
                int width = strSize.width+10;
                if (strSize.width > self.view.frame.size.width-20) {
                    width = self.view.frame.size.width-50;
                }
                CGSize size = [self.labelAddr boundingRectWithSize:CGSizeMake(width, 0)];
                [self.labelAddr remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(size.width+10).priorityHigh();
                    make.height.equalTo(size.height+5).priorityHigh();
                }];
                
                size = [self.labelTime boundingRectWithSize:CGSizeMake(0, 0)];
                [self.labelTime remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(size.width+10).priorityHigh();
                }];
                
                
                if (result.resultCode == ShakeTYpe_end) {
                    self.btnShake.enabled = NO;
                    [self.btnShake setTitle:@"敬请期待" forState:UIControlStateNormal|UIControlStateDisabled];
                }
                else if (result.resultCode == ShakeType_NotBegin) {
                    self.btnShake.enabled = NO;
                    [self.btnShake setTitle:@"敬请期待" forState:UIControlStateNormal|UIControlStateDisabled];
                }
            }
            else if (result.resultCode == ShakeType_NoShake) {
                self.btnShake.enabled = NO;
                [self.btnShake setTitle:@"敬请期待" forState:UIControlStateNormal|UIControlStateDisabled];
                self.labelActivity.text = @"欢乐抽奖";
                self.labelTime.text = @"当前活动仅支持门店会员";
                [self.labelAddr remakeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(0).priorityHigh();
                }];
            }

            break;
        case KReqestType_Login:
            if (result.resultCode == 0) {
                //重新请求
                User *user = [[EnvPreferences sharedInstance] getUserInfo];
                [[NetInterfaceManager sharedInstance] activityIndex:user.userId];
            }
            break;
        default:
            break;
    }
}

-(void)httpRequestFailed:(NSNotification *)notification
{
    [super httpRequestFailed:notification];
}
@end
