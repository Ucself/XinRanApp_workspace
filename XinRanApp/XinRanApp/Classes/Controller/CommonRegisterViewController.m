//
//  CommonRegisterViewController.m
//  XinRanApp
//
//  Created by mac on 14/12/31.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "CommonRegisterViewController.h"
#import "MeLoginViewController.h"
#import "SelectStoreViewController.h"


#import "User.h"
#import "Areas.h"

#import <XRCommon/BCBaseObject.h>
#import <XRCommon/PhoneQuery.h>



@interface CommonRegisterViewController ()<UITextFieldDelegate>
- (IBAction)quickRegisterButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *commonPhoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *commonPassWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *commonEnterPassWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *nowRegisterButton;


@property (nonatomic, assign) BOOL selected;          //用户协议选中标记
@property (nonatomic, assign) BOOL bSelfRequest;     //注册请求标记

- (IBAction)goLoginButton:(id)sender;
@end

@implementation CommonRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selected = YES;
    [self setupUI];
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"selected"];
}

- (void)setupUI
{
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
    phoneLabel.text = @"手机号码   :";
    phoneLabel.font = [UIFont systemFontOfSize:14];
    //phoneLabel.textColor = [UIColor grayColor];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
    passwordLabel.text = @"密       码   :";
    passwordLabel.font = [UIFont systemFontOfSize:14];
    //passwordLabel.textColor = [UIColor grayColor];
    passwordLabel.textAlignment = NSTextAlignmentCenter;
    UILabel *enterPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
    enterPasswordLabel.text = @"确认密码   :";
    enterPasswordLabel.font = [UIFont systemFontOfSize:14];
    //enterPasswordLabel.textColor = [UIColor grayColor];
    enterPasswordLabel.textAlignment = NSTextAlignmentCenter;
    
    self.commonPhoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    self.commonPassWordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.commonPhoneNumberTextField.leftView = phoneLabel;
    self.commonPassWordTextField.leftView = passwordLabel;
    self.commonEnterPassWordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.commonEnterPassWordTextField.leftView = enterPasswordLabel;
    
    [self addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    [self.agreeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -29, 0, -29)];
    [self.agreeButton setTitle:@"同意" forState:UIControlStateNormal];
    [self.agreeButton setImage:[UIImage imageNamed:@"chenk_h"] forState:UIControlStateNormal];

}
#pragma mark - check agreeButton
- (IBAction)agreeButton:(id)sender {
    self.selected = !self.selected;
    if (self.selected == YES) {
        [self.agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        [self.agreeButton setImage:[UIImage imageNamed:@"chenk_h"] forState:UIControlStateNormal];
        [self.agreeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -29, 0, -29)];
        
    }else{
        [self.agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        [self.agreeButton setImage:[UIImage imageNamed:@"chenk_n"] forState:UIControlStateNormal];
        [self.agreeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -29, 0, -29)];
        
        
    }
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if (self.selected == NO) {
        self.nowRegisterButton.enabled = NO;
    }else{
        
        self.nowRegisterButton.enabled = YES;
    }
}
- (IBAction)agreementButtonClick:(id)sender {
    
    [self performSegueWithIdentifier:@"toAgreement" sender:nil];
}




#pragma mark - 点击return回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    DBG_MSG(@"shouldReturn");
    //回收键盘
    [textField resignFirstResponder];
    return YES;
}
//#pragma mark - 点击背景回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[[event allTouches] anyObject];
    if (touch.tapCount >=1) {
        [self.commonPhoneNumberTextField resignFirstResponder];
        [self.commonPassWordTextField resignFirstResponder];
        [self.commonEnterPassWordTextField resignFirstResponder];
    }
}
//点击立即注册回收键盘
- (IBAction)dismissKeyboard:(id)sender {
    [self.commonPhoneNumberTextField resignFirstResponder];
    [self.commonPassWordTextField resignFirstResponder];
    [self.commonEnterPassWordTextField resignFirstResponder];
}
#pragma mark - 立即注册
- (IBAction)commonRegisterPassWordButton:(id)sender {
    DBG_MSG(@"电话号码：%@",self.commonPhoneNumberTextField.text);
    DBG_MSG(@"密码：%@",self.commonPassWordTextField.text);
    DBG_MSG(@"密码：%@",self.commonEnterPassWordTextField.text);

    NSString *phoneNumber = self.commonPhoneNumberTextField.text;
    NSString *passWord = self.commonPassWordTextField.text;
    NSString *enterPassWord = self.commonEnterPassWordTextField.text;
    if (![BCBaseObject isMobileNumber:phoneNumber]) {
        [self showTipsView:@"手机号码不符合要求!"];
        return;
    }
    
    if (![enterPassWord isEqualToString:passWord]) {
        [self showTipsView:@"前后密码不一致!"];
        return;
    }
    
    if (!([BCBaseObject lengthToInt:passWord]>=6)) {
        [self showTipsView:@"密码至少六位!"];
        return;
    }
    
    self.bSelfRequest = YES;
    //没有普通注册
//    [[NetInterfaceManager sharedInstance] regist:phoneNumber pwd:passWord type:2 sphone:@""];
    [self startWait];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.commonPhoneNumberTextField) {
        if (range.length == 1) {
            return YES;
        }
        
        if (range.location >= 11) {
            [self showTipsView:@"手机号码为11位!"];
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
    else if (textField == self.commonPassWordTextField) {
        if (range.length == 1) {
            return YES;
        }
        
        if (range.location >= 16) {
            [self showTipsView:@"密码最大为16位!"];
            return NO;
        }
    }
    else if (textField == self.commonEnterPassWordTextField) {
        if (range.length == 1) {
            return YES;
        }
        
        if (range.location >= 16) {
            [self showTipsView:@"密码最大为16位!"];
            return NO;
        }
    }

    return YES;
}

#pragma mark - 快速注册按钮
- (IBAction)quickRegisterButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
    //[self goSelectStore];
}
#pragma mark - 去登录按钮
- (IBAction)goLoginButton:(id)sender {
    //[self performSegueWithIdentifier:@"commonRegisterToLogin" sender:self];
    MeLoginViewController *login = [[self storyboard] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    login.bReturnToRoot = YES;
    [self.navigationController pushViewController:login animated:YES];
}

#pragma mark - httpRequestFinished
-(void)httpRequestFinished:(NSNotification *)notification
{
    ResultDataModel *result = notification.object;
    if (!result) {
        DBG_MSG(@"http result is nil!");
        return;
    }
    
    switch (result.requestType) {
            case KReqestType_Register:
        {
            if (self.bSelfRequest) {  //判断是不是自己发的请求
                self.bSelfRequest = NO;
                if (result.resultCode == 0) {
                    
                    [self goSelectStore:self.commonPhoneNumberTextField.text];
                    
                    [self stopWait];
                    [self showTipsView:@"恭喜注册成功!"];
                    User *user = result.data;
                    user.pwd = self.commonPassWordTextField.text;
                    [[EnvPreferences sharedInstance] setUserInfo:user];
                    //[self.navigationController popToRootViewControllerAnimated:YES];
                }
                else if (result.resultCode == 1) {
                    [self showTipsView:@"该手机号码已经注册!"];
                }
                else{
                    [self showTipsView:@"注册失败!"];
                    DBG_MSG(@"result.code=%d, result.desc=%@", result.resultCode, result.desc);
                }
            }
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

-(void)goSelectStore:(NSString*)phoneNumber
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifiyGotoMySelectStore" object:phoneNumber];
    //[self.navigationController popToRootViewControllerAnimated:NO];
}

@end
