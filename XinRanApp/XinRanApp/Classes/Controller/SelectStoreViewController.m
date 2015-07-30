//
//  SelectStoreViewController.m
//  XinRanApp
//
//  Created by tianbo on 14-12-22.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "SelectStoreViewController.h"

#import "User.h"
#import "Whouse.h"
#import "Areas.h"
#import "UserWhouse.h"

@interface SelectStoreViewController ()
{
    AreaPickerView *pickerView;
    BOOL bShowSearchResult;
}

@property (weak, nonatomic) IBOutlet UIButton *btnAddress;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UILabel *labelProvince;
@property (weak, nonatomic) IBOutlet UILabel *labelCity;
@property (weak, nonatomic) IBOutlet UILabel *labeldistrict;

//所有店铺数组
@property (copy, nonatomic) NSArray *arWhouses;
//显示的店铺数组
@property (strong, nonatomic) NSMutableArray *arRelationWhouses;      //参与的店铺
//@property (strong, nonatomic) NSMutableArray *arUsedWhouses;        //用过的店铺
@property (strong, nonatomic) NSMutableArray *arSearchWhouses;        //搜索结果店铺

//区域数组
/*分级结构
 -- 省
    -- 市
        -- 区
 */
@property (strong, nonatomic) NSMutableArray *arProvince;


@end

@implementation SelectStoreViewController

- (void)viewDidLoad {
    
    isShowRequestPrompt = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arProvince = [NSMutableArray new];
    _arRelationWhouses = [NSMutableArray new];
    //_arUsedWhouses = [NSMutableArray new];
    _arSearchWhouses = [NSMutableArray new];


    if (![self loadLocalData]) {
        //本地没有数据重新获取
        [[NetInterfaceManager sharedInstance] getAreawhouse];
        [self startWait];
    }
    
    //去除group模式项部空白
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isReturnRoot) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(0, 0, 60, 40);
        //btn.backgroundColor = [UIColor greenColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"首页" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, -30)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [btn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, backNavigationItem];
    }
    
    if (![[EnvPreferences sharedInstance] getToken] || !self.selArea) {
        [self.locationView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.top).offset(30).priorityHigh();
        }];
    }
    
    if (self.arWhouses && self.arWhouses.count > 0) {
        
        [self refreshUI];
    }
}

-(void)viewDidLayoutSubviews
{
//    [UIView animateWithDuration:0.4 animations:^{
//        [self.locationView updateConstraints:^(MASConstraintMaker *make) {
//            //make.height.equalTo(@35);
//            make.top.equalTo(self.view.top).offset(64).priorityHigh();
//        }];
//        
//        [self.view setNeedsDisplay];
//    }];
}

-(void)backButtonClick:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

-(BOOL)loadLocalData
{
    //省级数组
    NSArray *arProvince = [Areas provinceList];
    if (!arProvince || arProvince.count == 0) {
        //没有省级就认为失败
        DBG_MSG(@"load local areas data failed!");
        return NO;
    }
    
    //城市数组
    NSMutableArray *arCitys = [NSMutableArray new];
    for (Areas *province in arProvince) {
        
        if (province) {
            [arCitys addObjectsFromArray:[Areas cityList:province.Id]];
        }
    }
    
    //区域数组
    NSMutableArray *arDistrict = [NSMutableArray new];
    for (Areas *city in arCitys) {
        if (city) {
            [arDistrict addObjectsFromArray:[Areas districtList:city.Id]];
        }
    }
    //如果没有第三级就把城市当作区
//    if (arDistrict.count>0) {
//        self.curArea = [arDistrict objectAtIndex:0];
//    }
//    else if (arCitys.count>0){
//        self.curArea = [arCitys objectAtIndex:0];
//    }
    
    
    /*组合数组
      -- 省
        -- 市
         -- 区
     */
    [self.arProvince removeAllObjects];
    for (Areas *province in arProvince) {
        @autoreleasepool {
            NSMutableDictionary *dictProvince = [NSMutableDictionary new];
            [dictProvince setObject:province forKey:@"area"];
            
            NSMutableArray *citys = [NSMutableArray new];
            for (Areas *city in arCitys) {
                
                NSMutableDictionary *dictCity = [NSMutableDictionary new];
                [dictCity setObject:city forKey:@"area"];
                
                NSMutableArray *districts = [NSMutableArray new];
                for (Areas *district in arDistrict) {
                    
//                    NSMutableDictionary *dictDistrict = [NSMutableDictionary new];
//                    [dictDistrict setObject:district forKey:@"area"];
                    
                    if ([district.pId isEqualToString:city.Id]) {
                        [districts addObject:district];
                    }
                }
                
                [dictCity setObject:districts forKey:@"items"];
                if ([city.pId isEqualToString:province.Id]) {
                    [citys addObject:dictCity];
                }
            }
            
            [dictProvince setObject:citys forKey:@"items"];
            
            [self.arProvince addObject:dictProvince];
        }
    }
    
    //所有店铺数组
    NSArray *arWhouses = [Whouse modelList];
    if (!arWhouses && arWhouses.count == 0) {
        DBG_MSG(@"load local whouse data failed!");
        return NO;
    }
    
    self.arWhouses = arWhouses;
    
    
//    //用户常用店铺
//    NSString *userId = [[EnvPreferences sharedInstance] getUserInfo].userId;
//    NSArray *arUserWhouses = [UserWhouse modelList];
//    for (UserWhouse *userWhouse in arUserWhouses) {
//        if (!userWhouse) {
//            continue;
//        }
//        
//        if ([userId isEqualToString:userWhouse.userId]) {
//            
//            for (Whouse *whouse in self.arWhouses) {
//                if ([userWhouse.whouseId isEqualToString:whouse.Id]) {
//                    [self.arUsedWhouses addObject:whouse];
//                }
//            }
//        }
//    }
    
    return YES;
}

-(void)refreshUI
{
    //刷新区域
    BOOL bhaveCity = [self refreshLocation];
    
    //刷新店铺
    [self refreshList:bhaveCity];
}

-(BOOL)refreshLocation
{
    //更新区域
    BOOL bFind = NO;
    for (NSDictionary *dictProvince in self.arProvince) {
        if (!dictProvince) {
            continue;
        }
        
        Areas *province = [dictProvince objectForKey:@"area"];
        NSArray *arCitys = [dictProvince objectForKey:@"items"];
        
        for (NSDictionary *dictCity in arCitys) {
            if (!dictCity) {
                continue;
            }
            Areas *city = [dictCity objectForKey:@"area"];
            NSArray *arDistrict = [dictCity objectForKey:@"items"];
            
            if (arDistrict && arDistrict.count>0) {
                for (Areas *district in arDistrict) {
                    if (!district) {
                        continue;
                    }
                    
                    //if (district.state == AreasState_Selelcted) {
                    if ([district.Id isEqualToString:self.selArea.Id]) {
                        
                        self.labeldistrict.text = district.name;
                        bFind = YES;
                        break;
                    }
                }
            }
            else {    //如果没有区
                if ([city.Id isEqualToString:self.selArea.Id]) {
                    
                    self.labeldistrict.text = @"";
                    bFind = YES;
                }
            }
            
            
            if (bFind) {
                self.labelCity.text = city.name;
                break;
            }
        }
        
        if (bFind) {
            self.labelProvince.text = province.name;
            break;
        }
    }
    
    return bFind;
}

-(void)refreshList:(BOOL)bhaveCity
{
    [self.arRelationWhouses removeAllObjects];
    if (!bhaveCity && self.selArea) {
        //如果当前区域是省,则查找该省下的所有店铺
        self.labelProvince.text = self.selArea.name;
        for (Whouse *whouse in self.arWhouses) {
            
            for (NSDictionary *dictProvince in self.arProvince) {
                Areas *province = [dictProvince objectForKey:@"area"];
                NSArray *arCitys = [dictProvince objectForKey:@"items"];
                
                if (![province.Id isEqualToString:self.selArea.Id]) {
                    continue;
                }
                
                for (NSDictionary *dictCity in arCitys) {
                    if (!dictCity) {
                        continue;
                    }
                    Areas *city = [dictCity objectForKey:@"area"];
                    NSArray *arDistrict = [dictCity objectForKey:@"items"];
                    
                    if (arDistrict && arDistrict.count>0) {
                        for (Areas *district in arDistrict) {
                            if (!district) {
                                continue;
                            }
                            
                            if ([whouse.areaId isEqualToString:district.Id]) {
                                [self.arRelationWhouses addObject:whouse];
                            }
                        }
                    }
                    else {    //如果没有区
                        if ([whouse.areaId isEqualToString:city.Id]) {
                            [self.arRelationWhouses addObject:whouse];
                        }
                    }
                    
                }
            }
        }
    }
    else if (self.selArea) {
        for (Whouse *whouse in self.arWhouses) {
            if ([whouse.areaId isEqualToString:self.selArea.Id]) {
                [self.arRelationWhouses addObject:whouse];
            }
        }
    }
    else if (!self.arRelationStoreIds || self.arRelationStoreIds.count == 0) {
        //如果没有指定店铺id则全部加载
        for (Whouse *whouse in self.arWhouses) {
            [self.arRelationWhouses addObject:whouse];
        }
    }
    else {
        for (Whouse *whouse in self.arWhouses) {
            id obj = [self.arRelationStoreIds objectAtIndex:0];
            
            if ([obj isKindOfClass:[NSDictionary class]]) {
                //产品列表传过来的数据
                for (NSDictionary *dict in self.arRelationStoreIds) {
                    NSString *Id = [dict objectForKey:@"id"];
                    
                    if ([whouse.Id isEqualToString:Id]) {
                        [self.arRelationWhouses addObject:whouse];
                    }
                }
            }
            else if ([obj isKindOfClass:[WhouseProduct class]]) {
                //产品详情传过来的数据
                for (WhouseProduct *whosepdt in self.arRelationStoreIds) {
                    
                    if ([whosepdt.Id isEqualToString:whouse.Id]) {
                        whouse.remainds = whosepdt.remainds;
                        [self.arRelationWhouses addObject:whouse];
                    }
                }
            }
        }
    }
    
    //搜索结果
    if(bShowSearchResult) {
        [self.arSearchWhouses removeAllObjects];
        for (Whouse *whouse in self.arRelationWhouses) {
            if ([whouse.areaId isEqualToString:self.selArea.Id]) {
                [self.arSearchWhouses addObject:whouse];
            }
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark-
- (IBAction)btnSelectStoreClick:(id)sender {
    [self showPickerView];
}

#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (bShowSearchResult) {
        return self.arSearchWhouses.count;
    }
    
    return self.arRelationWhouses.count;
    
//    if (section == 0) {
//        if (self.arUsedWhouses.count != 0) {
//            return self.arUsedWhouses.count;
//        }
//        else {
//            return self.arRelationWhouses.count;
//        }
//        
//    }
//    else if (section == 1) {
//        
//        return self.arRelationWhouses.count;
//    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellStore"];
    
    Whouse *whouse = nil;
    if (indexPath.section == 0) {
        if (bShowSearchResult) {
            if (self.arSearchWhouses.count != 0) {
                whouse = [self.arSearchWhouses objectAtIndex:indexPath.row];
            }
        }
        else {
            whouse = [self.arRelationWhouses objectAtIndex:indexPath.row];

        }
 
    }
//    else if (indexPath.section == 1) {
//        whouse = [self.arRelationWhouses objectAtIndex:indexPath.row];
//
//    }
    
    UILabel *labelTitle = (UILabel*)[cell viewWithTag:101];
    UILabel *labelDetail = (UILabel*)[cell viewWithTag:103];
    if (whouse) {
        labelTitle.text = whouse.name;
        labelDetail.text = whouse.address;

    }
    
    if (self.isShowRemainds) {
        UIView *viewRemainds = (UIView*)[cell viewWithTag:104];
        viewRemainds.hidden = NO;
        UILabel *labelRemainds = (UILabel*)[cell viewWithTag:102];
        labelRemainds.text = [NSString stringWithFormat:@"%d件", whouse.remainds];
    }
    else {
        UIView *viewRemainds = (UIView*)[cell viewWithTag:104];
        viewRemainds.hidden = YES;
        
        [labelTitle remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-10).priorityHigh();
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Whouse *whouse = nil;
    if (indexPath.section == 0) {
        if (bShowSearchResult) {
            if (self.arSearchWhouses.count != 0) {
                whouse = [self.arSearchWhouses objectAtIndex:indexPath.row];
            }
        }
        else {
            whouse = [self.arRelationWhouses objectAtIndex:indexPath.row];
            
        }
        
    }
    else if (indexPath.section == 1) {
        whouse = [self.arRelationWhouses objectAtIndex:indexPath.row];
        
    }
    
    
    if ([self.delegate respondsToSelector:@selector(controllerBackWithData:)]) {
        [self.delegate controllerBackWithData:whouse];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (bShowSearchResult) {
//        return 1;
//    }
//    
//    else if (self.arUsedWhouses.count != 0) {
//        return 2;
//    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (bShowSearchResult) {
//        return 1;
//    }
    
//    else if (self.arRelationWhouses.count != 0) {
//        return 30;
//    }
//    
//    return 0;
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
    
//    if (bShowSearchResult) {
//        return nil;
//    }
    
    UIView *view = nil;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor darkGrayColor];
    view = label;
    
    //label.text = @"  全部店铺:";
//    switch (section) {
//        case 0:
//        {
//            if (self.arUsedWhouses.count != 0) {
//                label.text = @"  您的常用店铺";
//
//            }
//            else {
//                label.text = @"  全部店铺:";
//            }
//        }
//            
//            break;
//        case 1:
//        {
//            label.text = @"  全部店铺:";
//        }
//            break;
//            
//        default:
//            break;
//    }
    
    return view;
}


#pragma mark- http request handler
-(void)httpRequestFinished:(NSNotification *)notification
{
    DBG_MSG(@"enter");
    [self stopWait];
    ResultDataModel *result = notification.object;
    if (!result) {
        return;
    }
    
    switch (result.requestType) {
        case KReqestType_Areawhouse:
        {
            if (result.resultCode == 0) {
                //暂时每次登录先清除原来表数据
                [Whouse clear];
                [Areas clear];
                
                NSArray *arWhouses = [result.data objectForKey:KJsonElement_Whouses];
                NSArray *arAreas = [result.data objectForKey:KJsonElement_Areas];
                
                //更新数据库
                for (Areas *area in arAreas) {
                    [Areas addNewModel:area];
                }
                
                for (Whouse *whouse in arWhouses) {
                    [Whouse addNewModel:whouse];
                }
                
                //初始化数据
                [self loadLocalData];
                
                [self refreshUI];
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
    return [super httpRequestFailed:notification];
}

-(void)showPickerView
{
    if (!pickerView) {
        pickerView = [[AreaPickerView alloc] initWithDelegate:self areas:self.arProvince];
    }
    //pickerView.selArea = self.selArea;
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
- (void)pickerViewOK:(Areas*)area;
{
//    bShowSearchResult = YES;
//    self.selArea = area;
//    [self refreshUI];
//    
//    [UIView animateWithDuration:0.4 animations:^{
//        [self.locationView updateConstraints:^(MASConstraintMaker *make) {
//            //make.height.equalTo(@35);
//            make.top.equalTo(self.view.top).offset(64).priorityHigh();
//        }];
//        
//        [self.view setNeedsDisplay];
//    }];
//    [pickerView cancelPicker:self.view];
}
@end
