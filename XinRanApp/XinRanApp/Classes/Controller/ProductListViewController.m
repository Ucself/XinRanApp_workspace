	//
//  ProductListViewController.m
//  XinRanApp
//
//  Created by tianbo on 14-12-11.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//


#import "ProductListViewController.h"
#import "ProductTableViewCell.h"
#import "DetailViewController.h"
#import "SelectStoreViewController.h"

#import <XRCommon/DateUtils.h>
//#import "SegmentedUIView.h"
#import <XRUIView/SegmentedUIView.h>
//#import "RefreshTableView.h"
#import <XRUIView/RefreshTableView.h>
//#import "UIbutton+ImageLabel.h"
#import <XRUIView/UIbutton+ImageLabel.h>
//#import "PopoverMenu.h"
#import <XRUIView/PopoverMenu.h>
#import <XRUIView/FilterView.h>
#import "BrandSelectView.h"


#import "GoodClass.h"
#import "User.h"
#import "Brand.h"
#import "Product.h"

#define NavBarFrame self.navigationController.navigationBar.frame
#define TopViewHeight 60
#define NavBarHeight 44

#define    SortKey_Date      @"startDate"
#define    SortKey_Sale      @"sale"
#define    SortKeyT_Price    @"priceActivity"
#define    SortKey_Seconds   @"seconds"

typedef NS_ENUM(int , SortType)
{
    SortType_Common = 0,        //综合
    SortType_Price_Asce = 1,    //价格降序
    SortType_Price_Desc = 2,    //价格升序
    SortType_Time_Asce = 3,     //时间降序
    SortType_Time_Desc = 4,     //时间升序
    SortType_Sale_Asce = 5,     //人气降序
    SortType_Sale_Desc = 6,     //人气升序
};


@interface ProductListViewController ()<UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate,SegmentedUIViewDelegate, FilterViewDelegate>
{
    //右侧筛选分类
    BrandSelectView *brandSelectView;
    
    BOOL manualLoading;
    BOOL refresh;
    
    //页数
    int pageCount;
    int pageIndex;
    
    //当前排序类型
    int curSortType;
    
    
    //筛选view
    BOOL filterViewIsShow;
    int selectedBrandIndex;
    //筛选的添加数组
    NSArray *goodsArray;
    //NSArray *brandArray;
    //滑动栏目
    SegmentedUIView *segmentedUIView;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet RefreshTableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *segmentedContainerView;


@property (nonatomic, strong)NSMutableArray *arrayProducts;
@property (nonatomic, strong)NSArray *arrayBrands;

@property (nonatomic, strong) PopoverMenu *popMenu;
@property (nonatomic, strong) FilterView *filterView;

//选中的品牌id
@property (nonatomic,strong) NSString *stringSelectedBrand;

//排序类型
@property (nonatomic, assign) SortType sortType;
@property (nonatomic, strong) NSString *curBrandId;  //当前品牌
@end

@implementation ProductListViewController

- (void)initUI {

    //设置视频跟随
    [self followRollingScrollView:self.tableView];
    
//    [self setupNavBar];
    [self setupSegmented];

    self.tableView.refreshDelegate = self;
    [self.tableView addHeaderView];
    //[self.tableView addFootView];
    
    [self addGotoTopButton:nil];
}

- (void)viewDidLoad {
    
    isShowRequestPrompt = YES;
    
    [super viewDidLoad];
    
    [self initUI];
    
    curSortType = SortType_Common;
    self.curBrandId = @"";
    pageCount = 1;
    pageIndex = 1;
    //设置当前选中为-1
    selectedBrandIndex = -1;
    //获取数据
    [self getListData:self.cId page:pageIndex brandId:self.curBrandId sort:curSortType showIndicator:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbkwhite"] forBarMetrics:UIBarMetricsDefault];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.topView.hidden = NO;

}

-(void)dealloc{
    //释放掉加载在UIWindow上的View
    brandSelectView = nil;
}

-(void)getListData:(NSString*)cId page:(int)page brandId:(NSString*)brandId sort:(int)sortType showIndicator:(BOOL)showIndicator
{
    [[NetInterfaceManager sharedInstance] goodsByClass:cId page:page sort:sortType brandId:brandId];
    
    if (showIndicator) {
        [self startWait];
    }
}

-(void)setupNavBar
{
    self.navigationItem.title = self.title;
    
//    UIButton *btnR = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btnR setFrame:CGRectMake(0, 0, 50, 40)];
//    [btnR setImage:[UIImage imageNamed:@"tabbar_category_h"] withTitle:@"筛选" forState:UIControlStateNormal];
//    [btnR addTarget:self action:@selector(btnSelecetBrand:) forControlEvents:UIControlEventTouchUpInside];
//    [btnR setTintColor:UIColor_DefGreen];
//    //[btnR setBackgroundColor:[UIColor yellowColor]];
//
//    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:btnR];
//    self.navigationItem.rightBarButtonItem = barItem;
}
//加载数据查询条件选择Segmented分段
-(void)setupSegmented {
    
    segmentedUIView = [[SegmentedUIView alloc] init];
    segmentedUIView.delegate = self;
    [self.segmentedContainerView addSubview:segmentedUIView];
    
    // tell constraints they need updating
    [self.segmentedContainerView setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self.segmentedContainerView updateConstraintsIfNeeded];
    
    [self.segmentedContainerView layoutIfNeeded];
    
//    [segmentedUIView setFrame:self.segmentedContainerView.bounds];
    [segmentedUIView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.segmentedContainerView);
    }];
    //设置约束
    [segmentedUIView initInterface];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BaseUIViewController* controller = segue.destinationViewController;

    if ([controller isKindOfClass:[DetailViewController class]]) {
        //传递id和did到详情页
        Product *pdt = (Product*)sender;
        DetailViewController *c = (DetailViewController*)controller;
        c.Id = pdt.Id;
        //c.dId = pdt.did;
        c.imageUrl = pdt.image;
    }
//    else if ([controller isKindOfClass:[SelectStoreViewController class]]) {
//        SelectStoreViewController *c = (SelectStoreViewController*)controller;
//        c.delegate = self;
//        c.arRelationStoreIds = self.arWhouses;
//        c.isShowRemainds = NO;
//    }
}

-(void)controllerBackWithData:(id)data
{
//    Whouse *whouse = (Whouse*)data;
//    
//    self.curWhouse = whouse;
//    self.labelWhouse.text = whouse.name;
//    self.isRequestAll = NO;
//    [self getListData:whouse.Id];
}
//动画关闭Brand
-(void) closeBrand:(id)sender{
    [UIView animateWithDuration:0.2 animations:^{
        [brandSelectView setFrame:CGRectMake(deviceWidth, 0, deviceWidth, deviceHeight)];
    }];
}
//动画打开Brand
-(void) openBrand:(id)sender{
    [UIView animateWithDuration:0.2 animations:^{
        [brandSelectView setFrame:CGRectMake(0, 0, deviceWidth, deviceHeight)];
    }];
}


#pragma mark- button click action
//-(void)btnSelecetStore:(id)sender
//{
//    //选择店铺
//    UIButton *btn = (UIButton*)sender;
//    
//    if (!self.popMenu) {
//        self.popMenu = [PopoverMenu new];
//    }
//    
//    CGPoint pt = CGPointMake(CGRectGetMidX(btn.frame), CGRectGetMaxY(btn.frame) + 25);
//    [self.popMenu showAtPoint:pt inView:self.view items:@[@"全部店铺", @"其它店铺"]];
//    
//    __weak __typeof(self)weakSelf = self;
//    self.popMenu.selectHandler = ^(int index){
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        
//        if (index == 0) {
//            strongSelf.labelWhouse.text = @"全部店铺";
//            strongSelf.isRequestAll = YES;
//            [strongSelf getListData:@""];
//        }
//        else if (index == 1){
//            SelectStoreViewController *selectStore = [[strongSelf storyboard] instantiateViewControllerWithIdentifier:@"SelectStoreViewController"];
//            selectStore.delegate = strongSelf;
//            
//            if (strongSelf.curWhouse) {
//                Areas *area = [Areas getArearWithId:strongSelf.curWhouse.areaId];
//                
//                selectStore.selArea = area;
//            }
//            else if (!strongSelf.arWhouses || strongSelf.arWhouses.count == 0) {
//                [strongSelf showTipsView:@"当前没有可用店铺"];
//                return;
//            }
//            
//            [strongSelf.navigationController pushViewController:selectStore animated:YES];
//        }
//        
//    };
//    
//}

-(void) btnSelecetBrand:(id)sender
{
    UIApplication *app = [UIApplication sharedApplication];
    //获取UIWindows
    UIWindow *mainWindow;
    if ([app.delegate respondsToSelector:@selector(window)]) {
        mainWindow = [app.delegate window];
    }
    else{
        mainWindow = [app keyWindow];
    }
    
//    NSMutableArray *arraySelect = (NSMutableArray *)[Brand modelList];
    NSMutableArray *arraySelect = [[NSMutableArray alloc] init];
    //添加全部第一个选项
    Brand *firstBrand = [[Brand alloc] initWithDictionary:@{KJsonElement_ID:@"",KJsonElement_Name:@"全部品牌",KJsonElement_BrandsDesc:@""}];
    [arraySelect addObject:firstBrand];
    //添加数据
    for (Brand *tempBrand in _arrayBrands) {
        [arraySelect addObject:tempBrand];
    }
    if (!brandSelectView) {
        brandSelectView = [[BrandSelectView alloc] initWithData:CGRectMake(deviceWidth, 0, deviceWidth, deviceHeight) dataSource:(NSMutableArray *)arraySelect];
        //添加到UIWindow上
        [mainWindow addSubview:brandSelectView];
        //第一次设置为默认全部
        self.stringSelectedBrand = @"";
    }
    
    //设置选中的品牌
    brandSelectView.stringSelectId = _stringSelectedBrand;
    [brandSelectView.tableView reloadData];
    //注册传出来的block 目前用不着
    __weak __typeof(self)weakSelf = self;
    int page = pageIndex = 1;
    brandSelectView.viewSelectedBrandHandler= ^(NSString *string){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.stringSelectedBrand = string;
        //更新数据
        strongSelf.curBrandId = string;
        [strongSelf getListData:strongSelf.cId page:page brandId:string sort:SortType_Common showIndicator:YES];
    };
    
    [self openBrand:nil];
}

- (IBAction)btnGotoTopClick:(id)sender {
    //显示导航栏
    [self showNaigationBar:YES];
    [UIView animateWithDuration:0.5 animations:^{
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 0.01, 0.01) animated:YES];
    }];
}

#pragma mark- UITableView Delegate mothed
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //默认使用1个
    return 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //如果没有筛选品牌不显示
    if (selectedBrandIndex == -1) {
        return 0;
    }
    return 36.f;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //如果没有筛选品牌不显示
    if (selectedBrandIndex == -1) {
        return [UIView new];
    }
    //标题整体的UIView
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth, 36.f)];
    [customView setBackgroundColor:[UIColor whiteColor]];
    //右边按钮
    UIButton *clearButton = [[UIButton alloc] init];
    [clearButton setTitleColor:UIColorFromRGB(0x44A081) forState:UIControlStateNormal];
    [clearButton setTitle:@"清除条件" forState:UIControlStateNormal];
    [clearButton setBackgroundImage:[UIImage imageNamed:@"btn_registerbtn_n"] forState:UIControlStateNormal];
    //添加点击事件
    [clearButton addTarget:self action:@selector(clearSelectedFilter:) forControlEvents:UIControlEventTouchUpInside];
    [clearButton setFont:[UIFont systemFontOfSize:14.f]];
    [customView addSubview:clearButton];
    [clearButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(customView.right).offset(-10);
        make.centerY.equalTo(customView.centerY);
        make.height.equalTo(25);
        make.width.equalTo(70);
    }];
    //品牌名称
    UILabel *brandNameLable = [[UILabel alloc] init];
    [brandNameLable setTextColor:UIColorFromRGB(0xABABAB)];
    [brandNameLable setTextAlignment:NSTextAlignmentLeft];
    //设置选中的名称
    Brand *tempBrand = self.arrayBrands[selectedBrandIndex];
    [brandNameLable setText:tempBrand.name];
    [customView addSubview:brandNameLable];
    [brandNameLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(customView.left).offset(20);
        make.centerY.equalTo(customView.centerY);
        make.height.equalTo(25);
        make.width.equalTo(85);
    }];
    //分脚线条
//    UIView *view = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    UIView *tempView =  [[UIView alloc] init];
    tempView.backgroundColor = UIColorFromRGB(0xdbdbdb);
    [customView addSubview:tempView];
    [tempView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(customView.bottom);
        make.left.equalTo(customView.left);
        make.height.equalTo(1);
        make.right.equalTo(customView.right);
    }];
    
    return customView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayProducts.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CellProduct";
    ProdcutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductTableViewCell" owner:self options:0] firstObject];
    }
    
    if (indexPath.row >= self.arrayProducts.count) {
        return cell;
    }
 
    Product *product = [self.arrayProducts objectAtIndex:indexPath.row];
    [cell setImageUrl:product.image];
    cell.titleLabel.text = product.title;
    cell.priceLabel.text = [NSString stringWithFormat:@"%0.2f", product.price];
    
    //常规商品不显示原价?????
    cell.oriPriceLabel.text = [NSString stringWithFormat:@"¥%0.2f", product.priceOld];
    cell.buyNumLabel.text = [NSString stringWithFormat:@"%d人已购", product.sale];
//    
//    NSString *strStatus = @"";
//    switch (product.state) {
//        case ProductStatus_End:
//        {
//            strStatus = @"已结束";
//        }
//            break;
//        case ProductStatus_Start:
//        {
//            strStatus = @"剩余时间:";
//        }
//            break;
//        case ProductStatus_UnStart:
//        {
//            strStatus = @"距开始:";
//        }
//            break;
//        case ProductStatus_GrabEnd:
//        {
//            strStatus = @"剩余时间:";
//        }
//            break;
//            
//        default:
//            break;
//    }
//
//    cell.stateLabel.text = strStatus;
//    if (product.state == ProductStatus_End) {
//        cell.timerView.hidden = YES;
//    }
//    else {
//        cell.timerView.hidden = NO;
//        [cell setTimeInterval:product.seconds];
//    }
    
//    switch (product.limit_grades) {
//        case ProductLimitGrade_1:
//        {
//            cell.gradeLabel.text = @"养生平民及以上";
//        }
//            break;
//        case ProductLimitGrade_2:
//        {
//            cell.gradeLabel.text = @"养生专家及以上";
//        }
//            break;
//        case ProductLimitGrade_3:
//        {
//            cell.gradeView.hidden = YES;
//        }
//            break;
//        case ProductLimitGrade_4:
//        {
//            cell.gradeView.hidden = YES;
//        }
//            break;
//            
//        default:
//            cell.gradeView.hidden = YES;
//            break;
//    }

    
//    CGSize size = [strStatus sizeWithAttributes:@{NSFontAttributeName:cell.stateLabel.font}];
//    CGRect rt = cell.stateLabel.frame;
//    rt.size.width = 200;//size.width;
//    cell.stateLabel.frame = rt;
//    [cell.stateLabel updateConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@200);
//    }];
//    [cell setNeedsDisplay];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    Product *product = [self.arrayProducts objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ToDetailInfo" sender:product];
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
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
    //获取数据
    [self getListData:self.cId page:pageIndex brandId:self.curBrandId sort:curSortType showIndicator:NO];
}

-(void) loadMoreData
{
    if (pageCount > 1 && pageCount > pageIndex) {
        manualLoading = YES;
        refresh = NO;
        
        pageIndex++;
        [self getListData:self.cId page:pageIndex brandId:self.curBrandId sort:curSortType showIndicator:NO];
    }
}

#pragma mark - SegmentedUIViewDelegate

- (NSInteger) numberOfData{
    
    return 5;
}
//每个单元的字符串名称
- (NSString *) stringForIndex:(NSInteger) index{

    switch (index) {
        case 0:
            return @"综合";
        case 1:
            return @"人气";
        case 2:
            return @"价格";
        case 3:
            return @"最新";
        case 4:
            return @"筛选";
        default:
            return @"为空";
    }
}
//是否有排序图标,默认不显示
- (UIImage*)segmentedUIView:(NSInteger) indexPath{
    
    switch (indexPath) {
        case 0:
            return nil;
        case 1:
            return nil;
        case 2:
            return [UIImage imageNamed:@"icon_uparrow"];
        case 3:
            return nil;
        case 4:
            return [UIImage imageNamed:@"icon_updown"];
        default:
            return nil;
    }
}

//选中每一个的时候激活的方法
- (void)segmentedUIView:(SegmentedUIView *)segmentedUIView didSelectRowAtIndexPath:(NSInteger) indexPath sortType:(SegmentedSortType)sortType{
    pageIndex = 1;
    NSString  *brandName = @"";
    if (selectedBrandIndex !=-1) {
        //有选择
        Brand *tempBrand = self.arrayBrands[selectedBrandIndex];
        brandName = tempBrand.Id;
    }
    
    switch (indexPath) {
        case 0:
            
            [self getListData:self.cId page:pageIndex brandId:brandName sort:SortType_Common showIndicator:YES];
            curSortType =SortType_Common;
            [self removeFilterView];
            break;
        case 1:
            [self getListData:self.cId page:pageIndex brandId:brandName sort:SortType_Sale_Desc showIndicator:YES];
            curSortType = SortType_Sale_Desc;
            [self removeFilterView];
            break;
        case 2:
            if (sortType == SegmentedSortTypeUp) {
                [self getListData:self.cId page:pageIndex brandId:brandName sort:SortType_Price_Desc showIndicator:YES];
                curSortType = SortType_Price_Desc;
            }
            else{
                [self getListData:self.cId page:pageIndex brandId:brandName sort:SortType_Price_Asce showIndicator:YES];
                curSortType = SortType_Price_Asce;
            }
            [self removeFilterView];
            break;
        case 3:
            [self getListData:self.cId page:pageIndex brandId:brandName sort:SortType_Time_Desc showIndicator:YES];
            curSortType = SortType_Time_Desc;
            [self removeFilterView];
            break;
        case 4:
            filterViewIsShow = !filterViewIsShow;
            if (filterViewIsShow) {
                [self showFilterView];
            }
            else {
                [self removeFilterView];
            }
            
            break;

        default:
            break;
    }
    
}
//选中的排序类型
- (void)segmentedUIView:(SegmentedUIView *)segmentedUIView didSelectSortAtIndexPath:(NSInteger) indexPath sortType:(SegmentedSortType)sortType{
    
};

//排序方法
-(void)sortWithKey:(NSString*)key asc:(BOOL)asc
{
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:key ascending:asc];
    
    if ([key isEqual:SortKey_Date]) {  //日期字符串比较处理
        sortDesc = [[NSSortDescriptor alloc] initWithKey:key ascending:asc comparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *strDate1 = obj1;
            NSString *strDate2 = obj2;
            
            NSDate *date1 = [DateUtils stringToDateRT:strDate1];
            NSDate *date2 = [DateUtils stringToDateRT:strDate2];
            
            if ([date1 compare:date2] == NSOrderedDescending) {
                
                return asc ? NSOrderedAscending : NSOrderedDescending;
            }
            else if ([date1 compare:date2] == NSOrderedAscending){
                
                return asc ? NSOrderedDescending : NSOrderedAscending;
            }
            
            return NSOrderedSame;
        }];
    }
    
    NSArray *sortDescriptors =[NSArray arrayWithObjects:sortDesc, nil];
    self.arrayProducts = [NSMutableArray arrayWithArray: [self.arrayProducts sortedArrayUsingDescriptors:sortDescriptors]];
    [self.tableView reloadData];
}


#pragma mark- filter view mothed
-(FilterView*)getFilterView;
{
    //获取商品分类
    goodsArray = [GoodClass getGoodClassWithParentId:@""];
    //获取数组
    NSMutableArray *stringArrayGoods = [[NSMutableArray alloc] init];
    for (GoodClass *item in goodsArray) {
        [stringArrayGoods addObject:item.name];
    }
    //品牌信息
    NSMutableArray *stringArrayBrand = [[NSMutableArray alloc] init];
    for (Brand *item in self.arrayBrands) {
        [stringArrayBrand addObject:item.name];
    }
    
    if (!self.filterView) {
        self.filterView = [[FilterView alloc] initWithConditionData:
                           @{KCategoryArray: stringArrayGoods, KBrandArray:stringArrayBrand}];
        self.filterView.delegate = self;
    }
    return self.filterView;
}

-(void)showFilterView
{
    FilterView *filterView = [self getFilterView];
    filterView.frame = CGRectMake(0, 104, deviceWidth, 0);
    [self.view addSubview:self.filterView];

    [UIView animateWithDuration:0.3 animations:^{
        int height = self.tableView.frame.size.height;
        
        CGRect rt = filterView.frame;
        rt.size.height = height;
        filterView.frame = rt;
    }completion:^(BOOL finished){
        
    }];
    
    //设置箭头指向
    [segmentedUIView setCurrentIndexIsUp:YES];

}

-(void)removeFilterView
{
    filterViewIsShow = NO;
    //设置箭头指向
    [segmentedUIView setCurrentIndexIsUp:NO];
    
    if (self.filterView) {
        
        [UIView animateWithDuration:0.3 animations:^{

            FilterView *filterView = [self getFilterView];
            CGRect rt = filterView.frame;
            rt.size.height = 0;
            filterView.frame = rt;
        }completion:^(BOOL finished){
            [self.filterView removeFromSuperview];
        }];
    }
}
//清除过滤器选中数据
-(void)clearSelectedFilter:(id)sender{
    selectedBrandIndex = -1;
    [self refreshFilterViewState];
    //重新加载
    self.curBrandId = @"";
    [self getListData:self.cId page:pageIndex brandId:self.curBrandId sort:SortType_Common showIndicator:YES];
    curSortType =SortType_Common;
}
-(void)refreshFilterViewState{
    FilterView *filterView = [self getFilterView];
    filterView.brandIndex = -1;
    [filterView.collectionView reloadData];

}

#pragma mark- FilterViewDelegate
-(void)filterView:(FilterView*)filterView categoryIndex:(int)categoryIndex brandIndex:(int)brandIndex
{
    //当前品牌id
    NSString *brandId=@"";
    DBG_MSG(@"filter view select categoryIndex=%d--brandIndex=%d", categoryIndex, brandIndex);
    if (categoryIndex != -1) {
        //有选择
        GoodClass *tempGoods = goodsArray[categoryIndex];
        self.cId = tempGoods.Id;
        self.title = tempGoods.name;
        
        self.navigationItem.title = self.title;
        //[self.navigationController setTitle:self.title];
    }
    //设置选中的品牌id为当前id
    selectedBrandIndex = brandIndex;
    if (brandIndex !=-1) {
        //有选择
        Brand *tempBrand = self.arrayBrands[brandIndex];
        brandId = tempBrand.Id;
    }
    //还原到第一页
    pageIndex = 1;
    //获取数据
    self.curBrandId = brandId;
    [self getListData:self.cId page:pageIndex brandId:brandId sort:curSortType showIndicator:YES];
    //重新加载数据
    [self.tableView reloadData];
    [self removeFilterView];
}


-(void)filterViewCancel:(FilterView*)filterView
{
    [self removeFilterView];
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
        case KReqestType_GoodsByClass:
        {
            if (manualLoading) {
                if (refresh) {
                    //刷新
                    self.arrayProducts = [NSMutableArray arrayWithArray: [result.data objectForKey:KJsonElement_Data]];
                    self.arrayBrands = [result.data objectForKey:KJsonElement_Brands];
                    
                    pageCount = [[result.data objectForKey:KJsonElement_Pages] intValue];
                    if (pageCount > 1) {
                        [self.tableView addFootView];
                    }
                    else {
                        [self.tableView removeFootView];
                    }
                    
                    [self.tableView doneLoadingRefreshData];
                }
                else {
                    //加载更多
                    [self.tableView doneLoadingMoreData];
                    
                    NSArray *array = [result.data objectForKey:KJsonElement_Data];
                    [self.arrayProducts addObjectsFromArray:array];
                    if (pageIndex >= pageCount) {
                        [self.tableView removeFootView];
                    }
                }
                
                manualLoading = NO;
                refresh = NO;
                
            }
            else {
                self.arrayProducts = [NSMutableArray arrayWithArray: [result.data objectForKey:KJsonElement_Data]];
                self.arrayBrands = [result.data objectForKey:KJsonElement_Brands];
                
                pageCount = [[result.data objectForKey:KJsonElement_Pages] intValue];
                if (pageCount > 1) {
                    [self.tableView addFootView];
                }
                else {
                    [self.tableView removeFootView];
                }
            }
            
            [self.tableView reloadData];
        }
            break;
        case KReqestType_Adetailclass:
        case KReqestType_Adetail:
        {
            if (result.resultCode == 0) {
                self.arrayProducts = [NSMutableArray arrayWithArray: [result.data objectForKey:KJsonElement_Goods]];
//                [self sortWithKey:SortKey_Seconds asc:YES];
//                if (self.isRequestAll) {
//                    self.arWhouses = result.attachData;
//                }
                
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
    ResultDataModel *result = notification.object;
    switch (result.requestType) {
        case KReqestType_GoodsByClass:
        {
            //加载失败隐藏加载图标
            if (manualLoading) {
                if (refresh) {
                    [self.tableView doneLoadingRefreshData];
                }
                else {
                    //加载更多
                    [self.tableView doneLoadingMoreData];
                }
                manualLoading = NO;
                refresh = NO;
            }
        }
            break;
        default:
            break;
    }
}


#pragma mark- 跟随滚动的滑动视图

//滑动出现导航bar
-(void)showNaigationBar:(BOOL)show{
    //是否显示自定义的导航分类
    [self.topView setHidden:!show];
    
    [super showNaigationBar:show];
}
@end
