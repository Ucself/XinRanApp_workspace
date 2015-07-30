//
//  ChangePassWordViewController.m
//  XinRanApp
//
//  Created by mac on 14/12/23.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "ChangePassWordViewController.h"
#import "MeLoginViewController.h"

#import "User.h"


@interface ChangePassWordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *oldPassWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *enterPassWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
- (IBAction)enterButton:(id)sender;

@end

@implementation ChangePassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}
- (void)setupUI
{
    
    
//    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    phoneLabel.text = @" 手机号码   :";
//    phoneLabel.font = [UIFont systemFontOfSize:14];
//    phoneLabel.textColor = [UIColor grayColor];
//    phoneLabel.textAlignment = NSTextAlignmentCenter;
//    UILabel *oldPassWordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    oldPassWordLabel.text = @"  原   密   码   :";
//    oldPassWordLabel.font = [UIFont systemFontOfSize:14];
//    oldPassWordLabel.textColor = [UIColor grayColor];
//    oldPassWordLabel.textAlignment = NSTextAlignmentCenter;
//    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    passwordLabel.text = @"  新   密    码   :";
//    passwordLabel.font = [UIFont systemFontOfSize:14];
//    passwordLabel.textColor = [UIColor grayColor];
//    passwordLabel.textAlignment = NSTextAlignmentCenter;
//    UILabel *enterPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    enterPasswordLabel.text = @"  确认新密码   :";
//    enterPasswordLabel.font = [UIFont systemFontOfSize:14];
//    enterPasswordLabel.textColor = [UIColor grayColor];
//    enterPasswordLabel.textAlignment = NSTextAlignmentCenter;
//    
//    self.phoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
//    self.oldPassWordTextField.leftViewMode = UITextFieldViewModeAlways;
//    self.passWordTextField.leftViewMode = UITextFieldViewModeAlways;
//    self.enterPassWordTextField.leftViewMode = UITextFieldViewModeAlways;
//    
//    self.phoneNumberTextField.leftView = phoneLabel;
//    self.oldPassWordTextField.leftView = oldPassWordLabel;
//    self.passWordTextField.leftView = passwordLabel;
//    self.enterPassWordTextField.leftView = enterPasswordLabel;
    self.enterButton.layer.cornerRadius = 5;
    self.phoneNumberTextField.text = [[EnvPreferences sharedInstance] getUserInfo].phone;
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
        [self.passWordTextField resignFirstResponder];
        [self.enterPassWordTextField
         resignFirstResponder];
    }
}
//确认按钮回收键盘
- (IBAction)dismissKeyboard:(id)sender {
    [self.phoneNumberTextField resignFirstResponder];
    [self.oldPassWordTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
    [self.enterPassWordTextField resignFirstResponder];
}
#pragma mark - 确认按钮
- (IBAction)enterButton:(id)sender {
    NSString *oldPassWord = self.oldPassWordTextField.text;
    NSString *newPassWord = self.passWordTextField.text;
    NSString *confirmPassWord = self.enterPassWordTextField.text;
    DBG_MSG(@"==%@",[[EnvPreferences sharedInstance] getUserInfo].pwd);
    
    if (oldPassWord.length <= 0) {
        [self showTipsView:@"请输入当前密码!"];
        return;
    }
    
    if (![oldPassWord isEqualToString:[[EnvPreferences sharedInstance] getUserInfo].pwd]) {
        
        [self showTipsView:@"当前密码错误!"];
        return;
    }
    
    if (!newPassWord || [newPassWord length]<=0 || !confirmPassWord || [confirmPassWord length]<=0){
        [self showTipsView:@"请输入新密码!"];
        return;
    }
    if(![BCBaseObject checkInputPassword:newPassWord]) {
        [self showTipsView:@"请输入6-16位字母和数字,符号两种以上组合!"];
        return;
    }
    
    if (![confirmPassWord isEqualToString:newPassWord]) {
        [self showTipsView:@"两次密码输入不一致!"];
        return;
    }
    
    
    [self startWait];
    [[NetInterfaceManager sharedInstance] changePwd:oldPassWord new:newPassWord];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.oldPassWordTextField) {
        if (range.length == 1) {
            return YES;
        }
        
        if (range.location >= 16) {
            //[self showTipsView:@"密码最大为16位!"];
            return NO;
        }
        
    }
    else if (textField == self.passWordTextField) {
        if (range.length == 1) {
            return YES;
        }
        
        if (range.location >= 16) {
            //[self showTipsView:@"密码最大为16位!"];
            return NO;
        }
    }
    else if (textField == self.enterPassWordTextField) {
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
        case KReqestType_ChangePwd:
            if (result.resultCode == 0) {
                
                [self showTipsView:@"密码修改成功!"];

                [[EnvPreferences sharedInstance] setToken:nil];
                [self.navigationController popViewControllerAnimated:NO];
                [self.delegate controllerBackWithData:@"gologin"];

            }
            else{
                [self showTipsView:@"修改密码失败!"];
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
