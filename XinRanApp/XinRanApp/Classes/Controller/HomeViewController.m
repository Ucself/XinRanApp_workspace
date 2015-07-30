//
//  HomeViewController.m
//  XinRanApp
//
//  Created by tianbo on 14-12-5.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "HomeViewController.h"
//#import "ActivityTableViewCell.h"
//#import "ActivityPriceTableViewCell.h"
//#import "ProductTableViewCell.h"
//#import "ActivityListViewController.h"
#import "ProductListViewController.h"
#import "DetailViewController.h"

#import <XRUIView/BannerView.h>
#import "ProductForCmd.h"
#import "HomeInfoCache.h"
#import "Activity.h"
#import "User.h"
#import "Ads.h"
#import "GoodClass.h"

#import "SecondKillTableViewCell.h"
#import "CategoryTableViewCell.h"
#import "NewProductChildTableViewCell.h"
//#import "FineChooseTableViewCell.h"
#import "FineProductTableViewCell.h"


@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    BOOL manualLoading;
    BOOL hasCache;
    
    float tempFineChooseHeight; //根据设计图的比例计算
    
    
}

@property (nonatomic,copy) NSMutableArray *arrayAds;
@property (nonatomic,copy) NSMutableArray *arrayCommond;
@property (nonatomic,copy) NSMutableArray *arrayNews;
@property (nonatomic,copy) NSDictionary *arraySecKill;

@property (nonatomic,strong) BannerView *bannerView;
@property (nonatomic, strong) UIView *pdtHeadView;

//用户默认店铺
//@property (nonatomic, strong) Whouse *curWhouse;
@end

@implementation HomeViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI
{
    self.tableView.refreshDelegate = self;
    [self.tableView addHeaderView];
    //[self.tableView addFootView];
    
    int width = self.view.frame.size.width;
    int height = width*350/640;
    _bannerView = [[BannerView alloc] initWithFrame:CGRectMake(0, 0,width, height)];
    _bannerView.autoTurning = YES;
    _bannerView.placeholderImage = @"icon_defaut_long";
    
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor clearColor];
    headView.frame = CGRectMake(0, 0,width, height);
    [headView addSubview:_bannerView];
    self.tableView.tableHeaderView = headView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
    label.text = @"已经看完啦, 到上面去转转吧!";
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
//    self.tableView.tableFooterView = label;
    
    //设置背景为白色
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self addGotoTopButton:nil];
    //临时数据
     tempFineChooseHeight = deviceWidth/2 + 55; //根据设计图的比例计算
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    //获取本地缓存信息
    NSDictionary *dict = [[HomeInfoCache sharedInstance] getHomeInfo];
    if (dict && [dict allKeys].count>0) {
        hasCache = YES;
        isShowRequestPrompt = NO;
        self.arrayAds = [dict objectForKey:@"Ads"];
        self.arrayNews = [dict objectForKey:@"News"];
        self.arrayCommond = [dict objectForKey:@"Commonds"];
        self.arraySecKill = [dict objectForKey:@"Seckills"];
        
        if (self.arrayAds.count != 0) {
            
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < self.arrayAds.count; i++) {
                Ads *banner = [self.arrayAds objectAtIndex:i];
                [array addObject: banner.picAddr];
            }
            
            [self.bannerView loadImagesUrl:array];
            [self.bannerView addTimer];
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self requestHomeInfo];
        });
    }
    else {
        hasCache = NO;
        isShowRequestPrompt = YES;
        [self getLatestHomeInfo];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbktrans"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    [self.bannerView startTimer];
    
    //重置用户默认店铺
//    User *user = [[EnvPreferences sharedInstance] getUserInfo];
//    if ([[EnvPreferences sharedInstance] getToken] && user.arUserWhouses && user.arUserWhouses.count != 0) {
//        Whouse *house = [user.arUserWhouses objectAtIndex:0];
//        if (!self.curWhouse || ![self.curWhouse.Id isEqualToString:house.Id]) {
//            
//            self.curWhouse = house;
//        }
//    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    //{{20150123 tianbo 解决ios7 autolayout scroview 不能滚动问题
    if (ISIOS8BEFORE) {
        [self.bannerView refreshContentSize];
        //DBG_MSG(@"bannerView contentsize:%f, %f", self.bannerView.scrollView.contentSize.width, self.bannerView.scrollView.contentSize.height);
    }
    //}}
}

-(void)viewDidLayoutSubviews
{
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.bannerView stopTimer];
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}

#pragma mark-
//传递参数
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ProductForCmd *pdt = (ProductForCmd*)sender;
    
    BaseUIViewController* controller = segue.destinationViewController;
    if ([controller isKindOfClass:[DetailViewController class]]) {
        DetailViewController *c = (DetailViewController*)controller;
        c.Id = pdt.Id;
        c.dId = pdt.dId;
        c.imageUrl = pdt.image;
    }
    
    else if ([controller isKindOfClass:[ProductListViewController class]]) {
        
        NSDictionary *dicInfor = (NSDictionary *)sender;
        ProductListViewController *c = (ProductListViewController*)controller;
        c.title = [dicInfor objectForKey:@"title"];
        c.cId = [dicInfor objectForKey:@"id"];
    }
    
}

-(void)getLatestHomeInfo
{
    [self requestHomeInfo];
    //[self startWait];
}

-(void)requestHomeInfo
{
    DBG_MSG(@"enter");
    [[NetInterfaceManager sharedInstance] homeInfo];
}

//秒杀倒计时结束
-(void)secondEnd
{
    [self getLatestHomeInfo];
}

#pragma mark- uitableview delegate mothed

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //默认使用两个
    return 3;
}
//每个section的样式UIView
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section !=1 ) {
        return nil;
    }
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        //标题整体的UIView
        self.pdtHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth, 40.f)];
        [self.pdtHeadView setBackgroundColor:[UIColor clearColor]];
        
        //中间的UILable字体
        UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_newpdttitle"]];
        [self.pdtHeadView addSubview:titleView];
        [titleView makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(63);
            make.height.equalTo(15);
            make.centerY.equalTo(self.pdtHeadView.centerY);
            make.centerX.equalTo(self.pdtHeadView.centerX);
        }];
        
        //左边图标
        UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_left_newproduct"]];
        [self.pdtHeadView addSubview:leftImageView];
        [leftImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.pdtHeadView.left).offset(10);
            make.right.equalTo(titleView.left).offset(-10);
            make.centerY.equalTo(self.pdtHeadView.centerY);
            make.height.equalTo(5);
        }];
        
        //右边图标
        UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_right_newproduct"]];
        [self.pdtHeadView addSubview:rightImageView];
        [rightImageView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.pdtHeadView.right).offset(-10);
            make.left.equalTo(titleView.right).offset(10);
            make.centerY.equalTo(self.pdtHeadView.centerY);
            make.height.equalTo(5);
        }];
        
        
    });
    
    return self.pdtHeadView;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        //分类高度
        return 0.f;
    }
    if (section ==1) {
        return 40.f;
    }
    return 1.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
//        case 0:
//        {
//            if([self.arraySecKill allKeys].count == 0)
//            {
//                return 0;
//            }
//            //秒杀的高度 中部的秒杀商品如果根据设备计算可计算
//            int singleWidth = (deviceWidth - 30)/2;
//            return singleWidth + 45;
//        }
        case 0:
            //分类的高度
            return 95;
        case 1:
            //新品的高度
            return 140;
        case 2:
        {
            //最多显示八个
            int arrayCommondTempCount = self.arrayCommond.count > 8 ? 8 : (int)(self.arrayCommond.count);
            int nowChooseCount = arrayCommondTempCount%2==0 ? arrayCommondTempCount/2: arrayCommondTempCount/2+1;
            //精选的高度 根据数据来设定 此处都是临时数据
            return tempFineChooseHeight*nowChooseCount + 110;
        }
        default:
            return 100;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    //新品推荐应该有两个cell 根据数据源来设定不一定是两个
    if (section == 1) {
        return _arrayNews.count;
    }
    
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"";
    switch (indexPath.section) {
//        case 0:
//        {
//            if ([self.arraySecKill allKeys].count == 0) {
//                return [UITableViewCell new];
//            }
//            cellID = @"secondKillCell";
//            SecondKillTableViewCell *secondKillCell = [tableView dequeueReusableCellWithIdentifier:cellID];
//            if (secondKillCell == nil) {
//                secondKillCell = [[[NSBundle mainBundle] loadNibNamed:@"SecondKillTableViewCell" owner:self options:0] firstObject];
//                secondKillCell.delegate = self;
//            }
//            //设置数据源
//            secondKillCell.killDataSource = self.arraySecKill;
//            return secondKillCell;
//            
//        }
        case 0:
        {
            cellID = @"categoryCell";
            CategoryTableViewCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (categoryCell == nil) {
//                categoryCell = [[[NSBundle mainBundle] loadNibNamed:@"CategoryTableViewCell" owner:self options:0] firstObject];
                categoryCell = [[CategoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                categoryCell.delegate = self;
            }

            return categoryCell;
        }
        case 1:
        {
            cellID = @"newproductCell";
            NewProductChildTableViewCell *newPdtCell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (newPdtCell == nil) {
                newPdtCell = [[[NSBundle mainBundle] loadNibNamed:@"NewProductChildTableViewCell" owner:self options:0] firstObject];
            }
            
            ProductForCmd *pdt = [self.arrayNews objectAtIndex:indexPath.row];
            [newPdtCell setImageUrl:pdt.image];
            [newPdtCell.titleLabel setText:pdt.title];
            [newPdtCell.priceLabel setText:[NSString stringWithFormat:@"%.2f", pdt.price]];
            [newPdtCell.originalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", pdt.priceOld]];
            [newPdtCell.haveBuyLabel setText:[NSString stringWithFormat:@"%d人已购", pdt.saled]];
            return newPdtCell;
        }
        case 2:
        {
            cellID = @"fineChooseCell";
            FineProductTableViewCell * fineChooseCell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!fineChooseCell) {
                fineChooseCell = [[FineProductTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                fineChooseCell.delegate = self;
            }
            //临时数据测试
            [fineChooseCell setDataSource:self.arrayCommond];
            return fineChooseCell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [self clickNewProductViewCell:indexPath.row];
    }
}

#pragma mark- tableviewcell click event handler
//秒杀商品点击
-(void)clickSecondKillCell:(NSInteger)indexPath
{
    NSArray *arPdt = [self.arraySecKill objectForKey:KJsonElement_ArrayKills];
    ProductForCmd *pdt = [arPdt objectAtIndex:indexPath];
    [self performSegueWithIdentifier:@"toDetailView" sender:pdt];
    
}


//点击分类
-(void)clickCategoryTableViewCell:(NSInteger)indexPath dicInfor:(NSDictionary *)dicInfor
{
    [self performSegueWithIdentifier:@"toProductList" sender:dicInfor];
}

//点击新产品推荐
-(void)clickNewProductViewCell:(NSInteger)indexPath
{
    ProductForCmd *pdt = [self.arrayNews objectAtIndex:indexPath];
    [self performSegueWithIdentifier:@"toDetailView" sender:pdt];
}

//点击精品
//-(void)clickFineChooseCell:(NSInteger) indexPath
//{
//    ProductForCmd *pdt = [self.arrayCommond objectAtIndex:indexPath];
//    [self performSegueWithIdentifier:@"toDetailView" sender:pdt];
//}
-(void)clickFineProductCell:(int) indexPath
{
    ProductForCmd *pdt = [self.arrayCommond objectAtIndex:indexPath];
    [self performSegueWithIdentifier:@"toDetailView" sender:pdt];
}

#pragma mark- goto top button 
- (IBAction)btnGotoTopClick:(id)sender {
    //[self showNaigationBar:YES];
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 0.01, 0.01) animated:YES];

    }];
}

#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.tableView scrollViewWillBeginDecelerating:scrollView];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.tableView scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView scrollViewDidScroll:scrollView];
    
    //显示返回到顶部按钮
    if (scrollView.contentSize.height > scrollView.frame.size.height + 200) {

        int offsetY = scrollView.contentOffset.y;
        //DBG_MSG(@"---y=%d", offsetY);
        if (offsetY > abs(200)) {
            [self showGotoTopButton:YES offset:-100];
        }
        else {
            [self showGotoTopButton:NO];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.tableView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

#pragma mark - RefreshTableViewDelegate
-(void) refreshData
{
    manualLoading = YES;
    [self requestHomeInfo];
}

-(void) loadMoreData
{

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
        case kReqestType_Home:
        {
            if (result.resultCode == 0) {
                if (manualLoading) {
                    [self.tableView doneLoadingRefreshData];
                    manualLoading = NO;
                }
                
                //刷新数据
                self.arrayAds = [result.data objectForKey:KJsonElement_Ads];
                self.arraySecKill = [result.data objectForKey:KJsonElement_Seckills];
                self.arrayCommond = [result.data objectForKey:KJsonElement_Commond_goods];
                self.arrayNews = [result.data objectForKey:KJsonElement_New_goods];
                
                if (self.arrayAds.count != 0) {
                    
                    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
                    for (int i = 0; i < self.arrayAds.count; i++) {
                        Ads *banner = [self.arrayAds objectAtIndex:i];
                        [array addObject: banner.picAddr];
                    }
                    
                    [self.bannerView loadImagesUrl:array];
                    [self.bannerView addTimer];
                }
                
                [self.tableView reloadData];
                
                //{{20150123 tianbo 解决ios7 autolayout scroview 不能滚动问题
                if (ISIOS8BEFORE) {
                    [self.bannerView refreshContentSize];
                }
                //}}
                
                //保存首页数据
                if (!self.arrayAds) self.arrayAds = [NSMutableArray new];
                if (!self.arrayNews) self.arrayNews = [NSMutableArray new];
                if (!self.arrayCommond) self.arrayCommond = [NSMutableArray new];
                if (!self.arraySecKill) self.arraySecKill = [NSDictionary new];
                NSDictionary *dict = @{@"Ads":self.arrayAds,
                                       @"News":self.arrayNews,
                                       @"Commonds":self.arrayCommond,
                                       @"Seckills":self.arraySecKill,};
                [[HomeInfoCache sharedInstance] setHomeInfo:dict];
            }
            else {
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
    DBG_MSG(@"enter");
    [super httpRequestFailed:notification];
    
    if (manualLoading) {
        [self.tableView doneLoadingRefreshData];
        manualLoading = NO;
    }
    
    ResultDataModel *result = notification.object;
    if (!result) {
        return;
    }
    
    
    switch (result.requestType) {
        case KReqestType_Index:
        {

        }
            break;
        default:
            break;
    }
    
}


@end
