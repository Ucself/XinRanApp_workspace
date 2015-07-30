

#import "DetailViewController.h"
#import "ProductListViewController.h"
#import "SelectStoreViewController.h"
#import "ConfirmOrderViewController.h"
#import "MeLoginViewController.h"

//#import "TimerView.h"
#import <XRUIView/TimerView.h>
//#import "ImagePreView.h"
#import <XRUIView/ImagePreView.h>
//#import "UILineLabel.h"
#import <XRUIView/UILineLabel.h>

#import "Product.h"
#import "Whouse.h"
#import "User.h"

@interface DetailViewController ()
{
    BOOL isLoadingFinished;
    UIActivityIndicatorView *indicatorView;
    
    CGSize oriContentSize;
    
    NSInteger curReminds;  //当前显示的库存
    
    //倒计时结束标记
    BOOL timeOver;
    //保留状态
    int prevStatus;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelNum;
@property (weak, nonatomic) IBOutlet UILabel *labelState;
@property (weak, nonatomic) IBOutlet UILabel *labelActivity;
@property (weak, nonatomic) IBOutlet UIView *viewActivity;
@property (weak, nonatomic) IBOutlet UILabel *labelRemainds;
@property (weak, nonatomic) IBOutlet UILineLabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelPriceActivity;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectStore;
@property (weak, nonatomic) IBOutlet UILabel *labelStoreAddr;
@property (weak, nonatomic) IBOutlet UILabel *labelService;

@property (weak, nonatomic) IBOutlet UILabel *toplabelPreice;
@property (weak, nonatomic) IBOutlet UILineLabel *toplabelPriceOld;
@property (weak, nonatomic) IBOutlet UILabel *toplabelSaled;

@property (weak, nonatomic) IBOutlet UIButton *btnNumSub;
@property (weak, nonatomic) IBOutlet UIButton *btnNumAdd;
@property (weak, nonatomic) IBOutlet UITextField *textNum;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *btnTake;

@property (weak, nonatomic) IBOutlet UIView *timerContainer;
@property (weak, nonatomic) IBOutlet UIView *storeContainer;

@property (weak, nonatomic) IBOutlet TimerView *timerView;
@property (weak, nonatomic) IBOutlet UIView *picView;

@property (weak, nonatomic) IBOutlet UIView *gradeView;
@property (weak, nonatomic) IBOutlet UIImageView *gradeImageView;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) BannerView *bannerView;
@property (strong, nonatomic) Product *product;
@property (strong, nonatomic) Whouse *whouse;


@end


@implementation DetailViewController

-(void)dealloc
{
    self.bannerView = nil;
    self.scrollView.delegate = nil;
    self.webView.delegate = nil;
    [self.timerView stop];
}

-(void)setupNavigationBar
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbktrans"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    
    UIImage *image = [UIImage imageNamed:@"btn_back-1"];
    CGRect buttonFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidLoad {
    
    isShowRequestPrompt = YES;
    
    [super viewDidLoad];
    [self initUI];
    //等待加载数据
    [self startWait];
//    
//    if ([[EnvPreferences sharedInstance] getToken]) {
//        NSArray *array = [[EnvPreferences sharedInstance] getUserInfo].arUserWhouses;
//        if (array && array.count!=0) {
//            self.whouse = [array objectAtIndex:0];
//        }
//    }
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbktrans"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavigationBar];
    
    
    //无需等待, 自动刷新
    [self reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbktrans"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    [self.bannerView refreshContentSize];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLayoutSubviews
{
    //保存scrollview原始contentSize
    if (CGSizeEqualToSize(oriContentSize, CGSizeZero)) {
        oriContentSize = self.scrollView.contentSize;
    }
}

-(void) initUI
{
    self.scrollView.hidden = YES;
    self.webView.hidden = YES;
    self.webView.scrollView.delegate = self;
    [self.webView setScalesPageToFit:NO];
    //[self.webView setScalesPageToFit:YES];
    
    self.timerView.delegate = self;
    
    int width = self.view.frame.size.width;
    _bannerView = [[BannerView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    self.bannerView.delegate = self;
    self.bannerView.placeholderImage = @"icon_defaut_large";
    //self.bannerView.imageMode = UIViewContentModeScaleAspectFill;
    [self.picView addSubview:self.bannerView];
    
    //int height = self.scrollView.frame.size.height;
    //self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width,  height+ 100.f);
    
    self.scrollView.alwaysBounceVertical = YES;
    
    [self addGotoTopButton:self.bottomView];
}

- (void)reloadData
{
    DBG_MSG(@"enter");
    if (self.dId) {   //活动商品
        [[NetInterfaceManager sharedInstance] getProductDetail:nil did:self.dId];
        //[self startWait];
    }
    else {     //常规商品
        [[NetInterfaceManager sharedInstance] goods:self.Id];
        //[self startWait];
    }
}

#pragma mark-
- (void)resetUIData
{
    Product *pdt = self.product;
    [self.bannerView loadImagesUrl:pdt.arImages];
    
    //{{20150123 tianbo 解决ios7 autolayout scroview 不能滚动问题
    if (ISIOS8BEFORE) {
        [self.bannerView refreshContentSize];
        [self.bannerView layoutIfNeeded];
    }
    //}}
    
    self.labelTitle.text = pdt.title;
    self.labelActivity.text = pdt.desc;
    self.labelNum.text = [NSString stringWithFormat:@"%d人已领取", pdt.sale];
    self.labelState.text = [NSString stringWithFormat:@"状态: %d", pdt.state];
    self.labelPriceActivity.text = [NSString stringWithFormat:@"¥%0.2f", pdt.price];
    self.labelPrice.text = [NSString stringWithFormat:@"¥%0.2f", pdt.priceOld];
    //self.labelService.text = @"在签收商品7天以内，如您收到的商品有质量问题，或是与描述不一致，或是付款后没有收到货物等问题，可以对该交易发起退换货。";
    
    self.toplabelPreice.text = [NSString stringWithFormat:@"¥%0.2f", pdt.price];
    self.toplabelPriceOld.text = [NSString stringWithFormat:@"¥%0.2f", pdt.priceOld];
    self.toplabelSaled.text = [NSString stringWithFormat:@"%d人购买", pdt.sale];
    
    //{{动态设置高宽
    if (!pdt.desc || pdt.desc.length == 0) {
        [self.viewActivity remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0).priorityHigh();
        }];
        
        CGSize size = self.scrollView.contentSize;
        size.height -= 50;
        self.scrollView.contentSize = size;
        oriContentSize = size;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:self.labelPriceActivity.font,
                                 NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize = [self.labelPriceActivity.text boundingRectWithSize:CGSizeMake(200, 30)
                                                    options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                 attributes:attributes
                                                    context:nil].size;
    //底部价格
    [self.labelPriceActivity remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(labelSize.width + 5).priorityHigh();
    }];
    //顶部价格
    [self.toplabelPreice remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(labelSize.width + 20).priorityHigh();
    }];
    //}}
    
    if (self.dId) {    //活动商品
        [self.btnNumAdd setEnabled:NO];
        [self.btnNumSub setEnabled:NO];
        
        
        switch (pdt.state) {
            case ProductStatus_End:
            {
                [self showEndView:YES];
                
                [self.btnTake setEnabled:NO];
                [self.btnTake setTitle:@"抢购已结束" forState:UIControlStateNormal];
            }
                break;
            case ProductStatus_Start:
            {
                DBG_MSG(@"ProductStatus_Start");
                [self showEndView:NO];
                self.labelState.text = @"距离结束:";
                [self.timerView setTotalSeconds:pdt.seconds];
                [self.timerView start];
                
                [self.btnTake setEnabled:YES];
                [self.btnTake setTitle:@"立即抢购" forState:UIControlStateNormal];
            }
                break;
            case ProductStatus_UnStart:
            {
                DBG_MSG(@"ProductStatus_UnStart");
                [self showEndView:NO];
                self.labelState.text = @"距离开始:";
                [self.timerView setTotalSeconds:pdt.seconds];
                [self.timerView start];
                
                [self.btnTake setEnabled:NO];
                [self.btnTake setTitle:@"即将开始" forState:UIControlStateNormal];
            }
                break;
            case ProductStatus_GrabEnd:
            {
                [self showEndView:YES];
                
                [self.btnTake setEnabled:NO];
                [self.btnTake setTitle:@"已经抢完" forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }
    }
    else {    //常规商品
        [self.btnNumAdd setEnabled:YES];
        [self.btnNumSub setEnabled:YES];
        self.timerContainer.hidden = YES;
        self.labelPrice.hidden = YES;
        self.toplabelPriceOld.hidden = YES;
        [self.timerContainer remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0);
        }];
        
        [self.btnTake setTitle:@"立即抢购" forState:UIControlStateNormal];
    }
    
    [self resetUIWhouseData];
   
}

-(void)resetUIWhouseData
{
    Product *pdt = self.product;
    if (!pdt.arrayWhouses || pdt.arrayWhouses.count == 0) {
        [self.btnSelectStore setEnabled:NO];
        //self.labelRemainds.hidden = YES;
        self.labelRemainds.text = [NSString stringWithFormat:@"库存:%ld件", (long)pdt.remaind];
        curReminds = pdt.remaind;
    }
    else {
        
        [self.btnSelectStore setEnabled:YES];
        if (self.whouse) {   //如果有选中的店铺
            self.labelRemainds.hidden = NO;
            self.labelRemainds.text = [NSString stringWithFormat:@"库存:%d件", self.whouse.remainds];
            self.labelStoreAddr.text = self.whouse.name;
            
            curReminds = self.whouse.remainds;
            if (curReminds == 0) {
                [self.btnTake setEnabled:NO];
            }
            else {
                if (self.dId) {    //活动商品
                    if (pdt.state == ProductStatus_Start)
                        [self.btnTake setEnabled:YES];
                }
                else{   //常规商品
                    [self.btnTake setEnabled:YES];
                }
                
            }
        }
        else {
            self.labelRemainds.text = [NSString stringWithFormat:@"库存:%ld件", pdt.remaind];//[NSString stringWithFormat:@"总库存:%d件", pdt.remaind];
            curReminds = pdt.remaind;
            User *user = [[EnvPreferences sharedInstance] getUserInfo];
            if ([[EnvPreferences sharedInstance] getToken] && (user.arUserWhouses && user.arUserWhouses.count != 0)) {
                //如果用户已登录,并且所选的默认店铺没有参加活动
                self.labelStoreAddr.text = @"您选择的店铺未参加活动";
            }
        }
        
        if (self.textNum.text.intValue  > curReminds) {
             self.textNum.text = @"1";
        }
    }
}

-(void)getWhouseInfo:(WhouseProduct*)info
{
    if (!info) {
        return;
    }
    
    NSArray *arWhouses = [Whouse modelList];
    for (Whouse *whouse in arWhouses) {
        if ([whouse.Id isEqualToString:info.Id]) {
            DBG_MSG(@"id=%@, name=%@", whouse.Id, whouse.name);
            self.whouse = whouse;
            self.whouse.remainds = info.remainds;
            
        }
    }
}

//秒杀倒计时结束
-(void)timerViewFinished
{
    DBG_MSG(@"ender");
    //秒杀结束后清除did, 重新请求获取常规商品详情
    if (self.product.state == ProductStatus_Start ||
        self.product.state == ProductStatus_GrabEnd) {
        self.dId = nil;
    }
    
    //解决与后台时间不同步导致多次刷新问题
    timeOver = YES;
    prevStatus = self.product.state;
    
    [self startWait];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self reloadData];
    });
    
}

- (void)showEndView:(BOOL)show
{
    self.timerContainer.hidden = show;
    [self.timerContainer remakeConstraints:^(MASConstraintMaker *make) {
        if (!show) {
            make.height.equalTo(50);
        }
        else {
            make.height.equalTo(0);
        }
        
    }];
    
    if (show) {
        UIImageView *imageView = [[UIImageView alloc] init];
        //imageView.contentMode = UIViewContentModeCenter;
        imageView.tag = 9100;
        if (self.product.state == ProductStatus_End) {  //活动结束
            imageView.image = [UIImage imageNamed:@"icon_actend"];
        }
        else if (self.product.state == ProductStatus_GrabEnd) { //已抢完
            imageView.image = [UIImage imageNamed:@"icon_grabend"];
        }
        
        [self.bannerView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bannerView);
            make.centerY.equalTo(self.bannerView);
            make.height.equalTo(80);
            make.width.equalTo(80);
        }];
    }
    else {
        UIView *view = [self.bannerView viewWithTag:9100];
        if (view) {
            [view removeFromSuperview];
        }
    }
    
    [self.view updateConstraintsIfNeeded];
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BaseUIViewController* controller = segue.destinationViewController;
    
    if ([controller isKindOfClass:[ConfirmOrderViewController class]]) {
        //传递到详情页
        ConfirmOrderViewController *c = (ConfirmOrderViewController*)controller;
        c.product = self.product;
        c.whouse = self.whouse;
        c.product.image= self.imageUrl;
        c.buyNum = [self.textNum.text intValue];
    }
    else if ([controller isKindOfClass:[SelectStoreViewController class]]) {
        SelectStoreViewController *c = (SelectStoreViewController*)controller;
        c.delegate = self;
        c.arRelationStoreIds = self.product.arrayWhouses;
        c.isShowRemainds = YES;
    }
}

//选择店铺页面返回数据
-(void)controllerBackWithData:(id)data
{
    Whouse *whouse = (Whouse*)data;
    self.whouse = whouse;

    [self resetUIWhouseData];
}

#pragma mark- button actions
-(void)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSelectStore:(id)sender {
    [self performSegueWithIdentifier:@"toStoreList" sender:self];
}

- (IBAction)btnBuyClick:(id)sender {
//    if (!self.whouse) {
//        [self showTipsView:@"请选择店铺!"];
//        return;
//    }
    
    if (self.product.remaind <= 0) {//if (self.whouse.remainds <= 0) {
        [self showTipsView:@"库存不足!"];
        return;
    }
    
    NSString *token = [[EnvPreferences sharedInstance] getToken];
    if (!token || token.length == 0){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        MeLoginViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        login.bReturnToRoot = NO;
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    
//cell.gradeLabel.text = @"养生平民及以上";    User *user = [[EnvPreferences sharedInstance] getUserInfo];
//    if ([user.grades intValue] < self.product.limit_grades) {
//        [self showTipsView:@"您的会员等级不足!"];
//        return;
//    }
    
    [self performSegueWithIdentifier:@"toConfirm" sender:self];
}

- (IBAction)btnLoadMore:(id)sender {
    [self pulldownView];
}

- (IBAction)btnGotoTopClick:(id)sender {

    [UIView animateWithDuration:0.5 animations:^{
        [self pullupView];
        
    } completion:^(BOOL finished) {
    }];

}

- (IBAction)btnNumSub:(id)sender {
    int num = [self.textNum.text intValue];
    
    if (num > 1) {
        self.textNum.text = [NSString stringWithFormat:@"%d", --num];
    }
    if (num <= 1) {
        [self.btnNumSub setBackgroundImage:[UIImage imageNamed:@"btn_sub_d"] forState:UIControlStateNormal];
    }
    
    //图标更换回来
    if (num < 100) {
        [self.btnNumAdd setBackgroundImage:[UIImage imageNamed:@"btn_add_n"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)btnNumAdd:(id)sender {
    int num = [self.textNum.text intValue];
    //小雨当前库存可以添加
    if (num < curReminds) {
        self.textNum.text = [NSString stringWithFormat:@"%d", ++num];
    }
    //超出100提示
    if( num >= 100){
        if (num > 100) {
            //弹出框提示
            [self showTipsView:@"超过购买限额"];
        }
        num = 100;
        self.textNum.text = [NSString stringWithFormat:@"%d", num];
        //更换图片
        [self.btnNumAdd setBackgroundImage:[UIImage imageNamed:@"btn_add_d"] forState:UIControlStateNormal];
        
    }
    if (num > 1) {
        [self.btnNumSub setBackgroundImage:[UIImage imageNamed:@"btn_sub_n"] forState:UIControlStateNormal];
    }
}


#pragma mark- http request handler
-(void)httpRequestFinished:(NSNotification *)notification
{
    DBG_MSG(@"enter");
    if (!timeOver) {
        [self stopWait];
    }
    
    ResultDataModel *result = notification.object;
    if (!result) {
        DBG_MSG(@"http result is nil!");
        return;
    }
    
    switch (result.requestType) {
        case KReqestType_Gds:
        {
            if (result.resultCode == 0) {
                self.scrollView.hidden = NO;
                self.product = result.data;
                
                if (timeOver && self.product.state == prevStatus) {
                    [self reloadData];
                    return;
                }
                else {
                    timeOver = NO;
                }
                
                if (self.product.arrayWhouses.count > 0) {
                    for (WhouseProduct *p in self.product.arrayWhouses) {
                        if ([p.Id isEqualToString:self.whouse.Id]) {
                            [self getWhouseInfo:p];
                            break;
                        }
                    }
                }
            }
            else {
                [self showTipsView:@"产品详情获取失败!"];
                DBG_MSG(@"result.code=%d, result.desc=%@", result.resultCode, result.desc);
            }
            
            
            [self resetUIData];
            
            
        }
            break;
        case kreqestType_Goods:
        {
            if (result.resultCode == 0) {
                self.scrollView.hidden = NO;
                self.product = result.data;
                
                if (timeOver && self.product.state == prevStatus) {
                    [self reloadData];
                    return;
                }
                else {
                    timeOver = NO;
                }
                
                if (self.product.arrayWhouses.count > 0) {
                    for (WhouseProduct *p in self.product.arrayWhouses) {
                        if ([p.Id isEqualToString:self.whouse.Id]) {
                            [self getWhouseInfo:p];
                            break;
                        }
                    }
                }
            }
            else {
                [self showTipsView:@"产品详情获取失败!"];
                DBG_MSG(@"result.code=%d, result.desc=%@", result.resultCode, result.desc);
            }
            
            
            [self resetUIData];
        }
            
        default:
            break;
    }
}

-(void)httpRequestFailed:(NSNotification *)notification
{
    [super httpRequestFailed:notification];
}

#pragma mark- bannerview delegate
-(void)bannerViewWithIndex:(int)index
{
    ImagePreView *preview = [[ImagePreView alloc] initWithFrame:CGRectZero];
    preview.delegate = self;
    preview.tag = 111;
    UIView *supperView = [[UIApplication sharedApplication] keyWindow];
    [supperView addSubview:preview];
    
    [preview makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(supperView);
    }];
    
    [preview loadImages:self.product.arImages selectIndex:index];
}

-(void)imagePreViewClick
{
    UIView *view = [[[UIApplication sharedApplication] keyWindow] viewWithTag:111];
    if (view) {
        [view removeFromSuperview];
        view = nil;
    }
    
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //DBG_MSG(@"---y=%f", self.scrollView.contentOffset.y);
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //为加载更多时scrollview不回滚, 调整contentSize
    if (scrollView == self.scrollView) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, oriContentSize.height + 500);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView == self.scrollView) {
        int offset = oriContentSize.height - (self.scrollView.contentOffset.y + self.scrollView.bounds.size.height - self.scrollView.contentInset.bottom);

        //DBG_MSG(@"---y=%f", self.scrollView.contentOffset.y);
        if(self.scrollView.contentOffset.y > 0 && offset <= -90) {
            [self pulldownView];
        }
        
        //向上拉时还原contentSize
        if (self.scrollView.contentOffset.y > -64) {
            [UIView animateWithDuration:0.4 animations:^{
                self.scrollView.contentSize = oriContentSize;
            }];
        }
    }
    else if (scrollView == self.webView.scrollView) {
        int y = self.webView.scrollView.contentOffset.y;
        //DBG_MSG(@"******%d", y);
        if (y < -60) {
            [self pullupView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
}

//加载详情
- (void)pulldownView {
    //NSString *head = @"<meta name=\"viewport\" content=\"initial-scale=1.0, minimum-scale=0.1, maximum-scale=2.0, user-scalable=yes\">\n";
    NSString *url = self.product.body;
    if (!isLoadingFinished && (url && url.length != 0)) {
        [self.webView setScalesPageToFit:NO];
//        [self.webView loadHTMLString:url baseURL:nil];
        //加载本地文件
        NSString *path = [[NSBundle mainBundle] pathForResource:@"goodLazy" ofType:@"html"];
        NSURL* url = [NSURL fileURLWithPath:path];
        NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
        [self.webView loadRequest:request];
    }
    
    
    self.scrollView.alwaysBounceVertical = NO;
    CGRect rt = self.contentView.frame;
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets insets = self.scrollView.contentInset;
        insets.top = -rt.size.height-20;
        self.scrollView.contentInset = insets;
    }];
    
    [self showGotoTopButton:YES];
}

//返回到顶部
-(void)pullupView
{
    self.scrollView.alwaysBounceVertical = YES;
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets insets = self.scrollView.contentInset;
        insets.top = 0;
        self.scrollView.contentInset = insets;
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
    
    [indicatorView stopAnimating];
    [indicatorView removeFromSuperview];
    
    [self showGotoTopButton:NO];
}

#pragma mark- UIWebView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (!indicatorView) {
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.frame = CGRectMake((self.webView.frame.size.width-30)/2, (self.webView.frame.size.height-30)/2+64, 30, 30);
        indicatorView.backgroundColor = [UIColor clearColor];
        [indicatorView sizeToFit];
        indicatorView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                          UIViewAutoresizingFlexibleRightMargin |
                                          UIViewAutoresizingFlexibleTopMargin |
                                          UIViewAutoresizingFlexibleBottomMargin);
    }
    
    [self.view addSubview:indicatorView];
    [indicatorView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.webView.hidden = NO;
    //若已经加载完成，则显示webView并return
    if(isLoadingFinished)
    {
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
//        self.webView.hidden = NO;
        return;
    }
    //切分获取图片路径
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    for (NSString *imagePath in [self.product.body componentsSeparatedByString:@"\""]) {
        if([imagePath rangeOfString:@"http://"].length > 0){
            [mutableArray addObject:imagePath];
        }
    }
    
    for (NSString *tempUrl in mutableArray) {
        [self.webView stringByEvaluatingJavaScriptFromString:[@"addImageInfor('" stringByAppendingFormat:@"%@%@", tempUrl, @"')"]];
    }
    //初始化懒加载
    [self.webView stringByEvaluatingJavaScriptFromString:@"LazyLoad.init()"];
    //停止加载轻视图
    [indicatorView stopAnimating];
    //设置为已经加载完成
    isLoadingFinished = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DBG_MSG(@"详情加载失败!");
    [indicatorView stopAnimating];
    [indicatorView removeFromSuperview];
}

//自适应webview的宽度
- (NSString *)htmlAdjustWithPageWidth:(CGFloat )pageWidth
                                 html:(NSString *)html
                              webView:(UIWebView *)webView
{
    //计算要缩放的比例
    CGFloat initialScale = (webView.frame.size.width-3)/pageWidth;
    //将</head>替换为meta+head
    NSString *stringHead = [NSString stringWithFormat:@"<meta name=\"viewport\" content=\"width=device-width, initial-scale=%0.2f, minimum-scale=0.1, maximum-scale=2.0, user-scalable=yes\">\n", initialScale];

    NSString *str = [NSString stringWithFormat:@"%@%@", stringHead, html];
    return str;
}
@end

