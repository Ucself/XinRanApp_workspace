//
//  SetupViewController.m
//  XinRanApp
//
//  Created by mac on 14/12/23.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "SetupViewController.h"
#import "MeLoginViewController.h"
#import "ChangePassWordViewController.h"

#import <XRCommon/FileManager.h>
#import "User.h"


@interface SetupViewController ()<UIAlertViewDelegate>
{
    float cacheSize;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

- (IBAction)logoutButton:(id)sender;
@end

@implementation SetupViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSString *token = [[EnvPreferences sharedInstance] getToken];
    if (!token) {
        self.logoutButton.hidden = YES;
    }
    else
        self.logoutButton.hidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/ImageCache"];///Library/Caches/ImageCache
    NSDictionary * dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    DBG_MSG(@"-path:%@",path);
    DBG_MSG(@"大小：%@",[dict objectForKey:NSFileSize]);
    
    cacheSize =  [[dict objectForKey:NSFileSize] longValue]/1024.0;
}

-(void)controllerBackWithData:(id)data
{
    MeLoginViewController *login = [[self storyboard] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    login.bReturnToRoot = YES;
    [self.navigationController pushViewController:login animated:YES];
}


#pragma mark-
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 0.01;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma arguments
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"setupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        
        CGRect rt = CGRectInset(cell.bounds, 5, 3);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:rt];
        imageView.image = [UIImage imageNamed:@"cell_backImage"];
        [cell.contentView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(5);
            make.top.equalTo(5);
            make.bottom.equalTo(-5);
            
            make.right.equalTo(cell).offset(-5);
        }];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    
    if ((indexPath.section==0)&&(indexPath.row==0)) {
        cell.textLabel.text = @"修改密码";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        
        
        cell.textLabel.text = @"清除缓存";
        cell.detailTextLabel.textColor = [UIColor redColor];
        
        NSString *textSize = [NSString stringWithFormat:@"%.2fM",cacheSize];
        if ([textSize isEqual:@"0.00M"]) {
            textSize = @"0M";
            cell.detailTextLabel.textColor = [UIColor grayColor];
        }
        cell.detailTextLabel.text = textSize;
    }
    
    return cell;
}
#pragma mark---设置短头标题
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return self.titleArray[section];
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        label.text = @"   账户管理 :";
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:15];
      if (section == 1) {
        label.text = @"   缓存管理 :";
      }
     return label;
    
}
#pragma mark - didSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section==0)&&(indexPath.row==0)) {
        NSString *token =  [[EnvPreferences sharedInstance] getToken];
        if (token) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            //[self performSegueWithIdentifier:@"toChangePassWord" sender:self];
            ChangePassWordViewController *c = [[self storyboard] instantiateViewControllerWithIdentifier:@"ChangePassWordViewController"];
            c.delegate = self;
            [self.navigationController pushViewController:c animated:YES];
        }else{
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            //[self performSegueWithIdentifier:@"toLoginSetup" sender:self];
            MeLoginViewController *login = [[self storyboard] instantiateViewControllerWithIdentifier:@"LoginViewController"];
            login.bReturnToRoot = NO;
            [self.navigationController pushViewController:login animated:YES];
        }
        
    }
    else{
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [FileManager deleteImageCacheAtLibrary];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showTipsView:@"清除缓存成功!"];
                cacheSize = 0;
                [self.tableView reloadData];
            });
            
        });

    }
    
}
#pragma mark - 注销按钮
- (IBAction)logoutButton:(id)sender {
    [self showAlertWithTitle:@"提示" msg:@"是否退出当前用户?" showCancel:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }else{
        [[NetInterfaceManager sharedInstance] logout];
        [self startWait];
    }
}

- (void)finished
{
//    UIViewController *login = [[self storyboard] instantiateViewControllerWithIdentifier:@"LoginViewController"];
//    [self.navigationController pushViewController:login animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clearUserToken
{
    [EnvPreferences sharedInstance].token = nil;
    User *user = [[EnvPreferences sharedInstance] getUserInfo];
    user.pwd = @"";
    //user.arUserWhouses = nil;
    [[EnvPreferences sharedInstance] setUserInfo:user];
}

#pragma mark - httpRequestFinished

-(void)httpRequestFinished:(NSNotification *)notification
{
    [self stopWait];
    ResultDataModel *result = notification.object;
    if (!result) {
        DBG_MSG(@"http result is nil!");
        return;
    }

    switch (result.requestType) {
        case KReqestType_Logout:
                [self showTipsView:@"注销成功!"];
                [self clearUserToken];
                
                [self performSelector:@selector(finished) withObject:nil afterDelay:0.5];

            break;
        default:
            break;
    }
}
#pragma mark - httpRequestFailed
-(void)httpRequestFailed:(NSNotification *)notification
{
    //[super httpRequestFailed:notification];
    
    [self stopWait];
    ResultDataModel *result = notification.object;
    if (!result) {
        DBG_MSG(@"http result is nil!");
        return;
    }

    switch (result.requestType) {
        case KReqestType_Logout:

                [self showTipsView:@"注销成功!"];
                [self clearUserToken];
                
                [self performSelector:@selector(finished) withObject:nil afterDelay:0.5];
            break;
        default:
            break;
    }

}

@end
