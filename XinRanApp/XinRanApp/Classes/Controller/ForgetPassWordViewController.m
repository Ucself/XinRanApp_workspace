//
//  ForgetPassWordViewController.m
//  XinRanApp
//
//  Created by mac on 14/12/17.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "ForgetPassWordViewController.h"
//#import "DynaButton.h"
#import <XRUIView/DynaButton.h>
#import <XRCommon/BCBaseObject.h>
#import "ResetPassWordViewController.h"

@interface ForgetPassWordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTextField;
@property (weak, nonatomic) IBOutlet DynaButton *btnGetCode;

- (IBAction)nextButton:(id)sender;
@end

@implementation ForgetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

-(void)dealloc
{
    [self.btnGetCode stopTimer];
}

#pragma mark - setupUI
- (void)setupUI
{
    //self.phoneNumberTextField.text = @"13120216317";
    [self.btnGetCode setDelegate:self];
    [self.btnGetCode setTitle:@"获取验证码" textColor:UIColor_DefOrange normalImage:[UIImage imageNamed:@"btn_mycoupon_n"] highImage:[UIImage imageNamed:@"btn_mycoupon_h"]];
    
}
#pragma mark - prepareForSegue
//传递参数
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    BaseUIViewController* controller = segue.destinationViewController;
    if ([controller isKindOfClass:[ResetPassWordViewController class]]) {
        ResetPassWordViewController *c = (ResetPassWordViewController *)controller;
        c.phoneNumber = self.phoneNumberTextField.text;
        c.authCode = self.authCodeTextField.text;
        }
}
//点击键盘return回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    DBG_MSG(@"shouldReturn");
    //回收键盘
    [textField resignFirstResponder];
    return YES;
}
//点击背景回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[[event allTouches] anyObject];
    if (touch.tapCount >=1) {
        [self.phoneNumberTextField resignFirstResponder];
        [self.authCodeTextField resignFirstResponder];
    }
}
//点击下一步按钮回收键盘
- (IBAction)dismissKeyboard:(id)sender {
    [self.phoneNumberTextField resignFirstResponder];
    [self.authCodeTextField resignFirstResponder];
}
#pragma mark - 下一步按钮
- (IBAction)nextButton:(id)sender {
    NSString *phoneNumber = self.phoneNumberTextField.text;
    NSString *authNumber = self.authCodeTextField.text;
    if (![BCBaseObject isMobileNumber:phoneNumber]) {
        [self showTipsView:@"请输入正确的手机号码!"];
        return;
    }
    if (authNumber.length == 0) {
        [self showTipsView:@"请填写正确的验证码!"];
        return;
    }
    [self startWait];
    [[NetInterfaceManager sharedInstance] checkCode:phoneNumber code:authNumber];
    //[self performSegueWithIdentifier:@"toReset" sender:self];

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
        
        
    }
    else if (textField == self.authCodeTextField) {
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

#pragma mark - 发送验证码按钮

-(void)dynaButtonClick:(UIView*)sender
{
    [self.phoneNumberTextField resignFirstResponder];
    [self.authCodeTextField resignFirstResponder];
    NSString *phoneNumber = self.phoneNumberTextField.text;
    if ([BCBaseObject isMobileNumber:phoneNumber]) {
        [self startWait];
        [[NetInterfaceManager sharedInstance] sendrcode:phoneNumber];
    }
    else{
        [self showTipsView:@"请输入正确的手机号码!"];
    }
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
        case KReqestType_Sendrcode:
            if (result.resultCode == 0) {
                [self.btnGetCode beginTimer:@"KReqestType_Sendrcode_Forget"];
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
            else{
                [self showTipsView:@"验证码发送失败!"];
                DBG_MSG(@"result.code=%d, result.desc=%@", result.resultCode, result.desc);
            }
            break;
            
        case KReqestType_CheckCode:
            if (result.resultCode == 0) {
                [self showTipsView:@"下一步验证成功!"];
                [self performSegueWithIdentifier:@"toReset" sender:self];
            }else{
                [self showTipsView:@"请填写正确的验证码!"];
                DBG_MSG(@"result.code=%d, result.desc=%@", result.resultCode, result.desc);

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
@end