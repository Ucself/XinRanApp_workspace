//
//  ActivityListViewController.m
//  XinRanApp
//
//  Created by tianbo on 15-2-5.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "ActivityListViewController.h"
#import "SelectStoreViewController.h"
#import "DetailViewController.h"


#import "ActivityProductCell.h"
//#import "UIbutton+ImageLabel.h"
#import <XRUIView/UIbutton+ImageLabel.h>
//#import "PopoverMenu.h"
#import <XRUIView/PopoverMenu.h>

#import "Whouse.h"
#import "Product.h"
#import "User.h"

#define NavBarFrame self.navigationController.navigationBar.frame
#define TopViewHeight 60
#define NavBarHeight 44
#define TableViewTop  109

@interface ActivityListViewController ()
{
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelStoreAddr;
@property (weak, nonatomic) IBOutlet UIView *topView;


@property (nonatomic, strong) PopoverMenu *popMenu;

@property (nonatomic, copy)NSMutableArray *arrayProducts;
@property (nonatomic, copy)NSArray *arWhouses;
@property (nonatomic, strong)Whouse *curWhouse;

@property (assign, nonatomic) BOOL isRequestAll;  //发送请求标记
@end

@implementation ActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavBar];
    [self followRollingScrollView:self.tableView];
    
    [self addGotoTopButton:nil];
    
    //获取数据
    User *user = [[EnvPreferences sharedInstance] getUserInfo];
    if ([[EnvPreferences sharedInstance] getToken] &&  user.arUserWhouses && user.arUserWhouses.count != 0) {
        Whouse *house = [user.arUserWhouses objectAtIndex:0];
        
        self.curWhouse = house;
        self.labelStoreAddr.text = house.name;
        
        self.isRequestAll = NO;
        [self getListData:house.Id];
    }
    else {
        self.isRequestAll = YES;
        [self getListData:@""];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.topView.hidden=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
-(void)setupNavBar
{
    self.navigationItem.title = self.title;
    
    UIButton *btnR = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnR setFrame:CGRectMake(0, 0, 50, 40)];
    [btnR setImage:[UIImage imageNamed:@"icon_location"] withTitle:@"选择店铺" forState:UIControlStateNormal];
    [btnR addTarget:self action:@selector(btnSelecetStore:) forControlEvents:UIControlEventTouchUpInside];
    [btnR setTintColor:UIColor_DefGreen];
    
    //[btnR setBackgroundColor:[UIColor yellowColor]];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:btnR];
    self.navigationItem.rightBarButtonItem = barItem;
}

-(void)getListData:(NSString*)warehouseid
{
    [[NetInterfaceManager sharedInstance] actGoodsList:self.params wId:@""];
    [self startWait];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BaseUIViewController* controller = segue.destinationViewController;
    
    if ([controller isKindOfClass:[DetailViewController class]]) {
        //传递id和did到详情页
        Product *pdt = (Product*)sender;
        DetailViewController *c = (DetailViewController*)controller;
        c.Id = pdt.Id;
        c.dId = pdt.did;
        //c.whouseId = self.curWhouse.Id;
        c.imageUrl = pdt.image;
    }
}

-(void)controllerBackWithData:(id)data
{
    Whouse *whouse = (Whouse*)data;
    
    self.curWhouse = whouse;
    self.labelStoreAddr.text = whouse.name;
    self.isRequestAll = NO;
    [self getListData:whouse.Id];
}

#pragma mark- button click action
-(void)btnSelecetStore:(id)sender
{
    //选择店铺
//    SelectStoreViewController *selectStore = [[self storyboard] instantiateViewControllerWithIdentifier:@"SelectStoreViewController"];
//    self.delegate = self;
//    
//    if (self.curWhouse) {
//        Areas *area = [Areas getArearWithId:self.curWhouse.areaId];
//        
//        selectStore.selArea = area;
//    }
//    else if (!self.arWhouses || self.arWhouses.count == 0) {
//        [self showTipsView:@"当前没有可用店铺"];
//        return;
//    }
    
    UIButton *btn = (UIButton*)sender;

    if (!self.popMenu) {
        self.popMenu = [PopoverMenu new];
    }
    
    CGPoint pt = CGPointMake(CGRectGetMidX(btn.frame), CGRectGetMaxY(btn.frame) + 25);
    [self.popMenu showAtPoint:pt inView:self.view items:@[@"全部店铺", @"其它店铺"]];
    
    __weak __typeof(self)weakSelf = self;
    self.popMenu.selectHandler = ^(int index){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (index == 0) {
            strongSelf.labelStoreAddr.text = @"全部店铺";
            strongSelf.isRequestAll = YES;
            [strongSelf getListData:@""];
        }
        else if (index == 1){
            SelectStoreViewController *selectStore = [[strongSelf storyboard] instantiateViewControllerWithIdentifier:@"SelectStoreViewController"];
            selectStore.delegate = strongSelf;
            
            if (strongSelf.curWhouse) {
                Areas *area = [Areas getArearWithId:strongSelf.curWhouse.areaId];
                
                selectStore.selArea = area;
            }
            else if (!strongSelf.arWhouses || strongSelf.arWhouses.count == 0) {
                [strongSelf showTipsView:@"当前没有可用店铺"];
                return;
            }
            
            [strongSelf.navigationController pushViewController:selectStore animated:YES];
        }
        
    };
}

- (IBAction)btnGotoTopClick:(id)sender {
    [self showNaigationBar:YES];
    [UIView animateWithDuration:0.5 animations:^{
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 0.01, 0.01) animated:YES];
        
    }];
}


#pragma mark- UITableView Delegate mothed
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int width = self.view.bounds.size.width;
    int height= width*3/4;
    return height +90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayProducts.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ActivityProductCell";
    ActivityProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityProductCell" owner:self options:0] firstObject];
        int width = self.view.bounds.size.width;
        if (width <= 320) {
            [cell.timerView setFontSize:12];
        }
    }
    
    Product *product = [self.arrayProducts objectAtIndex:indexPath.row];
    [cell setImageUrl:product.image];
    
    cell.labelTitle.text = product.title;
    cell.labelPrice.text = [NSString stringWithFormat:@"¥%0.2f", product.price];
    cell.lablePriceAct.text = [NSString stringWithFormat:@"¥%0.2f", product.priceOld];
    
    NSString *strStatus = @"";
    switch (product.state) {
        case ProductStatus_End:
        {
            strStatus = @"已结束";
            //[cell.btnBuy setEnabled:NO];
            [cell.btnBuy setTitle:@"已经过期" forState:UIControlStateNormal];
        }
            break;
        case ProductStatus_Start:
        {
            strStatus = @"剩余时间:";
            //[cell.btnBuy setEnabled:NO];
            [cell.btnBuy setTitle:@"立即抢购" forState:UIControlStateNormal];
        }
            break;
        case ProductStatus_UnStart:
        {
            strStatus = @"距开始:";
            //[cell.btnBuy setEnabled:NO];
            [cell.btnBuy setTitle:@"即将开始" forState:UIControlStateNormal];
        }
            break;
        case ProductStatus_GrabEnd:
        {
            strStatus = @"剩余时间:";
            //[cell.btnBuy setEnabled:NO];
            [cell.btnBuy setTitle:@"已经抢完" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    
    cell.labelStatus.text = strStatus;
    if (product.state == ProductStatus_End) {
        cell.timerView.hidden = YES;
    }
    else {
        cell.timerView.hidden = NO;
        [cell setTimeInterval:product.seconds];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    Product *product = [self.arrayProducts objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"toDetail" sender:product];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//    
//    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
//        [cell setPreservesSuperviewLayoutMargins:NO];
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
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
    
    switch (result.requestType) {
        case KReqestType_ActGoodsList:
        {
            if (result.resultCode == 0) {
                self.arrayProducts = [result.data objectForKey:KJsonElement_Data];
                //[self sortWithKey:SortKey_Seconds asc:YES];
                if (self.isRequestAll) {
                    self.arWhouses = [result.data objectForKey:KJsonElement_WList];
                }
                
                [self.tableView reloadData];
            }
            else {
                [self showTipsView:@"数据获取失败!"];
                DBG_MSG(@"result.code=%d, result.desc=%@", result.resultCode, result.desc);
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


#pragma mark- 跟随滚动的滑动视图

-(void)showNaigationBar:(BOOL)show{
    //设置添加的View 是否显示
    [self.topView setHidden:!show];
    
    [super showNaigationBar:show];
    
}
@end
