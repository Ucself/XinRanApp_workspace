//
//  OftenStoreViewController.m
//  XinRanApp
//
//  Created by mac on 15/1/28.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "OftenStoreViewController.h"
#import "SelectStoreViewController.h"

#import "Whouse.h"
#import "User.h"
#import "UserWhouse.h"

@interface OftenStoreViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Whouse *whouse;
@property (nonatomic, strong) NSArray *dataArray;



@end

@implementation OftenStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[EnvPreferences sharedInstance] getUserInfo].arUserWhouses;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.goSelStore) {
        //跳转到选择店铺
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(0, 0, 60, 40);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, -30)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [btn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, backNavigationItem];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        SelectStoreViewController *selectStore = [storyboard instantiateViewControllerWithIdentifier:@"SelectStoreViewController"];
        selectStore.delegate = self;
        selectStore.isReturnRoot = YES;
        
        //根据传过来省名查找Area
        NSArray *arProvinces = [Areas provinceList];
        for (Areas *province in arProvinces) {
            NSRange range = [self.arearName rangeOfString:province.name];
            if (range.location != NSNotFound) {
                selectStore.selArea = province;
            }
        }
        [self.navigationController pushViewController:selectStore animated:YES];
        
        self.goSelStore = NO;
    }
    else{
        if (!self.dataArray || self.dataArray.count == 0) {
            
            [self performSelector:@selector(notHaveStoreTips) withObject:nil afterDelay:0.5];
        }
    }
}

-(void)notHaveStoreTips
{
    [self showTipsView:@"请选择您常去的店铺!"];
}

-(void)backButtonClick:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//选择店铺页面返回数据
-(void)controllerBackWithData:(id)data
{
    Whouse *whouse = (Whouse*)data;
    self.dataArray = [NSArray arrayWithObjects:whouse, nil];
    
    User *user = [[EnvPreferences sharedInstance] getUserInfo];
    user.arUserWhouses = [NSArray arrayWithArray:self.dataArray];
    [[EnvPreferences sharedInstance] setUserInfo:user];
    
    //把店铺Id存入数据库, 先删除原有数据,因暂时只支持一个常用店铺
    [UserWhouse removeWithId:user.userId];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:whouse.Id,@"whouseId",user.userId,@"userId",nil];
    UserWhouse *uWhouse = [[UserWhouse alloc] initWithDictionary:dict];
    [UserWhouse addNewModel:uWhouse];
    
    [self.tableView reloadData];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (section==0) {
        if (self.dataArray && self.dataArray.count!=0) {
            return self.dataArray.count;
        }
    }
    else if(section==1) {
        return 1;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 && indexPath.row==0) {
        return 65.0;
    }
    return 44.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.3)];
    label.backgroundColor = [UIColor lightGrayColor];
    return label;
    
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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"当前所选常去店铺";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section==0&&indexPath.row==0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"oftenStoreCell"];
        
        UILabel *nameLabel = (UILabel*)[cell viewWithTag:100];
        UILabel *addressLabel = (UILabel*)[cell viewWithTag:200];
        if (self.dataArray && self.dataArray.count!=0) {
            Whouse *whouse = self.dataArray[indexPath.row];
            nameLabel.text = whouse.name;
            addressLabel.text = whouse.address;
            [addressLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell).offset(-10).priorityHigh();
            }];
        }
        
        return cell;
    }
    cell = [tableView dequeueReusableCellWithIdentifier:@"selectCell"];

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section==1 && indexPath.row==0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        SelectStoreViewController *selectStore = [storyboard instantiateViewControllerWithIdentifier:@"SelectStoreViewController"];
        selectStore.delegate = self;
        
       
        if (self.dataArray) {
            Whouse *whouse = self.dataArray[0];
            Areas *area = [Areas getArearWithId:whouse.areaId];
            
            selectStore.selArea = area;
        }

        [self.navigationController pushViewController:selectStore animated:YES];
    }
}

@end
