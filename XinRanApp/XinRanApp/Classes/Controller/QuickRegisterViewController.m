//
//  MeRegisterViewController.m
//  XinRanApp
//
//  Created by mac on 14/12/17.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "QuickRegisterViewController.h"
#import "MeLoginViewController.h"
//#import "DynaButton.h"
#import <XRUIView/DynaButton.h>
#import <XRCommon/BCBaseObject.h>
#import <XRCommon/PhoneQuery.h>

#import "User.h"
#import "Areas.h"


@interface QuickRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *quickPhoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *quickPassWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *nowRegisterButton;
@property (weak, nonatomic) IBOutlet DynaButton *btnGetCode;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassWordTextField;


@property (nonatomic, assign) BOOL selected;         //用户协议选中标记
@property (nonatomic, assign) BOOL bSelfRequest;     //注册请求标记

- (IBAction)agreementButton:(id)sender;
- (IBAction)qoLoginButton:(id)sender;
- (IBAction)commonRegisterButton:(id)sender;
@end

@implementation QuickRegisterViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selected = YES;
    [self setupUI];
}
-(void)dealloc
{

    [self.btnGetCode stopTimer];
    [self removeObserver:self forKeyPath:@"selected"];
}

#pragma mark - setupUI
- (void)setupUI
{
//    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
//    phoneLabel.text = @"手机号码   :";
//    phoneLabel.font = [UIFont systemFontOfSize:14];
    //phoneLabel.textColor = [UIColor grayColor];
//    phoneLabel.textAlignment = NSTextAlignmentCenter;
//    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
//    passwordLabel.text = @"密       码   :";
//    passwordLabel.font = [UIFont systemFontOfSize:14];
    //passwordLabel.textColor = [UIColor grayColor];

//    passwordLabel.textAlignment = NSTextAlignmentCenter;

//    self.quickPhoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
//    self.quickPassWordTextField.leftViewMode = UITextFieldViewModeAlways;
//    self.quickPhoneNumberTextField.leftView = phoneLabel;
//    self.quickPassWordTextField.leftView = passwordLabel;

    [self.btnGetCode setDelegate:self];
    [self.btnGetCode setTitle:@"获取验证码" textColor:UIColor_DefOrange normalImage:[UIImage imageNamed:@"btn_mycoupon_n"] highImage:[UIImage imageNamed:@"btn_mycoupon_h"]];
   

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
        [self.quickPhoneNumberTextField resignFirstResponder];
        [self.quickPassWordTextField resignFirstResponder];
        [self.passWordTextField resignFirstResponder];
        [self.confirmPassWordTextField resignFirstResponder];
    }
}
//点击立即注册回收键盘
- (IBAction)dismissKeyboard:(id)sender {
    [self.quickPhoneNumberTextField resignFirstResponder];
    [self.quickPassWordTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
    [self.confirmPassWordTextField resignFirstResponder];
}
#pragma mark - 立即注册按钮
- (IBAction)quickRegisterPassWordButton:(id)sender {
    DBG_MSG(@"电话号码：%@",self.quickPhoneNumberTextField.text);
    DBG_MSG(@"密码：%@",self.passWordTextField.text);
    
    if (![BCBaseObject isMobileNumber:self.quickPhoneNumberTextField.text]) {
        [self showTipsView:@"请输入正确的手机号码!"];
        return;
    }
    //验证码
    if(self.quickPassWordTextField.text.length <= 0){
        [self showTipsView:@"请填写正确的验证码!"];
        return;
    }
    
    if(self.passWordTextField.text.length == 0) {
        [self showTipsView:@"密码不能为空!"];
        return;
    }
    
    if(![BCBaseObject checkInputPassword:self.passWordTextField.text]) {
        [self showTipsView:@"请输入6-16位字母和数字,符号两种以上组合!"];
        return;
    }
    
    //输入的密码是否一致
    if(![self.passWordTextField.text isEqualToString:self.confirmPassWordTextField.text]){
        [self showTipsView:@"两次密码输入不一致!"];
        return;
    }
    
    
    self.bSelfRequest = YES;
    [[NetInterfaceManager sharedInstance] regist:self.quickPhoneNumberTextField.text pwd:self.passWordTextField.text type:1 sphone:@"" code:self.quickPassWordTextField.text];//注：type应该为1
    [self startWait];
}
#pragma mark - 获取密码按钮
//- (IBAction)quickSendPassWordButton:(id)sender {
//    [self.quickPhoneNumberTextField resignFirstResponder];
//    [self.quickPassWordTextField resignFirstResponder];
//    NSString *phoneNumber = self.quickPhoneNumberTextField.text;
//    if ([BCBaseObject isMobileNumber:phoneNumber]) {
//        [self.quickPhoneNumberTextField resignFirstResponder];
//        [self.quickPassWordTextField resignFirstResponder];
//        
//        [[NetInterfaceManager sharedInstance] sendRgeSMS:phoneNumber];
//        [self startWait];
//    }
//    else{
//        [self showTipsView:@"不是有效的手机号码!"];
//    }
//}

-(void)dynaButtonClick:(UIView*)sender
{
    [self.quickPhoneNumberTextField resignFirstResponder];
    [self.quickPassWordTextField resignFirstResponder];
    NSString *phoneNumber = self.quickPhoneNumberTextField.text;
    if ([BCBaseObject isMobileNumber:phoneNumber]) {
        [self.quickPhoneNumberTextField resignFirstResponder];
        [self.quickPassWordTextField resignFirstResponder];
        
        [[NetInterfaceManager sharedInstance] sendRgeSMS:phoneNumber];
        [self startWait];
    }
    else{
        [self showTipsView:@"请输入正确的手机号码!"];
    }
    
    

}

#pragma mark - 服务协议按钮
- (IBAction)agreementButton:(id)sender {

    DBG_MSG(@"agreementButton");
    [self performSegueWithIdentifier:@"toAgreement" sender:nil];
}
#pragma mark - 去登录
- (IBAction)qoLoginButton:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    MeLoginViewController *login = [[self storyboard] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    login.bReturnToRoot = YES;
    [self.navigationController pushViewController:login animated:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.quickPhoneNumberTextField) {
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
    else if (textField == self.quickPassWordTextField) {
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

//倒计时方法
//-(void)countDownTime{
//    NSString *titleStr = self.quicksendPassWordButton.titleLabel.text;
//    NSInteger titleValue = titleStr.integerValue;
//    DBG_MSG(@"==titleValue=%ld",(long)titleValue);
//    if (titleValue <= 1) {
//        [self.quicksendPassWordButton setTitle:@"获取密码" forState:UIControlStateNormal];
//       self.quicksendPassWordButton.titleLabel.font = [UIFont fontWithName:@"Geeza Pro" size:13];
//
//        [self.countDown invalidate];
//        [self.quicksendPassWordButton setEnabled:YES];
//    }else{
//        titleValue --;
//        [self.quicksendPassWordButton setTitle:[NSString stringWithFormat:@"%ld秒后获取",(long)titleValue] forState:UIControlStateNormal];
//    }
//}
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
        case KReqestType_Sendregsms:
            
            if (result.resultCode == 0) {
                [self.btnGetCode beginTimer:@"KReqestType_Sendregsms_Register"];
                [self showTipsView:@"短信正在发送..."];
            }
            else if (result.resultCode == 1){
                [self showTipsView:@"发送超过限制!"];
            }
            else if (result.resultCode == 2){
                [self showTipsView:@"验证码已发送!"];
            }
            else if (result.resultCode == 3){
                [self showTipsView:@"验证码发送失败!"];
            }
            else if (result.resultCode == 4) {
                [self showTipsView:@"该手机号码已注册, 请更换手机号码!"];
            }
            else {
                [self showTipsView:@"验证码发送失败!"];
                DBG_MSG(@"result.code=%d, result.desc=%@", result.resultCode, result.desc);
            }
    
            break;
        case KReqestType_Register:
        {
            if (self.bSelfRequest) {    //判断是不是自己发的请求
                self.bSelfRequest = NO;
                
                if (result.resultCode == 0) {
                    [self goSelectStore:self.quickPhoneNumberTextField.text];
                    
                    [self showTipsView:@"恭喜注册成功!"];
                    User *user = result.data;
                    user.pwd = self.quickPassWordTextField.text;
                    [[EnvPreferences sharedInstance] setUserInfo:user];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else if (result.resultCode == 1) {
                    [self showTipsView:@"该手机号码已注册!"];
                }
                else if (result.resultCode == 2){
                    [self showTipsView:@"请填写正确的验证码!"];
                    DBG_MSG(@"result.code=%d, result.desc=%@", result.resultCode, result.desc);
                }
                else{
                    [self showTipsView:@"亲，获取失败，请重试!"];
                    DBG_MSG(@"result.code=%d, result.desc=%@", result.resultCode, result.desc);
                }
            }
        }
            
            break;
        default:
            break;
    }
}
#pragma mark - httpRequestFailed
-(void)httpRequestFailed:(NSNotification *)notification
{
    [super httpRequestFailed:notification];
}

#pragma mark - 普通注册按钮
- (IBAction)commonRegisterButton:(id)sender {
    [self performSegueWithIdentifier:@"toCommonRegister" sender:self];
}

-(void)goSelectStore:(NSString*)phoneNumber
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifiyGotoMySelectStore" object:phoneNumber];
    //[self.navigationController popToRootViewControllerAnimated:NO];
}
@end

