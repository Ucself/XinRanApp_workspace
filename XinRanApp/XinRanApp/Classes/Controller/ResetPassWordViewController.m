//
//  ResetPassWordViewController.m
//  XinRanApp
//
//  Created by mac on 14/12/17.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "ResetPassWordViewController.h"
#import "MeLoginViewController.h"


@interface ResetPassWordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *enterPassWordTextField;

- (IBAction)sureButton:(id)sender;

@end

@implementation ResetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setupUI];
}
#pragma mark - setupUI
//- (void)setupUI
//{
//    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    passwordLabel.text = @"  新   密   码   :";
//    passwordLabel.font = [UIFont systemFontOfSize:14];
//    passwordLabel.textColor = [UIColor grayColor];
//    passwordLabel.textAlignment = NSTextAlignmentCenter;
//    UILabel *enterPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    enterPasswordLabel.text = @"  确认新密码   :";
//    enterPasswordLabel.font = [UIFont systemFontOfSize:14];
//    enterPasswordLabel.textColor = [UIColor grayColor];
//    enterPasswordLabel.textAlignment = NSTextAlignmentCenter;
//    
//    self.passWordTextField.leftViewMode = UITextFieldViewModeAlways;
//    self.enterPassWordTextField.leftViewMode = UITextFieldViewModeAlways;
//    self.passWordTextField.leftView = passwordLabel;
//    self.enterPassWordTextField.leftView = enterPasswordLabel;
//
//}
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
//点击确认按钮回收键盘
- (IBAction)dismissKeyboard:(id)sender {
    [self.passWordTextField resignFirstResponder];
    [self.enterPassWordTextField resignFirstResponder];
}
#pragma mark - 确认按钮
- (IBAction)sureButton:(id)sender {
    NSString *passWord = self.passWordTextField.text;
    NSString *enterPassWord = self.enterPassWordTextField.text;
    
    if(![BCBaseObject checkInputPassword:passWord]) {
        [self showTipsView:@"请输入6-16位字母和数字,符号两种以上组合!"];
        return;
    }
    if (![passWord isEqualToString:enterPassWord]) {
        [self showTipsView:@"两次密码输入不一致!"];
        return;
    }
    [self startWait];
    [[NetInterfaceManager sharedInstance] changePwdBCode:self.phoneNumber code:self.authCode newPwd:self.passWordTextField.text];

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.passWordTextField) {
        if (range.length == 1) {
            return YES;
        }
        
        if (range.location >= 16) {
            //[self showTipsView:@"手机号码为11位!"];
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
    
//    DBG_MSG(@"==KReqestType_Changepwdbcode=%d",result.resultCode);
//    DBG_MSG(@"==KReqestType_Changepwdbcode=%d",result.requestType);
    switch (result.requestType) {
        case KReqestType_Changepwdbcode:
            if (result.resultCode == 0) {
                [self showTipsView:@"修改密码成功!"];
                
//                MeLoginViewController *login = [[self storyboard] instantiateViewControllerWithIdentifier:@"LoginViewController"];
//                login.bReturnToRoot = YES;
//                [self.navigationController pushViewController:login animated:YES];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
                [self showTipsView:@"重置密码失败!"];
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
