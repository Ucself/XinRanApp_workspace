//
//  MyOrderViewController.m
//  XinRanApp
//
//  Created by mac on 14/12/16.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "MyOrderViewController.h"
#include "MeOrderTableViewCell.h"
#import "OrderDetailsViewController.h"

#import <XRUIView/SegmentedUIView.h>
#import <XRUIView/RefreshTableView.h>

#import <XRNetInterface/UIImageView+AFNetworking.h>
#import "User.h"
#import "Order.h"
#import <XRShareSDK/XDShareManager.h>


#import "DetailViewController.h"
@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,SegmentedUIViewDelegate>
#define NavBarFrame self.navigationController.navigationBar.frame
#define TopViewHeight 50
#define NavBarHeight 44

@end
@interface MyOrderViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    NSString *orderCode;
    int pageCount;//总页数
    int pageIndex;//当前页
    NSInteger status;//记录选中状态
    
    BOOL manualLoading;
    BOOL refresh;
    
    int selIndex;
    
    BOOL needRefresh;
}

@property (weak, nonatomic) IBOutlet RefreshTableView *tableView;



@property (weak, nonatomic) IBOutlet UIView *headView;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *switchSegment;

@property (strong,nonatomic) SegmentedUIView *segmentedUIView;

@property (nonatomic, strong) NSString *curOrderId;


//数据部分
@property (strong, nonatomic)NSMutableArray *showArray;

@end

@implementation MyOrderViewController

-(void)dealloc
{
    [self.showArray removeAllObjects];
    self.showArray =nil;
    self.segmentedUIView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initUI {
    [self followRollingScrollView:self.tableView];
    
    //加载界面视图
    [self setupSegmented];

    self.tableView.refreshDelegate = self;
    [self.tableView addHeaderView];
    [self.tableView addFootView];
    
    [self addGotoTopButton:nil];
}

- (void)viewDidLoad {
    
    isShowRequestPrompt = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self demo];
    pageIndex = 1;
    pageCount = 1;
    self.showArray = [NSMutableArray new];
    [self getData];
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList:) name:@"NoitfyRefreshList" object:nil];
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self getData];
//    [self setupSegmented];
//
//}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (needRefresh) {
//        [self getData];
//        needRefresh = NO;
//    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    //[super viewWillDisappear:animated];
    self.headView.hidden=NO;
}

//传递参数
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    OrderDetailsViewController *controller = segue.destinationViewController;
    if ([controller isKindOfClass:[OrderDetailsViewController class]]) {
        
        Order *order = (Order *)sender;
        controller.Id = order.Id;
        controller.delegate = self;
    }
}

-(void)getOrderType:(int)orderType page:(int)page showIndicator:(BOOL)showIndicator
{
    [[NetInterfaceManager sharedInstance] myOrders:orderType page:page];

    if (showIndicator) {
        [self startWait];
    }
}

-(void)refreshList:(NSNotification *)notification
{
    [self getData];
    //needRefresh = YES;
}

- (void)getData
{
    [self getOrderType:statusType_All page:1 showIndicator:YES];
    
}

#pragma mark -- 回调方法
-(void)controllerBackWithData:(id)data//回调方法
{
    //[self getData];
    //[self setupSegmented];
    
//    [[NetInterfaceManager sharedInstance] myOrders:3 page:1];
//    [self startWait];
    [self getOrderType:statusType_Cancel page:1 showIndicator:YES];
    [self.segmentedUIView setSelectedImageViewOfIndex:3];
}


#pragma mark --Segmented
//全部，未领取，已领取egmented分段
-(void)setupSegmented {
    
    if (!self.segmentedUIView) {
        self.segmentedUIView = [[SegmentedUIView alloc] init];
    }
    self.segmentedUIView.delegate = self;

    [self.headView addSubview:self.segmentedUIView];
    
    // tell constraints they need updating
    [self.headView setNeedsUpdateConstraints];
    // update constraints now so we can animate the change
    [self.headView updateConstraintsIfNeeded];
    [self.headView layoutIfNeeded];
//    [self.segmentedUIView  setFrame:self.headView.bounds];
    [self.segmentedUIView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headView);
    }];
    //添加约束
    [self.segmentedUIView initInterface];
}


#pragma mark -- SegmentedUIViewDelegate
//展示个数
- (NSInteger) numberOfData{
    return 4;
}
//每个单元的字符串名称
- (NSString *) stringForIndex:(NSInteger) index{
    switch (index) {
        case 0:
            return @"全部";
        case 1:
            return @"待付款";
        case 2:
            return @"待发货";
        case 3:
            return @"待收货";
        default:
            return @"";
    }
}
//选中每一个的时候激活的方法
- (void)segmentedUIView:(SegmentedUIView *)segmentedUIView didSelectRowAtIndexPath:(NSInteger) statusType sortType:(SegmentedSortType)sortType{
    pageIndex = 1;
    status = statusType;

    switch (statusType) {
        case statusType_All://全部
            //[self reloadDataWithStatus];
            [self getOrderType:statusType_All page:pageIndex showIndicator:YES];
            break;
        case statusType_NoRecive://待自提
            //[self reloadDataWithStatus:OrderStatus_NotPayment];

            [self getOrderType:statusType_NoRecive page:pageIndex showIndicator:YES];

            break;
        case statusType_Received://已完成
            //[self reloadDataWithStatus:OrderStatus_Received];

            [self getOrderType:statusType_Received page:pageIndex showIndicator:YES];


            break;
        case statusType_Cancel://已取消||已过期
            //[self reloadDataWithStatus:OrderStatus_Cancel andStatus:OrderStatus_Invalid];

            [self getOrderType:statusType_Cancel page:pageIndex showIndicator:YES];

            break;
        default:
            break;
    }
    
}

//- (void)reloadDataWithStatus
//{
//    self.showArray = self.dataArray;
//    [self.tableView reloadData];
//
//}
//- (void)reloadDataWithStatus:(OrderStatus)status
//{
//        NSMutableArray *array = [NSMutableArray array];
//        for (Order *order in self.dataArray) {
//            if (order.status == status) {
//                [array addObject:order];
//            }
//            self.showArray = array;
//        }
//    
//        [self.tableView reloadData];
//   
//}
//- (void)reloadDataWithStatus:(OrderStatus)status1 andStatus:(OrderStatus)status2
//{
//    NSMutableArray *array = [NSMutableArray array];
//    for (Order *order in self.dataArray) {
//        if (order.status==status1||order.status==status2) {
//            [array addObject:order];
//        }
//        self.showArray = array;
//    }
//    
//    [self.tableView reloadData];
//    
//}


//选中的排序类型
- (void)segmentedUIView:(SegmentedUIView *)segmentedUIView didSelectSortAtIndexPath:(NSInteger) indexPath sortType:(SegmentedSortType)sortType{

}
//是否有排序图标,默认不显示
- (BOOL)segmentedUIView:(NSInteger) indexPath{
    //都不要排序图标
    return NO;
}



#pragma mark- UITableview delegate mothed
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.showArray.count) {
        return 149;
    }
    
    Order *order = self.showArray[indexPath.row];
    if (order) {
        switch (order.status) {
            case OrderStatus_NotPayment:
            case OrderStatus_Sent:
            case OrderStatus_Commit:
                return 185;
                break;
                
            case OrderStatus_Received:
            case OrderStatus_Confirm:
            case OrderStatus_Cancel:
            case OrderStatus_Invalid:
            case OrderStatus_Payment:
                return 149;
                break;
            default:
                break;
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (self.showArray && self.showArray.count!=0) {
        return self.showArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.showArray || self.showArray.count == 0) {
        return nil;
    }
    
    static NSString *cellID = @"MeOrderTableViewCellIdent";
    MeOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MeOrderTableViewCell" owner:self options:0] firstObject];
        cell.delegate = self;
    }
    
    if (indexPath.row >= self.showArray.count) {
        return cell;
    }
    
    Order *order = self.showArray[indexPath.row];
    cell.index = (int)indexPath.row;
    
    
    NSRange rang = {0,10};
    NSString *startTime = [order.addTime substringWithRange:rang];
    cell.timeLabel.text = startTime;//开始日期
    //订单下的第一个商品
    NSMutableArray *goodArray = order.arGoods;
    if (goodArray.count>0) {
        OrderPdt *goodArrayPdt = (OrderPdt*)goodArray[0];
        [cell.headerImageView setImageWithURL:[NSURL URLWithString:goodArrayPdt.image] placeholderImage:[UIImage imageNamed:@"icon_defaut_img"]];
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f",goodArrayPdt.price];
        cell.allpriceLabel.text = [NSString stringWithFormat:@"实付: ￥%0.2f",goodArrayPdt.price * goodArrayPdt.num];
        cell.numberLabel.text = [NSString stringWithFormat:@"× %d", goodArrayPdt.num];//产品数量
        cell.productLabel.text = goodArrayPdt.name;//产品名称
        cell.productDetail.text = goodArrayPdt.desc;
    }
    cell.btnOpt.hidden = YES;
    cell.btnCancel.hidden = YES;
    switch (order.status) {//订单状态
        case OrderStatus_NotPayment:              //未付款
        case OrderStatus_Commit:                  //已提交
            [cell.stateButton setTitle:@"待付款" forState:UIControlStateNormal];
            [cell.btnOpt setTitle:@"付  款" forState:UIControlStateNormal];
            cell.btnCancel.hidden = NO;
            cell.btnOpt.hidden = NO;
            break;
        case OrderStatus_Payment:                 //已付款
            [cell.stateButton setTitle:@"待发货" forState:UIControlStateNormal];
            break;
        case OrderStatus_Sent:                    //已发货
            [cell.stateButton setTitle:@"已发货" forState:UIControlStateNormal];
            [cell.btnOpt setTitle:@"确认收货" forState:UIControlStateNormal];
            cell.btnOpt.hidden = NO;
            
            break;
        case OrderStatus_Received:                //已收货
            [cell.stateButton setTitle:@"已收货" forState:UIControlStateNormal];
            
            break;
        case OrderStatus_Confirm:                 //已确认
            [cell.stateButton setTitle:@"已确认" forState:UIControlStateNormal];
            
            break;
        case OrderStatus_Cancel:                  //已取消
            [cell.stateButton setTitle:@"已取消" forState:UIControlStateNormal];
            
            break;
        case OrderStatus_Invalid:                 //已过期
            [cell.stateButton setTitle:@"已过期" forState:UIControlStateNormal];
            
            break;
        default:
            [cell.stateButton setTitle:@"已过期" forState:UIControlStateNormal];
            break;
    }

    return cell;
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Order *data = self.showArray[indexPath.row];
    [self performSegueWithIdentifier:@"toGiftDetails" sender:data];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
    //        [cell setSeparatorInset:UIEdgeInsetsZero];
    //    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    //下拉加载更多view重定位
    [self.tableView tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //if (pageCount > 1 && pageCount > pageIndex) {
        [self.tableView scrollViewWillBeginDecelerating:scrollView];
    //}
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tableView scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //if (pageCount > 1 && pageCount > pageIndex) {
        [self.tableView scrollViewDidScroll:scrollView];
    //}
    
    //显示返回到顶部按钮
    if (scrollView.contentSize.height > scrollView.frame.size.height + 200) {
        
        int offsetY = scrollView.contentOffset.y;
        //DBG_MSG(@"---y=%d", offsetY);
        if (offsetY > abs(200)) {
            [self showGotoTopButton:YES];
        }
        else {
            [self showGotoTopButton:NO];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //if (pageCount > 1 && pageCount > pageIndex) {
        [self.tableView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    //}
}

#pragma mark - RefreshTableViewDelegate
-(void) refreshData
{
    manualLoading = YES;
    refresh = YES;
    pageIndex = 1;
    switch (status) {
        case statusType_All://全部
            [self getOrderType:statusType_All page:pageIndex showIndicator:NO];
            break;
        case statusType_NoRecive://待自提
            [self getOrderType:statusType_NoRecive page:pageIndex showIndicator:NO];
            break;
        case statusType_Received://已完成
            [self getOrderType:statusType_Received page:pageIndex showIndicator:NO];
            break;
        case statusType_Cancel://已取消||已过期
            [self getOrderType:statusType_Cancel page:pageIndex showIndicator:NO];
            break;
        default:
            break;
    }
}

-(void) loadMoreData //didSelectRowAtIndexPath:(NSInteger) indexPath
{
    if (pageCount > 1 && pageCount > pageIndex) {
        manualLoading = YES;
        refresh = NO;
        pageIndex++;
        switch (status) {
            case statusType_All://全部
                [self getOrderType:statusType_All page:pageIndex showIndicator:NO];
                break;
            case statusType_NoRecive://待自提
                [self getOrderType:statusType_NoRecive page:pageIndex showIndicator:NO];
                break;
            case statusType_Received://已完成
                [self getOrderType:statusType_Received page:pageIndex showIndicator:NO];
                break;
            case statusType_Cancel://已取消||已过期
                [self getOrderType:statusType_Cancel page:pageIndex showIndicator:NO];
                break;
            default:
                break;
        }
    }

}

#pragma mark- 跟随滚动的滑动视图

//滑动出现导航bar
-(void)showNaigationBar:(BOOL)show{
    //是否显示自定义的导航分类
    [self.headView setHidden:!show];
    
    [super showNaigationBar:show];
}

- (IBAction)btnGotoTopClick:(id)sender {

        [self showNaigationBar:YES];
        [UIView animateWithDuration:0.5 animations:^{

            [self.tableView scrollRectToVisible:CGRectMake(0, 0, 0.01, 0.01) animated:YES];

        }];
    
}

#pragma mark- 获取订单号按钮
-(void)onDetailBtnClick:(id)sender Id:(NSString*)orderId
{
    UIButton * btn = (UIButton*)sender;
    
    if ([[btn titleForState:UIControlStateNormal] isEqualToString:@"再次购买"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        DetailViewController *detail = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];

        for (Order *order in self.showArray) {
            if ([orderId isEqualToString:order.Id]) {
                detail.dId = order.adid;
                detail.imageUrl = order.image;
                break;
            }
           
        }
        
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        [[NetInterfaceManager sharedInstance] sendgfcode:orderId];
        orderCode = orderId;
        [self startWait];
    }
}

-(void)onCancelOrder:(int)index
{
    selIndex = index;
    [self cancelOrder];
    
}

-(void)onOpreatOrder:(int)index
{
    Order *order = self.showArray[index];
    self.curOrderId = order.Id;
    
    OrderPdt *orderPdt = [order.arGoods objectAtIndex:0];
    if (order.status == OrderStatus_NotPayment) {
        if (order.payment_id == PayType_WeChat) {
            [self weixinPay:orderPdt.name price:[NSString stringWithFormat:@"%0.2f", orderPdt.price * orderPdt.num] orderId:order.Id];
        }
        else if(order.payment_id == PayType_Ali){
            [self aliPay:orderPdt.name price:[NSString stringWithFormat:@"%0.2f", orderPdt.price * orderPdt.num] orderId:order.Id];
        }
    }
    else{
        [self confirmOrder];
    }
}

#pragma mark - 取消\确认订单
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
        Order *order = [self.showArray objectAtIndex:selIndex];
        if (!order) {
            return;
        }
        
        if (alertView.tag == 111) {  //取消订单
            [[NetInterfaceManager sharedInstance] cancelOrder:order.Id];
            [self startWait];

        }
        else if (alertView.tag == 112) {   //确认订单
            [[NetInterfaceManager sharedInstance] finishOrder:order.Id];
            [self startWait];
        }

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
        case KReqestType_MyOrders:
            if (result.resultCode == 0) {
                if (manualLoading) {
                    if (refresh) {
                        self.showArray = [result.data objectForKey:KJsonElement_Data];
                        pageCount = [[result.data objectForKey:KJsonElement_Pages] intValue];
                        if (pageCount > 1) {
                            [self.tableView addFootView];
                        }
                        else {
                            
                            [self.tableView removeFootView];
                            
                        }
                        
                        [self.tableView doneLoadingRefreshData];
                        
                        self.tableView.contentOffset = CGPointMake(0,0);
                    }
                    else {
                        //加载更多
                        [self.showArray addObjectsFromArray:[result.data objectForKey:KJsonElement_Data]];
                        [self.tableView doneLoadingMoreData];
                    }

                    refresh = NO;
                    manualLoading = NO;
                    
                    if (pageIndex >= pageCount) {
                        [self.tableView removeFootView];
                    }

                }
                else {
                    
                    self.showArray = [result.data objectForKey:KJsonElement_Data];
                    pageCount = [[result.data objectForKey:KJsonElement_Pages] intValue];

                    if (pageCount > 1) {
                        [self.tableView addFootView];
                    }
                    else {

                        [self.tableView removeFootView];

                    }

                    self.tableView.contentOffset = CGPointMake(0,0);
                }
                
                [self.tableView reloadData];
                
            }
            break;
        case KReqestType_Sendgfcode:
            if (result.resultCode == 0) {
                [self showTipsView:@"订单已发送, 请注意查收!"];
            }
            else if (result.resultCode == 1) {
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
                [self showTipsView:@"订单取消成功!"];
                
                //reload data
                pageIndex = 1;
                [self getOrderType:statusType_All page:pageIndex showIndicator:YES];
                
                //刷新全部订单数据的时候设置选中是索引为第一个
                [self.segmentedUIView setSelectedImageViewOfIndex:0];
            }
            else{
                [self showTipsView:@"您已经取消订单了"];
            }
            break;
        case KReqestType_Finishorder: //确认订单
            if (result.resultCode == 0) {
                [self showTipsView:@"确认订单成功!"];
                
                //reload data
                pageIndex = 1;
                [self getOrderType:statusType_All page:pageIndex showIndicator:YES];
            }
            else{
                [self showTipsView:@"确认订单失败!"];
            }
            break;
        case KReqestType_weixinPay:   //微信支付
            if (result.resultCode == 0) {
                [self payOrder:PayType_WeChat data:result.data];
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
                [self payOrder:PayType_Ali data:result.data];
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
    ResultDataModel *result = notification.object;
    if (!result) {
        DBG_MSG(@"http result is nil!");
        return;
    }
    
    switch (result.requestType) {
        case KReqestType_MyOrders:
            if (manualLoading) {
                if (refresh) {
                    [self.tableView doneLoadingRefreshData];
                }
                else {
                    //加载更多
                    [self.tableView doneLoadingMoreData];
                }
                refresh = NO;
                manualLoading = NO;
            }
            break;
        case KReqestType_Sendgfcode:

            break;
        case KReqestType_CancelOrder://取消订单

            break;
        case KReqestType_Finishorder: //确认订单

            break;
        default:
            break;
    }
}

#pragma mark-
-(void)weixinPay:(NSString*)pdtName price:(NSString*)price orderId:(NSString*)orderId
{
    [[NetInterfaceManager sharedInstance] weixinPay:pdtName price:price orderId:orderId];
    [self startWait];
}
-(void)aliPay:(NSString*)pdtName price:(NSString*)price orderId:(NSString*)orderId
{
    [[NetInterfaceManager sharedInstance] aliPay:pdtName price:price orderId:orderId];
    [self startWait];
}
-(void)payOrder:(int)payType data:(id)dict
{
    if (!dict) {
        return;
    }
    NSString *orderId;
    if (payType == PayType_WeChat) {
        dict = (NSDictionary *)dict;
        orderId = self.curOrderId;
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
                }
                    break;
                case ErrCodeCommon:
                {
                    [self showTipsView:@"支付接口调用失败，请重试!"];
                }
                    break;
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
