//
//  MeLoginViewController.m
//  XinRanApp
//
//  Created by mac on 14/12/17.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "MeLoginViewController.h"
#import "MeViewController.h"
#import "ChangePassWordViewController.h"

#import <XRCommon/BCBaseObject.h>
#import <XRUIView/UILineLabel.h>
#import "User.h"
#import "UserWhouse.h"

@interface MeLoginViewController ()<UITextFieldDelegate>
- (IBAction)quickRegisterButton:(id)sender;
- (IBAction)forgetPasswordButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *forgetPassWordLable;


@end

@implementation MeLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}
#pragma mark - setupUI
- (void)setupUI
{
    //self.phoneNumberTextField.text = @"13880987644";
    //self.passwordTextField.text = @"123456";
    
//    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    phoneLabel.text = @"  手机号码   :";
//    phoneLabel.font = [UIFont systemFontOfSize:14];
//    //phoneLabel.textColor = [UIColor grayColor];
//    phoneLabel.textAlignment = NSTextAlignmentCenter;
//    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    passwordLabel.text = @"  密       码   :";
//    passwordLabel.font = [UIFont systemFontOfSize:14];
//    //passwordLabel.textColor = [UIColor grayColor];
//    passwordLabel.textAlignment = NSTextAlignmentCenter;
//    
//    self.phoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
//    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
//    self.phoneNumberTextField.leftView = phoneLabel;
//    self.passwordTextField.leftView = passwordLabel;
    
    User *user = [[EnvPreferences sharedInstance] getUserInfo];
    if (user && user.phone.length) {
        self.phoneNumberTextField.text = user.phone;
    }
    //忘记密码添加点击功能
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetPasswordButton:)];
    [self.forgetPassWordLable addGestureRecognizer:tapGesture];
    [self.forgetPassWordLable setUserInteractionEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 快速注册按钮
- (IBAction)quickRegisterButton:(id)sender {
    [self performSegueWithIdentifier:@"toQuickRegister" sender:self];
}

#pragma mark - 忘记密码按钮
- (void)forgetPasswordButton:(id)sender {
    [self performSegueWithIdentifier:@"toForgetPassWord" sender:self];
}

#pragma mark - 立即登录
- (IBAction)nowLoginButton:(id)sender {
    DBG_MSG(@"电话号码：%@",self.phoneNumberTextField.text );
    DBG_MSG(@"密码：%@",self.passwordTextField.text );
    NSString *phoneNumber = self.phoneNumberTextField.text;
    NSString *passWord = self.passwordTextField.text;

    //对密码进行MD5加密
    //NSString *passWord = [BCBaseObject MD5Hash:self.passwordTextField.text];
    if ([phoneNumber isEqualToString:@""] && [passWord isEqualToString:@""]) {
        [self showTipsView:@"账户与密码不能为空!"];
        return;
    }
    if ([phoneNumber isEqualToString:@""] && ![passWord isEqualToString:@""]) {
        [self showTipsView:@"请输入您的手机号码或会员卡号!"];
        return;
    }
    if (![phoneNumber isEqualToString:@""] && [passWord isEqualToString:@""]) {
        [self showTipsView:@"请输入您的密码!"];
        return;
    }
    
    if (phoneNumber.length < 8 || phoneNumber.length > 11) {
        [self showTipsView:@"手机号码或会员卡号为8-11个字符!"];
        return;
    }
//    if (![BCBaseObject isMobileNumber:phoneNumber]) {
//            [self showTipsView:@"请输入正确的手机号码"];
//            return;
//    }
    //登录本地不需要验证
//    if(![BCBaseObject checkInputPassword:passWord]) {
//        [self showTipsView:@"请输入6-16位字母和数字,符号两种以上组合!"];
//        return;
//    }
    [[NetInterfaceManager sharedInstance] login:self.phoneNumberTextField.text pwd:self.passwordTextField.text type:LoginType_Email];
    [self startWait];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneNumberTextField) {
        if (range.length == 1) {
            return YES;
        }
        
        if (range.location >= 11) {
            //[self showTipsView:@"手机号码为11位!"];
            return NO;
        }
        
        //		const char* ch = [string UTF8String];
        //		if ((*ch >= 'A' && *ch <= 'Z') || (*ch >= 'a' && *ch <= 'z') || (*ch >= '0' && *ch <= '9')) {
        //			return YES;
        //		}
        //		else {
        //			return NO;
        //		}
        
    }
    else if (textField == self.passwordTextField) {
        if (range.length == 1) {
            return YES;
        }
        
        if (range.location >= 16) {
            //[self showTipsView:@"密码最大为16位!"];
            return NO;
        }
    }
    
    return YES;
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
        case KReqestType_Login:
            if (result.resultCode == 0) {
                
                User *user = result.data;
                user.pwd = self.passwordTextField.text;
                
                //判断是否为用户id对应的店铺id
                UserWhouse *userWhouse = [UserWhouse userWhouseWithId:user.userId];
                if (userWhouse) {
                    NSString *whouseID = userWhouse.whouseId;
                    Whouse *whouse = [Whouse whouseWithId:whouseID];
                    if (whouse) {
                        NSArray *uArray = [NSArray arrayWithObject:whouse];
                        user.arUserWhouses = uArray;
                    }
                }
                
                [[EnvPreferences sharedInstance] setUserInfo:user];
                
                if (self.bReturnToRoot) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }
            else if (result.resultCode == 1) {
                [self showTipsView:@"请填写正确用户名与密码!"];
            }
            else{
                [self showTipsView:@"登录失败!"];
                DBG_MSG(@"result.code=%d, result.desc=%@", result.resultCode, result.desc);
            }
            break;
               default:
            break;
    }
}
#pragma mark - httpRequestFaild
-(void)httpRequestFailed:(NSNotification *)notification
{
    [super httpRequestFailed:notification];
}

//点击键盘return回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //回收键盘
    [textField resignFirstResponder];
    return YES;
}

//点击背景回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[[event allTouches] anyObject];
    if (touch.tapCount >=1) {
        [self.phoneNumberTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
    }
}
- (IBAction)dismissKeyboard:(id)sender {
    [self.phoneNumberTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}
@end
