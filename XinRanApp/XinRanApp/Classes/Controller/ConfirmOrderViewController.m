//
//  ConfirmOrderViewController.m
//  XinRanApp
//
//  Created by tianbo on 14-12-25.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "MyOrderViewController.h"
#import "HomeViewController.h"
#import "ShipAddressViewController.h"

#import <XRNetInterface/UIImageView+AFNetworking.h>

#import "User.h"
#import "UserWhouse.h"
#import "UserShipAddress.h"
#import "Areas.h"

#import <XRShareSDK/XDShareManager.h>


@interface ConfirmOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *btnAliBk;
    UIButton *btnAli;
    UIButton *btnWechatBk;
    UIButton *btnWechat;
    XSharePayType payType;
    
    //提交后台反回的剩余
    NSInteger remaindNum;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
@property (weak, nonatomic) IBOutlet UILabel *lableNumber;
@property (weak, nonatomic) UITextField *txtNum;

@end

@implementation ConfirmOrderViewController

-(void)autoWidthLabel:(UILabel*)label
{
    NSString *sring = label.text;

    CGSize size = [sring sizeWithAttributes:@{NSFontAttributeName:label.font}];
    [label remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(size.width+20).priorityHigh();
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.lableNumber.text = @"1件";
    self.labelPrice.text = [NSString stringWithFormat:@"¥%0.2f", self.product.price * self.buyNum];
    [self autoWidthLabel:self.labelPrice];
   
    [self.tableView setContentInset:UIEdgeInsetsMake(-1, 0, 0, 0)];
    
    payType = PayType_Ali;
    remaindNum = -1;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbkwhite"] forBarMetrics:UIBarMetricsDefault];

    if (![EnvPreferences sharedInstance].userShipAddress) {
        [self addrTipsView];
    }
    //重新刷新一下地址
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
-(UIView*)addrTipsView
{
    UIView *view = [UIView new];
    view.tag = 1110;
    [[[UIApplication sharedApplication] keyWindow] addSubview:view];
    
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([[UIApplication sharedApplication] keyWindow]);
    }];
    
    UIImageView *ivBK = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"confirmordertips"]];
    [view addSubview:ivBK];
    [ivBK makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    UILabel *label1 = [UILabel new];
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont boldSystemFontOfSize:17];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"您的收货地址为空";
    [view addSubview:label1];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.top.equalTo(view).offset(320);
        make.height.equalTo(25);
    }];
    
    UILabel *label2 = [UILabel new];
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont boldSystemFontOfSize:17];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"请先编辑您的收货地址!";
    [view addSubview:label2];
    [label2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.top.equalTo(label1.bottom).offset(5);
        make.height.equalTo(25);
    }];
    
    UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEdit.backgroundColor = [UIColor clearColor];
    [btnEdit setTitle:@"去编辑!" forState:UIControlStateNormal];
    [btnEdit setBackgroundImage:[UIImage imageNamed:@"btn_editaddr"] forState:UIControlStateNormal];
    [btnEdit addTarget:self action:@selector(btnEditAddrClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnEdit];
    [btnEdit makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(label2.bottom).offset(23);
        make.height.equalTo(36);
        make.width.equalTo(110);
    }];
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.backgroundColor = [UIColor clearColor];
    [btnClose setTitle:@"" forState:UIControlStateNormal];
    [btnClose setBackgroundImage:[UIImage imageNamed:@"btn_editclose"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(btnEditCloseClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnClose];
    [btnClose makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(10);
        make.right.equalTo(view).offset(-5);
        make.height.equalTo(37);
        make.width.equalTo(37);
    }];
    
    return view;
}

-(void)btnEditAddrClick:(id)sender
{
    UIView *view = [[[UIApplication sharedApplication] keyWindow] viewWithTag:1110];
    if (view) {
        [view removeFromSuperview];
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    ShipAddressViewController *c = [storyboard instantiateViewControllerWithIdentifier:@"ShipAddressViewController"];
    [self.navigationController pushViewController:c animated:YES];
}

-(void)btnEditCloseClick:(id)sender
{
    UIView *view = [[[UIApplication sharedApplication] keyWindow] viewWithTag:1110];
    if (view) {
        [view removeFromSuperview];
    }
}


//保存店铺id
//-(void) saveWhouseWithUserId:(NSString*)userId whouseId:(NSString*)whouseId
//{
//    UserWhouse *userWhouse = [[UserWhouse alloc] initWithDictionary:@{@"userId":userId,
//                                                                      @"whouseId":whouseId}];
//    [UserWhouse addNewModel:userWhouse];
//}

#pragma mark-
- (IBAction)btnConfirmClick:(id)sender {
    
    if (![EnvPreferences sharedInstance].userShipAddress) {
        [self addrTipsView];
        return;
    }
    //WhouseProduct *whouse = [self.product.arrayWhouses objectAtIndex:1];
    
    //    NSString *adwId = @"";
    //    for (WhouseProduct *p in self.product.arrayWhouses) {
    //        if ([p.Id isEqualToString:self.whouse.Id]) {
    //            adwId = p.adwId;
    //        }
    //    }
    
    //if (self.product.Id) {   //常规商品购买
    //    [[NetInterfaceManager sharedInstance] commonBuy:self.product.Id wid:self.whouse.Id num:self.buyNum];
    //}
    //else {    // 活动商品购买
    //    [[NetInterfaceManager sharedInstance] secKillBuy:self.product.did wid:self.whouse.Id];
    //}
    
    //[[NetInterfaceManager sharedInstance] purchase:self.product.Id adwid:self.whouse.Id];
    
    UserShipAddress *addr = [EnvPreferences sharedInstance].userShipAddress;
    [[NetInterfaceManager sharedInstance] commonBuy:self.product.Id
                                                num:self.buyNum
                                        consigneeId:addr.shipAddressId
                                            payType:payType];
    [self startWait];
    
    //[self saveWhouseWithUserId:[[EnvPreferences sharedInstance] getUserInfo].userId whouseId:self.whouse.Id];
    
}


-(void)btnSubClick:(id)sender
{
    if (self.buyNum > 1) {
        self.buyNum --;
    }
    //减到一件的时候变为灰色
    if (self.buyNum <= 1){
        UIButton *btnSub = (UIButton*)[self.view viewWithTag:205];
        [btnSub setBackgroundImage:[UIImage imageNamed:@"btn_sub_d"] forState:UIControlStateNormal];
    }
    //添加按钮换回来
    if (self.buyNum < 100) {
        UIButton *btnAdd = (UIButton*)[self.view viewWithTag:206];
        //设置为
        [btnAdd setBackgroundImage:[UIImage imageNamed:@"btn_add_n"] forState:UIControlStateNormal];
    }
    
    [self.tableView reloadData];
    
    self.labelPrice.text = [NSString stringWithFormat:@"¥%0.2f", self.product.price * self.buyNum];
    [self autoWidthLabel:self.labelPrice];
}

-(void)btnAddClick:(id)sender
{
    //不能超过100个
    if (self.buyNum < self.product.remaind && self.buyNum < 100) {
        self.buyNum ++;
    }
    //显示按钮变色
    if(self.buyNum >= self.product.remaind || self.buyNum >= 100){
        UIButton *btnAdd = (UIButton*)[self.view viewWithTag:206];
        //设置为灰色
        [btnAdd setBackgroundImage:[UIImage imageNamed:@"btn_add_d"] forState:UIControlStateNormal];
        [self showTipsView:@"超过购买限额"];
    }
    //大于一件的时候为明色
    if (self.buyNum > 1){
        UIButton *btnSub = (UIButton*)[self.view viewWithTag:205];
        [btnSub setBackgroundImage:[UIImage imageNamed:@"btn_sub_n"] forState:UIControlStateNormal];
    }
    
    [self.tableView reloadData];
    
    self.labelPrice.text = [NSString stringWithFormat:@"¥%0.2f", self.product.price * self.buyNum];
    [self autoWidthLabel:self.labelPrice];
}

#pragma mark-
-(void)btnWechatBKClick:(id)sender
{
    payType = PayType_WeChat;
    [btnAli setBackgroundImage:[UIImage imageNamed:@"chenk_n"] forState:UIControlStateNormal];
    [btnWechat setBackgroundImage:[UIImage imageNamed:@"chenk_h"] forState:UIControlStateNormal];
}

-(void)btnAliBKClick:(id)sender
{
    payType = PayType_Ali;
    [btnAli setBackgroundImage:[UIImage imageNamed:@"chenk_h"] forState:UIControlStateNormal];
    [btnWechat setBackgroundImage:[UIImage imageNamed:@"chenk_n"] forState:UIControlStateNormal];
}

#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (indexPath.row == 0) {
//        NSString *text = self.whouse.address;
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle.copy};
//        CGRect rect = [text boundingRectWithSize:CGSizeMake(label.frame.size.width, 1000)
//                                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
//                                            attributes:attributes
//                                               context:nil];
   // }
    if (indexPath.section==0) {
        return 95;
    }
    else if (indexPath.section==1) {
        if (remaindNum != -1 && remaindNum < self.buyNum) {
            return 185;
        }
        else {
            return 165;
        }
    }
    else if (indexPath.section==2) {
        return 110;
    }
   
    
    return 0;

}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section==0 && indexPath.row==0) {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCellIdent"];
//        UILabel *nameLabel = (UILabel*)[cell viewWithTag:100];
//        nameLabel.text = self.whouse.name;
//
//        
//        UILabel *label = (UILabel*)[cell viewWithTag:101];
//        label.text = self.whouse.address;
//        
//        User *user = [[EnvPreferences sharedInstance] getUserInfo];
//        //        label = (UILabel*)[cell viewWithTag:102];
//        //        label.text = user.username;
//        UILabel* labelphone = (UILabel*)[cell viewWithTag:102];
//        labelphone.text = user.phone;
//
//        
//        [cell setNeedsUpdateConstraints];
//        [cell updateConstraintsIfNeeded];
//        
//        CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//        
//        return height;
//
//    }
//    return 150;
//}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 4)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCellIdent"];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        UIView *viewNO = [cell viewWithTag:101];
        UIView *viewHas = [cell viewWithTag:102];
        
        UILabel *labelName = (UILabel*)[cell viewWithTag:103];
        UILabel *labelPhone = (UILabel*)[cell viewWithTag:104];
        UILabel *labelAddress = (UILabel*)[cell viewWithTag:105];
        
        //
        viewNO.hidden = YES;
        viewHas.hidden = NO;
        UserShipAddress *addr = [EnvPreferences sharedInstance].userShipAddress;
        if (addr) {
            //数据库取数据
            NSString *stringDistrict=@"";NSString *stringCity=@"";NSString *stringProvince=@"";
            //取县区
            Areas *arDistrict = [Areas getArearWithId:addr.areaId];
            if (arDistrict) {
                //定位使用当前的区域
                stringDistrict = arDistrict.name;
                //取市
                Areas *arCity = [Areas getArearWithId:arDistrict.pId];
                if (arCity) {
                    stringCity = arCity.name;
                    //取省
                    Areas *arProvince = [Areas getArearWithId:arCity.pId];
                    if (arProvince) {
                        stringProvince = arProvince.name;
                    }
                    
                }
            }
            
            labelName.text = addr.name;
            labelAddress.text = [[NSString alloc] initWithFormat:@"%@%@%@%@",stringProvince,stringCity,stringDistrict,addr.detailAddress];
            labelPhone.text = addr.phone;
        }
    }
    else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ProductInfoCellIdent"];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        
        UIImageView *imageView = (UIImageView*)[cell viewWithTag:201];
        UILabel *labelTitle = (UILabel*)[cell viewWithTag:202];
        UILabel *labelPrice = (UILabel*)[cell viewWithTag:203];
        UILabel *labelNum = (UILabel*)[cell viewWithTag:204];
        UIButton *btnSub = (UIButton*)[cell viewWithTag:205];
        UITextField *txtNum = (UITextField*)[cell viewWithTag:207];
        UIButton *btnAdd = (UIButton*)[cell viewWithTag:206];
        UILabel *labelAmount = (UILabel*)[cell viewWithTag:208];
        UILabel *labelRemaindTip = (UILabel*)[cell viewWithTag:210];
        UILabel *labelDesc = (UILabel*)[cell viewWithTag:211];
        
        self.txtNum = txtNum;
        txtNum.text = [NSString stringWithFormat:@"%d", self.buyNum];
        if (self.buyNum <=1) {
            [btnSub setBackgroundImage:[UIImage imageNamed:@"btn_sub_d"] forState:UIControlStateNormal];
        }
        else{
            [btnSub setBackgroundImage:[UIImage imageNamed:@"btn_sub_n"] forState:UIControlStateNormal];
        }
        [btnSub addTarget:self action:@selector(btnSubClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnAdd addTarget:self action:@selector(btnAddClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [imageView setImageWithURL:[NSURL URLWithString:self.product.image]];
        imageView.layer.borderWidth=0.3;
        imageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
        labelTitle.text = self.product.title;
        labelDesc.text = self.product.desc;
        labelPrice.text = [NSString stringWithFormat:@"¥%0.2f", self.product.price];
        labelNum.text = [NSString stringWithFormat:@"× %d", self.buyNum];
        labelAmount.text = [NSString stringWithFormat:@"实付 ¥%0.2f", self.product.price * self.buyNum];
        
        if (remaindNum != -1 && remaindNum < self.buyNum) {
            labelRemaindTip.text = @"当前库存不足";
            [labelRemaindTip remakeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(20);
            }];
        }
        else {
            labelRemaindTip.text = @"";
            [labelRemaindTip remakeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(1);
            }];
        }
        
    }
    else if (indexPath.section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PayCellIdent"];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        
        btnAliBk = (UIButton*)[cell viewWithTag:401];
        btnAli = (UIButton*)[cell viewWithTag:402];
        btnWechatBk = (UIButton*)[cell viewWithTag:403];
        btnWechat = (UIButton*)[cell viewWithTag:404];
        
        [btnAliBk addTarget:self action:@selector(btnAliBKClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnWechatBk addTarget:self action:@selector(btnWechatBKClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        ShipAddressViewController *c = [storyboard instantiateViewControllerWithIdentifier:@"ShipAddressViewController"];
        [self.navigationController pushViewController:c animated:YES];
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
    
    DBG_MSG(@"result.code=%d, result.desc=%@", result.resultCode, result.desc);
    switch (result.requestType) {
        case kReqestType_SekBuy:
        case kReqestType_Buy:
        {
            if (result.resultCode == 0) {
                
                //订单提交成功去支付
                [self payOrder:result.data];
            }
            else if (result.resultCode == 1) {
                
                remaindNum = [[result.data objectForKey:@"remainder_num"] integerValue];
                if (remaindNum == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您选择的产品，已经被抢光了！请再看看其他产品吧。" delegate:self cancelButtonTitle:@"去首页" otherButtonTitles:@"返回详情", nil];

                    alert.tag = 10000;
                    [alert show];
                }
                else {
                    [self showTipsView:@"当前库存不足!"];
                    //刷新页面
                    
                    [self.tableView reloadData];
                }
            }
            else if (result.resultCode == 2) {
                [self showTipsView:@"参数错误!"];
            }
            else if (result.resultCode == 3) {
                [self showTipsView:@"系统错误!"];
            }
            else if (result.resultCode == 4) {
                [self showTipsView:@"当前订单金额超限，请分批下单购买!"];
            }
            else if (result.resultCode == 5) {
                [self showTipsView:@"超过抢购限制欢迎下次购买!"];
            }
            else if (result.resultCode == 6) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您有1个该商品订单未完成支付，请支付后再行购买!" delegate:self cancelButtonTitle:@"去支付" otherButtonTitles:nil];
                alertView.tag = 10001;
                [alertView show];
            }
            else if (result.resultCode == 7) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已有3个订单未支付，请支付后再行购买!" delegate:self cancelButtonTitle:@"去支付" otherButtonTitles:nil];
                alertView.tag = 10002;
                [alertView show];
            }
            else if (result.resultCode == 8 || result.resultCode == 99) {
                [self showTipsView:@"支付接口调用失败，请重试!"];
                [self performSelector:@selector(gotoMyConponsController) withObject:nil afterDelay:1];
            }
            else{
                [self showTipsView:@"订单提交失败!"];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    if (alertView.tag == 10000) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (buttonIndex == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else{
        [self performSelector:@selector(gotoMyConponsController) withObject:nil afterDelay:0];
    }
}

-(void)gotoMyConponsController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifiyGotoMyCoupons" object:nil];
    
    //当是从首页进来时,才需要pop到根结点
    BaseUIViewController *c = (BaseUIViewController*)self.navigationController.viewControllers[0];
    if ([c class] == [HomeViewController class]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
}


#pragma mark-
-(void)payOrder:(id)dict
{
    NSString *orderId;
    if (payType == PayType_WeChat) {
        dict = (NSDictionary *)dict;
        orderId = [dict objectForKey:KJsonElement_OID];
    }
    else if(payType == PayType_Ali){
        dict = (NSString *)dict;
    }
    //支付
    [[XDShareManager instance] payWithType:(int)payType order:^(XDPayOrder *order) {
        if (payType == PayType_WeChat) {
            
            XDWeChatOrder *or = (XDWeChatOrder*)order;
            or.appid = [dict objectForKey:@"appid"];
            or.noncestr = [dict objectForKey:@"noncestr"];
            or.package = [dict objectForKey:@"package"];
            or.partnerid = [dict objectForKey:@"partnerid"];
            or.prepayid = [dict objectForKey:@"prepayid"];
            or.timestamp = [dict objectForKey:@"timestamp"];
            or.sign = [dict objectForKey:@"sign"];
        }
        else if(payType == PayType_Ali){
            XDAliOrder *or = (XDAliOrder*)order;
            or.aliDescription = dict;
        }
    } result:^(int code) {
        /** 是否需要判断类型 **/
        DBG_MSG(@"pay result code=%d", code);
            switch (code) {
                case PaySuccess:     //成功
                {
                    //微信支付需要告诉后台移动端支付完成
                    if (payType == PayType_WeChat){
                        [[NetInterfaceManager sharedInstance] checkWXPay:orderId];
                    }
                    [self showTipsView:@"订单提交成功!"];
                    [self performSelector:@selector(gotoMyConponsController) withObject:nil afterDelay:1];
                }
                    break;
                case ErrCodeCommon:   //普通错误类型
                {
                    [self showTipsView:@"支付接口调用失败，请重试!"];
                    [self performSelector:@selector(gotoMyConponsController) withObject:nil afterDelay:1];
                }
                    break;
                case ErrCodeUserCancel:   //用户取消支付
                {
                    //[self showTipsView:@"你取消了支付!"];
                    [self performSelector:@selector(gotoMyConponsController) withObject:nil afterDelay:1];
                }
                    break;
                case WXNotInstalled:
                {
                    [self showTipsView:@"您的手机还没有安装微信，请先安装最新版的微信!"];
                    [self performSelector:@selector(gotoMyConponsController) withObject:nil afterDelay:1];
                }
                    break;
                case WXNotSupportApi:
                {
                    [self showTipsView:@"您安装的微信版本不支持微信支付，请先更新到最新版本!"];
                    [self performSelector:@selector(gotoMyConponsController) withObject:nil afterDelay:1];
                }
                    break;
                default:
                    break;
            }
    }];
}
@end
