//
//  GiftDtailViewController.m
//  XinRanApp
//
//  Created by mac on 15/1/6.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "DetailViewController.h"

#import <XRUIView/RefreshTableView.h>
#import <XRUIView/DynaButton.h>

#import "Order.h"
#import "User.h"
#import "Areas.h"

#import <XRNetInterface/UIImageView+AFNetworking.h>

#import <XRShareSDK/XDShareManager.h>


@interface OrderDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    int lableWidth;
    
    UIButton *btnAliBk;
    UIButton *btnAli;
    UIButton *btnWechatBk;
    UIButton *btnWechat;
    int payType;
}

@property (weak, nonatomic) IBOutlet RefreshTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnOpt;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIView *btmView;

@property (strong,nonatomic) Order *order;

- (IBAction)cancelOrder:(id)sender;
@end

@implementation OrderDetailsViewController

-(void)dealloc
{
    self.order = nil;
    
//    [self.btnGetGift stopTimer];
}

- (void)viewDidLoad {
    
    isShowRequestPrompt = YES;
    payType = PayType_WeChat;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.hidden = YES;
    //self.btnGetGift.hidden = YES;
    [self getData];
    [self initUI];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(-1, 0, 0, 0)];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}


- (void)initUI
{
//    [self.btnGetGift setDelegate:self];
//    [self.btnGetGift setTimeInterval:120];
//    [self.btnGetGift setTitle:@"发送订单号" textColor:[UIColor whiteColor] normalImage:[UIImage imageNamed:@"btn_orangebtn_n"] highImage:[UIImage imageNamed:@"btn_orangebtn_h"]];
}
- (void)getData
{
    DBG_MSG(@"id=%@",self.Id);
    [[NetInterfaceManager sharedInstance] orderDetail:self.Id];
    [self startWait];
    
}

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.order.status == OrderStatus_Payment ||
        self.order.status == OrderStatus_Cancel||
        self.order.status == OrderStatus_Invalid) {
        return 4;
    }
    
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }
    else if (indexPath.section == 1) {
        return 85;
    }
    else if (indexPath.section == 2) {
        if (self.order.status == OrderStatus_Sent ||
            self.order.status == OrderStatus_Received ||
            self.order.status == OrderStatus_Confirm) {
            return 110;         //物流高度
        }
        else {
            return 130;         //商品高度
        }
        
    }
    else if (indexPath.section == 3) {
        if (self.order.status == OrderStatus_NotPayment ||
            self.order.status == OrderStatus_Commit) {
            return 100;          //支付高度
        }
        else if (self.order.status == OrderStatus_Payment ||
                 self.order.status == OrderStatus_Cancel ||
                 self.order.status == OrderStatus_Invalid) {
            
            if (self.order.status == OrderStatus_Sent) {
                return 80;         //有确认到货时间高度
            }
            else {
                return 56;         //无确认到货时间高度
            }
        }
        else {
            return 130;            //商品高度
        }
    }
    else if (indexPath.section == 4) {
        if (self.order.status == OrderStatus_Sent) {
            return 80;             //有确认到货时间高度
        }
        else {
            return 56;             //无确认到货时间高度
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"orderInfoCellIdent"];
        UILabel *labelStatus = (UILabel *)[cell viewWithTag:101];
        UILabel *labelPay = (UILabel *)[cell viewWithTag:102];
        UILabel *labelPrice = (UILabel *)[cell viewWithTag:103];
        
        if (self.order.payment_name) {
            labelPay.text = [NSString stringWithFormat:@"支付方式:  %@", self.order.payment_name];
        }
        
        labelPrice.text = [NSString stringWithFormat:@"订单金额:  ￥%0.2f",self.order.price];

        self.btnOpt.hidden = YES;
        self.btnCancel.hidden = YES;
        switch (self.order.status) {//订单状态
            case OrderStatus_NotPayment:              //未付款
            case OrderStatus_Commit:                  //已提交
                labelStatus.text = @"未付款";
                [self.btnOpt setTitle:@"付  款" forState:UIControlStateNormal];
                self.btnOpt.hidden = NO;
                self.btnCancel.hidden = NO;
                break;
            case OrderStatus_Payment:                 //已付款
            {
                labelStatus.text = @"已付款";
//                self.btnCancel.hidden = NO;
//                self.btnOpt.hidden= YES;
//                [self.btnCancel remakeConstraints:^(MASConstraintMaker *make) {
//                    make.right.equalTo(cell.right).offset(0).priorityHigh();
//                }];
            }
                break;
            case OrderStatus_Sent:                    //已发货
                labelStatus.text = @"已发货";
                [self.btnOpt setTitle:@"确认收货" forState:UIControlStateNormal];
                self.btnOpt.hidden= NO;

                break;
            case OrderStatus_Received:                //已收货
                labelStatus.text = @"已收货";

                break;
            case OrderStatus_Confirm:                 //已确认
                labelStatus.text = @"已确认";

                break;
            case OrderStatus_Cancel:                  //已取消
                labelStatus.text = @"已取消";

                break;
            case OrderStatus_Invalid:                 //已过期
                labelStatus.text = @"已过期";

                break;
            default:
                break;
        }

    }
    if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"getInfoCellIdent"];
        UILabel *labelUser = (UILabel *)[cell viewWithTag:201];
        UILabel *labelPhone = (UILabel *)[cell viewWithTag:202];
        UILabel *labelAddr = (UILabel *)[cell viewWithTag:203];
        
        //数据库取数据
        NSString *stringDistrict=@"";
        NSString *stringCity=@"";
        NSString *stringProvince=@"";
        //取县区
        Areas *arDistrict = [Areas getArearWithId:self.order.area_id];
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
        
        
        NSMutableString *string = [NSMutableString stringWithCapacity:0];
        if (stringProvince) {
            [string appendFormat:@"%@", stringProvince];
        }
        if (stringCity) {
            [string appendFormat:@"%@", stringCity];
        }
        if (stringDistrict) {
            [string appendFormat:@"%@", stringDistrict];
        }
        
        [string appendFormat:@"%@", self.order.address];
        
        labelUser.text = [NSString stringWithFormat:@"领取人:     %@", self.order.consignee];
        labelPhone.text = [NSString stringWithFormat:@"%@", self.order.phone];
        labelAddr.text = [NSString stringWithFormat:@"领取地址:  %@", string];
    }
    if (indexPath.section == 2) {
        if (self.order.status == OrderStatus_Sent ||
            self.order.status == OrderStatus_Received ||
            self.order.status == OrderStatus_Confirm) {
            cell = [self getShipCell:tableView];
        }
        else {
             cell = [self getPdtCell:tableView];
        }
       
    }
    if (indexPath.section == 3) {
        if (self.order.status == OrderStatus_NotPayment ||
            self.order.status == OrderStatus_Commit) {
            cell = [self getPayCell:tableView];
        }
        else if (self.order.status == OrderStatus_Payment ||
                 self.order.status == OrderStatus_Cancel ||
                 self.order.status == OrderStatus_Invalid) {
             cell = [self getOrderIdCell:tableView];
        }
        else {
            cell = [self getPdtCell:tableView];;
        }
    }
    else if (indexPath.section == 4) {
        cell = [self getOrderIdCell:tableView];
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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

-(UITableViewCell*)getPdtCell:(UITableView*)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductInfoCellIdent"];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:301];
    UILabel *labelProductName = (UILabel *)[cell viewWithTag:302];
    UILabel *labelPrice = (UILabel *)[cell viewWithTag:303];
    UILabel *labelNum = (UILabel *)[cell viewWithTag:304];
    UILabel *labelAllPrice = (UILabel *)[cell viewWithTag:305];
    UILabel *labelDesc= (UILabel *)[cell viewWithTag:306];
    
    imageView.layer.borderWidth = 0.3;
    imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    OrderPdt *orderPdt = [self.order.arGoods objectAtIndex:0];
    //[imageView setImageWithURL:[NSURL URLWithString:orderPdt.image]];//商品图片
    [imageView setImageWithURL:[NSURL URLWithString:orderPdt.image] placeholderImage:[UIImage imageNamed:@"icon_defaut_img"]];
    labelProductName.text = orderPdt.name;//商品名称
    labelPrice.text = [NSString stringWithFormat:@"￥%0.2f",orderPdt.price];
    labelNum.text = [NSString stringWithFormat:@"x %d",orderPdt.num];
    labelAllPrice.text = [NSString stringWithFormat:@"实付: ￥%0.2f", orderPdt.price * orderPdt.num];
    labelDesc.text = orderPdt.desc;
    
    return cell;
}

-(UITableViewCell*)getPayCell:(UITableView*)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayCellIdent"];
    
    btnAliBk = (UIButton*)[cell viewWithTag:401];
    btnAli = (UIButton*)[cell viewWithTag:402];
    btnWechatBk = (UIButton*)[cell viewWithTag:403];
    btnWechat = (UIButton*)[cell viewWithTag:404];
    
    [btnAliBk addTarget:self action:@selector(btnAliBKClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnWechatBk addTarget:self action:@selector(btnWechatBKClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.order.payment_id == PayType_Ali) {
        [self btnAliBKClick:nil];
    }
    else if (self.order.payment_id == PayType_WeChat) {
        [self btnWechatBKClick:nil];
    }
    
    return cell;
}

-(UITableViewCell*)getOrderIdCell:(UITableView*)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderIDCellIdent"];
    
    UILabel *labelId = (UILabel *)[cell viewWithTag:501];
    UILabel *labelTime = (UILabel *)[cell viewWithTag:502];
    UILabel *labelReceiveTime = (UILabel *)[cell viewWithTag:503];
    
    labelId.text = self.order.sn;
    labelTime.text = self.order.addTime;
    
    //自动确认收货时间
    if (self.order.status == OrderStatus_Sent) {
        NSString *receiveTime = [DateUtils afterDays:15 date:self.order.shipping_time];
        labelReceiveTime.text = [NSString stringWithFormat:@"%@", receiveTime];
    }
    
    return cell;
}

-(UITableViewCell*)getShipCell:(UITableView*)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shipInfoCellIdent"];
    
    UILabel *labelCode = (UILabel *)[cell viewWithTag:602];
    UILabel *labelCompany = (UILabel *)[cell viewWithTag:601];
    UILabel *labelTime = (UILabel *)[cell viewWithTag:603];
    
    labelCode.text = self.order.shipping_code;
    labelCompany.text = self.order.shipping_company;
    labelTime.text = self.order.shipping_time;
    
    return cell;
}


#pragma mark-
-(void)btnWechatBKClick:(id)sender
{
    [btnAli setBackgroundImage:[UIImage imageNamed:@"chenk_n"] forState:UIControlStateNormal];
    [btnWechat setBackgroundImage:[UIImage imageNamed:@"chenk_h"] forState:UIControlStateNormal];
    payType = PayType_WeChat;
}

-(void)btnAliBKClick:(id)sender
{
    [btnAli setBackgroundImage:[UIImage imageNamed:@"chenk_h"] forState:UIControlStateNormal];
    [btnWechat setBackgroundImage:[UIImage imageNamed:@"chenk_n"] forState:UIControlStateNormal];
    payType = PayType_Ali;
}

- (IBAction)btnCancelOrderClick:(id)sender {
    [self cancelOrder];
}


- (IBAction)btnOptClick:(id)sender {
    //根据订单状态做不同操作
    if (self.order.status == OrderStatus_NotPayment) {
        //付款
        OrderPdt *orderPdt = [self.order.arGoods objectAtIndex:0];
        if (payType == PayType_WeChat) {
            [self weixinPay:orderPdt.name price:[NSString stringWithFormat:@"%0.2f", orderPdt.price * orderPdt.num] orderId:self.order.Id];
        }
        else if (payType == PayType_Ali) {
            [self aliPay:orderPdt.name price:[NSString stringWithFormat:@"%0.2f", orderPdt.price * orderPdt.num] orderId:self.order.Id];
        }
        
    }
    else if (self.order.status == OrderStatus_Sent) {
        //确认收货
        [self confirmOrder];
    }
}

//-(void)dynaButtonClick:(UIView*)sender
//{
//    NSString *Id = self.order.Id;
//    DBG_MSG(@"oderId = %@",Id);
//    if ([self.btnGetGift.title isEqualToString:@"再次购买"]) {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
//        DetailViewController *detail = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
//        //detail.Id = self.order.Id;
//        detail.dId = self.order.adid;
//        detail.imageUrl = self.order.image;
//        [self.navigationController pushViewController:detail animated:YES];
//        
//    }else{
//        
//            [[NetInterfaceManager sharedInstance] sendgfcode:Id];
//            [self startWait];
//      
//    }
//    
//}


- (void)resetUI
{
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    
    if (self.order.status == OrderStatus_NotPayment ||
        self.order.status == OrderStatus_Commit ||
        self.order.status == OrderStatus_Sent) {
        [self.btmView remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(45);
        }];
        //self.btnGetGift.hidden = YES;
        //[self.btnGetGift setTitle:@"再次购买" textColor:[UIColor whiteColor] normalImage:[UIImage imageNamed:@"btn_orangebtn_n"] highImage:[UIImage imageNamed:@"btn_orangebtn_h"]];
    }
    else {
        //self.btnGetGift.hidden = NO;
        [self.btmView remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0);
        }];
    }
}


#pragma mark- httpRequestFinished
-(void)httpRequestFinished:(NSNotification *)notification
{
    [self stopWait];
    ResultDataModel *result = notification.object;
    
    if (!result) {
        DBG_MSG(@"http result is nil!");
        return;
    }
    
    switch (result.requestType) {
        case KReqestType_OrderDetail:
            if (result.resultCode == 0) {
               
                self.order = result.data;
                [self resetUI];
            }
            else {
                DBG_MSG(@"result.code=%d, result.desc=%@", result.resultCode, result.desc);
            }
            break;
        case KReqestType_Sendgfcode:
            if (result.resultCode == 0) {
                //[self.btnGetGift beginTimer:@"KReqestType_Sendgfcode_Gift"];
                [self showTipsView:@"订单已发送, 请注意查收!"];
            }
            else if (result.resultCode == 1){
                [self showTipsView:@"对不起，你今日获取次数已达上限!"];
            }
            else if (result.resultCode == 2) {
                [self showTipsView:@"对不起，请2分钟后再重复操作!"];
            }
            else {
                [self showTipsView:@"对不起，获取失败!"];
                DBG_MSG(@"result.code=%d, result.desc=%@", result.resultCode, result.desc);
            }
            break;
        case KReqestType_CancelOrder://取消订单
            if (result.resultCode == 0) {
                self.order.status = OrderStatus_Cancel;
                [self resetUI];
                
                [self showTipsView:@"订单取消成功!"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NoitfyRefreshList" object:nil];

            }
            else{
                [self showTipsView:@"您已经取消订单了"];
            }
            break;
        case KReqestType_Finishorder: //确认订单
            if (result.resultCode == 0) {
                self.order.status = OrderStatus_Confirm;
                [self resetUI];
                
                [self showTipsView:@"确认订单成功!"];
            }
            else{
                [self showTipsView:@"确认订单失败!"];
            }
            break;
        case KReqestType_weixinPay:   //微信支付
            if (result.resultCode == 0) {
                [self payOrder:result.data];
            }
            else if (result.resultCode == 8) {
                [self showTipsView:@"支付接口调用失败，请重试!"];
            }
            else {
                [self showTipsView:@"支付接口调用失败，请重试!"];
                DBG_MSG(@"result.code=%d, result.desc=%@", result.resultCode, result.desc);
            }
            break;
        case KReqestType_AliPay:   //支付宝支付
            
            if (result.resultCode == 0) {
                [self payOrder:result.data];
            }
            else if (result.resultCode == 8) {
                [self showTipsView:@"支付接口调用失败，请重试!"];
            }
            else {
                [self showTipsView:@"支付接口调用失败，请重试!"];
                DBG_MSG(@"result.code=%d, result.desc=%@", result.resultCode, result.desc);
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
#pragma mark - 取消订单
- (void)cancelOrder {
    DBG_MSG(@"取消订单");
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定取消订单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 111;
    [alertView show];
}

-(void)confirmOrder
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确认收货? 确认后将完成交易!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 112;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag == 111) {
        
            if (self.order.Id == nil) {
                [self showTipsView:@"请检查网络链接!"];
                return;
            }
            [[NetInterfaceManager sharedInstance] cancelOrder:self.order.Id];
            [self startWait];
        }
        else if (alertView.tag == 112) {
            [[NetInterfaceManager sharedInstance] finishOrder:self.order.Id];
            [self startWait];
        }
    }
    
}

#pragma mark-
//微信支付
-(void)weixinPay:(NSString*)pdtName price:(NSString*)price orderId:(NSString*)orderId
{
    [[NetInterfaceManager sharedInstance] weixinPay:pdtName price:price orderId:orderId];
    [self startWait];
}
//支付宝支付
-(void)aliPay:(NSString*)pdtName price:(NSString*)price orderId:(NSString*)orderId
{
    [[NetInterfaceManager sharedInstance] aliPay:pdtName price:price orderId:orderId];
    [self startWait];
}

-(void)payOrder:(id)dict
{
    if (!dict) {
        return;
    }
    
    NSString *orderId;
    if (payType == PayType_WeChat) {
        dict = (NSDictionary *)dict;
        orderId = self.order.Id;
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
        DBG_MSG(@"pay result code=%d", code);
            switch (code) {
                case PaySuccess:
                {
                    //微信支付需要告诉后台移动端支付完成
                    if (payType == PayType_WeChat){
                        [[NetInterfaceManager sharedInstance] checkWXPay:orderId];
                    }
                    //刷新数据
                    [self getData];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NoitfyRefreshList" object:nil];
                }
                    break;
                case ErrCodeCommon:
                {
                    [self showTipsView:@"支付接口调用失败，请重试!"];
                }
                case ErrCodeUserCancel:   //用户取消支付
                    break;
                case WXNotInstalled:
                {
                    [self showTipsView:@"您的手机还没有安装微信，请先安装最新版的微信!"];
                }
                    break;
                case WXNotSupportApi:
                {
                    [self showTipsView:@"您安装的微信版本不支持微信支付，请先更新到最新版本!"];
                }
                    break;
                default:
                    break;
            }
        
    }];
    
}
@end
