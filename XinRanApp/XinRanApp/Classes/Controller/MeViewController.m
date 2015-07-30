//
//  MeViewController.m
//  XinRanApp
//
//  Created by tianbo on 14-12-5.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "MeViewController.h"

#import "User.h"
#import "MyOrderViewController.h"
#import <XRUIView/UIbutton+ImageLabel.h>
#import "MemberShipViewController.h"
#import "SelectStoreViewController.h"
#import "OrderDetailsViewController.h"
#import "ShakeViewController.h"

@interface MeViewController () <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *iconArray;


- (IBAction)setupButton:(id)sender;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetUI];
    [self setupNavBar];
}

-(NSArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSArray arrayWithObjects:@"我的订单",@"管理收货地址", @"更多", nil];//@"会员等级"
    }
    return _dataArray;
}
-(NSArray *)iconArray
{
    if (_iconArray == nil) {
        _iconArray = [NSArray arrayWithObjects:@"icon_mycoupon",@"icon_location2",@"icon_more", nil];
    }
    return _iconArray;
}

-(void)dealloc
{
 
}

-(void)setupNavBar
{
    UIButton *btnR = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnR setFrame:CGRectMake(0, 0, 50, 40)];
    [btnR setImage:[UIImage imageNamed:@"icon_mysetting"] withTitle:@"设置" forState:UIControlStateNormal];
    [btnR addTarget:self action:@selector(setupButton:) forControlEvents:UIControlEventTouchUpInside];
    [btnR setTintColor:UIColor_DefGreen];
    
    //[btnR setBackgroundColor:[UIColor yellowColor]];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:btnR];
    self.navigationItem.rightBarButtonItem = barItem;
}
- (void)resetUI
{
    NSString *loginToken = [[EnvPreferences sharedInstance] getToken];
    User *user = [[EnvPreferences sharedInstance] getUserInfo];
    NSString *userName = user.username;
    if (loginToken) {
        self.LoginView.hidden = NO;
        self.NoLoginView.hidden = YES;
        self.userNameLabel.text = [NSString stringWithFormat:@" %@",userName];
        
        if (!user.card_no || user.card_no.length == 0) {
            self.cardNumLabel.text = @"无";
        }
        else{
            self.cardNumLabel.text = user.card_no;
        }
        
//        switch ([user.grades intValue]) {
//            case UserGrade_1:
//                //self.rankLabel.text = [NSString stringWithFormat:@"会员等级 : %@",@"养生平民"];
//                self.rankLabel.text = @"";
//                self.headImage.image = [UIImage imageNamed:@"icon_grade1"];
//                break;
//            case UserGrade_2:
//                //self.rankLabel.text = [NSString stringWithFormat:@"会员等级 : %@",@"养生专家"];
//                self.rankLabel.text = @"";
//                self.headImage.image = [UIImage imageNamed:@"icon_grade2"];
//                
//                break;
//            case UserGrade_3:
//                //self.rankLabel.text = [NSString stringWithFormat:@"会员等级 : %@",@"养生硕士"];
//                self.rankLabel.text = @"";
//                self.headImage.image = [UIImage imageNamed:@"icon_grade3"];
//                
//                break;
//            case UserGrade_4:
//                //self.rankLabel.text = [NSString stringWithFormat:@"会员等级 : %@",@"养生博士"];
//                self.rankLabel.text = @"";
//                self.headImage.image = [UIImage imageNamed:@"icon_grade4"];
//                
//                break;
//                
//            default:
//                break;
//        }
        
    }
    else{
        self.LoginView.hidden = YES;
        self.NoLoginView.hidden = NO;
    }

}
#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self resetUI];
}

#pragma mark - UITableview delegate mothed
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"客服热线: 400-111-9797" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_cell_n"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnServiceClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.left.equalTo(10);
        make.height.equalTo(40);
        make.right.equalTo(-10);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor orangeColor];
    label.text = @"热线服务时间: 周一至周五 上午10:00 - 下午17:00";
    [view addSubview:label];
    
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.bottom).offset(5);
        make.left.equalTo(10);
        make.height.equalTo(20);
        make.right.equalTo(-10);
    }];
    
    return view;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.iconArray[indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *loginToken = [[EnvPreferences sharedInstance] getToken];
    if (indexPath.row == 0) {
        if (loginToken)
            [self performSegueWithIdentifier:@"toMeGift" sender:self];
        else
            [self performSegueWithIdentifier:@"toLogin" sender:self];
    }
    else if (indexPath.row == 1) {
        if (loginToken)
            [self performSegueWithIdentifier:@"toEditorAdress" sender:self];
        else
            [self performSegueWithIdentifier:@"toLogin" sender:self];
    }
    else if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"toMore" sender:self];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}


#pragma mark- httpRequestFinished
-(void)httpRequestFinished:(NSNotification *)notification
{
    DBG_MSG(@"enter");
    [self stopWait];
    ResultDataModel *result = notification.object;
    if (!result) {
        DBG_MSG(@"http result is nil!");
        return;
    }
    
    //NSDictionary *dict = result.data;
    switch (result.requestType) {
        case KReqestType_Login:
            if (result.resultCode == 0) {
                [self resetUI];
            }
            break;
        default:
            break;
    }
}
#pragma mark- httpRequestFailed
-(void)httpRequestFailed:(NSNotification *)notification
{
    
}
#pragma mark -
- (IBAction)registerButton:(id)sender {
    [self performSegueWithIdentifier:@"toRegister" sender:self];
}

- (IBAction)loginButton:(id)sender {
    //[self performSegueWithIdentifier:@"toLogin" sender:self];
    UIViewController *login = [[self storyboard] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:login animated:YES];
}

- (IBAction)setupButton:(id)sender {
    [self performSegueWithIdentifier:@"toSetup" sender:self];
}

- (IBAction)btnServiceClick:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拨打: 400-111-9797", nil];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4001119797"]];
    }
}
@end
