//
//  ShipAddressViewController.m
//  XinRanApp
//
//  Created by libj on 15/4/24.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "ShipAddressViewController.h"
#import <XRUIView/AreaPickerView.h>
#import "User.h"
#import "UserShipAddress.h"
#import "Areas.h"
#import <XRCommon/BCBaseObject.h>


@interface ShipAddressViewController ()<UITextFieldDelegate,UITextViewDelegate>{
    //地域选择
    AreaPickerView *pickerView;
}

@property (strong, nonatomic) NSMutableArray *arProvince;
@property (strong, nonatomic) NSMutableArray *arCity;
@property (strong, nonatomic) NSMutableArray *arDistrict;
//当前选中区域
@property (strong, nonatomic) Areas *selDistrict;
@property (strong, nonatomic) Areas *selCity;
@property (strong, nonatomic) Areas *selProvince;

@end

@implementation ShipAddressViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //对键盘操作的协议
    self.nameTextField.delegate = self;
    self.adressTextField.delegate = self;
    self.detailAdressTextView.delegate = self;
    self.tellphoneTextField.delegate = self;
    //获取本地的数据地址
    [self loadLocalDataUserInfor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneEdite:(id)sender {
    //隐藏键盘
    [self.nameTextField resignFirstResponder];
    [self.adressTextField resignFirstResponder];
    [self.detailAdressTextView resignFirstResponder];
    [self.tellphoneTextField resignFirstResponder];
    //取消区域选择框
    [pickerView cancelPicker:self.view];
    
    //收货人验证
    if ([_nameTextField.text isEqualToString:@""]) {
        [self showTipsView:@"请输入收货人姓名!"];
        return;
    }
    if (_nameTextField.text.length < 2 || _nameTextField.text.length > 10 || ![BCBaseObject isChineseStr:_nameTextField.text]) {
        [self showTipsView:@"收货人姓名为2-10个汉字!"];
        return;
    }
    //省市区验证
    if ([_adressTextField.text isEqualToString:@""]) {
        [self showTipsView:@"请选择省市区!"];
        return;
    }
    //详细地址验证
    if ([_detailAdressTextView.text isEqualToString:@""]) {
        [self showTipsView:@"详细地址不能为空!"];
        return;
    }
    if (_detailAdressTextView.text.length < 5 || _detailAdressTextView.text.length > 60) {
        [self showTipsView:@"详细地址为5-60个字符!"];
        return;
    }
    if (![BCBaseObject isHasChineseCharacter:_detailAdressTextView.text]) {
        [self showTipsView:@"详细地址不能为纯数字或字母!"];
        return;
    }
    
    //手机号码验证
    if (![BCBaseObject isMobileNumber:self.tellphoneTextField.text]) {
        [self showTipsView:@"请输入正确的手机号码!"];
        return;
    }
    UserShipAddress *userShipAddress = [EnvPreferences sharedInstance].userShipAddress;
    NSString *nowAreaId ;
    //设置区域id
    if(self.selDistrict){
        nowAreaId = self.selDistrict.Id;
    }
    else if (self.selCity){
        nowAreaId = self.selCity.Id;
    }
    else if (self.selProvince){
        nowAreaId = self.selProvince.Id;
    }
    //取出数据修改并且发送数据到服务器
    [[NetInterfaceManager sharedInstance] updateConsignee: userShipAddress.shipAddressId ? userShipAddress.shipAddressId : @""
                                                     name:self.nameTextField.text
                                                   areaId:nowAreaId
                                                     addr:self.detailAdressTextView.text
                                                    phone:self.tellphoneTextField.text];
    [self startWait];
    
}
- (IBAction)selectAdress:(id)sender {
    //隐藏键盘
    [self.nameTextField resignFirstResponder];
    [self.adressTextField resignFirstResponder];
    [self.detailAdressTextView resignFirstResponder];
    [self.tellphoneTextField resignFirstResponder];
    //展示选择
    [self showPickerView];
}

-(NSMutableArray*)getProvinceArray
{
    static NSMutableArray *array = nil;
    static dispatch_once_t once;
    _dispatch_once(&once, ^{
        array = [NSMutableArray arrayWithArray:[Areas provinceList]];
    });
    
    return array;
}

-(NSMutableArray*)getCityArray
{
    static NSMutableArray *array = nil;
    static dispatch_once_t once;
    _dispatch_once(&once, ^{
        array = [NSMutableArray new];
        for (Areas *province in self.arProvince) {
            if (province) {
                [array addObjectsFromArray:[Areas cityList:province.Id]];
            }
        }
    });
    
    return array;
}

-(NSMutableArray*)getDistrictArray
{
    static NSMutableArray *array = nil;
    static dispatch_once_t once;
    _dispatch_once(&once, ^{
        array = [NSMutableArray new];
        for (Areas *city in self.arCity) {
            if (city) {
                [array addObjectsFromArray:[Areas districtList:city.Id]];
            }
        }
    });
    
    return array;
}


//获取本地的用户地址数据
-(void)loadLocalDataUserInfor{
    [self startWait];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DBG_MSG(@"begin");
        //省级数组
        self.arProvince = [self getProvinceArray];//[NSMutableArray arrayWithArray:[Areas provinceList]];
        if (!self.arProvince || self.arProvince.count == 0) {
            //没有省级就认为失败
            DBG_MSG(@"load local areas data failed!");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopWait];
            });
            return;
        }
        
        //城市数组
        self.arCity = [self getCityArray];
        
        //区域数组
        self.arDistrict = [self getDistrictArray];
        
        ///////////////////////////////////////////////
        UserShipAddress *userShipAddress = [EnvPreferences sharedInstance].userShipAddress;
        //如果未有缓存数据，直接返回
        if (!userShipAddress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopWait];
            });
            
            DBG_MSG(@"用户收货地址没取到!");
            return;
        }
        //取县区
        Areas *arDistrict = [Areas getArearWithId:userShipAddress.areaId];
        if (arDistrict) {
            //定位使用当前的区域
            self.selDistrict = arDistrict;
            //取市
            Areas *arCity = [Areas getArearWithId:arDistrict.pId];
            if (arCity) {
                self.selCity = arCity;
                //取省
                Areas *arProvince = [Areas getArearWithId:arCity.pId];
                if (arProvince) {
                    //三个值都有
                    self.selProvince = arProvince;
                }
                else{
                    //只有两级的值，说只有省份和市区
                    self.selProvince = arCity;
                    self.selCity = arDistrict;
                    self.selDistrict = nil;
                }
            }
            else {
                //只有一个值说明只是第一级的值
                self.selProvince = arDistrict;
                self.selCity = nil;
                self.selDistrict = nil;
            }
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopWait];
            
            NSString *nsAddress = [[NSString alloc] initWithFormat:@"%@ %@ %@" ,self.selProvince ? self.selProvince.name : @"" , self.selCity ? self.selCity.name : @"", self.selDistrict ? self.selDistrict.name : @""];
            
            //有数据展示到界面
            self.nameTextField.text = userShipAddress.name;
            self.adressTextField.text = nsAddress;
            self.detailAdressTextView.text = userShipAddress.detailAddress;
            if ([userShipAddress.detailAddress isEqualToString:@""]) {
                self.textViewTips.hidden = NO;
            }
            else{
                self.textViewTips.hidden = YES;
            }
            self.tellphoneTextField.text = userShipAddress.phone;
            
            DBG_MSG(@"end");
        });
        
    });
    
    
}
#pragma mark - 点击return回收键盘  UITextFieldDelegate
//点击编辑的时候关闭地域选择控件
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [pickerView cancelPicker:self.view];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.nameTextField && range.location >= 10) {
        
        return NO;
    }
    else if (textField == self.tellphoneTextField && range.location >= 11 ){
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //回收选择控件
    [pickerView cancelPicker:self.view];
    //回收键盘
    [textField resignFirstResponder];
    return YES;
}
//#pragma mark - 点击背景回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[[event allTouches] anyObject];
    if (touch.tapCount >=1) {
        [self.nameTextField resignFirstResponder];
        [self.adressTextField resignFirstResponder];
        [self.detailAdressTextView resignFirstResponder];
        [self.tellphoneTextField resignFirstResponder];
        //取消区域选择框
        [pickerView cancelPicker:self.view];
        
    }
}
#pragma mark ----
//展示省份市信息
-(void)showPickerView
{
    if (!pickerView) {
        //pickerView = [[AreaPickerView alloc] initWithDelegate:self areas:self.arProvince];
        pickerView = [[AreaPickerView alloc] initWithDelegate:self arProvince:self.arProvince arCity:self.arCity arDistrict:self.arDistrict];
    }
    
    [pickerView setAreas:(Area*)(self.selProvince) city:(Area*)(self.selCity) district:(Area*)(self.selDistrict)];
    [pickerView showInView:self.view];
}
#pragma mark- AreaPickerView delegate
- (void)pickerViewDidChange:(AreaPickerView *)picker
{
    
}
- (void)pickerViewCancel
{
    [pickerView cancelPicker:self.view];
}
- (void)pickerViewOK:(Area*)province city:(Area*)city district:(Area*)district
{
    self.selDistrict = (Areas*)district;
    self.selCity= (Areas*)city;
    self.selProvince = (Areas*)province;
    [pickerView cancelPicker:self.view];
    
    NSMutableString *string = [NSMutableString stringWithCapacity:0];
    if (self.selProvince) {
        [string appendFormat:@"%@", self.selProvince.name];
    }
    if (self.selCity) {
        [string appendFormat:@" %@", self.selCity.name];
    }
    if (self.selDistrict) {
        [string appendFormat:@" %@", self.selDistrict.name];
    }
    
    self.adressTextField.text = string;
}

#pragma mark textview delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.textViewTips.hidden = YES;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location > 100)
        return NO;
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.textViewTips.hidden = NO;
    }
    return YES;
}

#pragma mark ---
//数据请求成功
-(void)httpRequestFinished:(NSNotification *)notification{
    
    [self stopWait];
    ResultDataModel *result =notification.object;
    if (!result) {
        DBG_MSG(@"http result is nil");
        return;
    }
    switch (result.requestType) {
        case KReqestType_Updateconsignee:
            if (result.resultCode == 0) {
                [self.navigationController popViewControllerAnimated:YES];
                //取出id
                UserShipAddress *userShipAddress = [EnvPreferences sharedInstance].userShipAddress;
                //如果不存在这个对象
                if(!userShipAddress){
                    userShipAddress = [[UserShipAddress alloc] init];
                }
                
                userShipAddress.shipAddressId = result.data;
                userShipAddress.name = self.nameTextField.text;
                //设置区域id
                if(self.selDistrict){
                    userShipAddress.areaId = self.selDistrict.Id;
                }
                else if (self.selCity){
                    userShipAddress.areaId = self.selCity.Id;
                }
                else if (self.selProvince){
                    userShipAddress.areaId = self.selProvince.Id;
                }
                userShipAddress.detailAddress = self.detailAdressTextView.text;
                userShipAddress.phone = self.tellphoneTextField.text;
                //重新存入内存中
                [EnvPreferences sharedInstance].userShipAddress = userShipAddress;
                
            }
            break;
        default:
            break;
    }
    
    User *tempUser = [[EnvPreferences sharedInstance] getUserInfo];
    
//    tempUser.shipAddress.shipAddressId =@"";
//    tempUser.shipAddress=[UserShipAddress new];
    
    [[EnvPreferences sharedInstance] setUserInfo:tempUser];
}
//数据请求失败
-(void)httpRequestFailed:(NSNotification *)notification{
    [self stopWait];
    [super httpRequestFinished:notification];
}




@end
