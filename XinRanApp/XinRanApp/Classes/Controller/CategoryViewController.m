//
//  CategoryViewController.m
//  XinRanApp
//
//  Created by tianbo on 14-12-5.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "CategoryViewController.h"
#import "ProductListViewController.h"
#import "CategoryUIView.h"

#import <XRNetInterface/UIImageView+AFNetworking.h>
#import "GoodClass.h"


@interface CategoryViewController (){

    CategoryUIView *categoryUIView;

}

@property(nonatomic, strong)NSArray *array;
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    isShowRequestPrompt = YES;
    [self initCategory];
    [super viewDidLoad];
    [self getData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //[self.tableView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //[self categoryDissmis:nil];
}

-(void)getData
{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Category" ofType:@"plist"];
//    self.array = [NSMutableArray arrayWithContentsOfFile:path];
    //获取顶级商品分类
    self.array = [GoodClass getGoodClassWithParentId:@""];
    
    if (!self.array || self.array.count == 0) {
        //重新拉取分类信息
        [[NetInterfaceManager sharedInstance] getBSUP:[[EnvPreferences sharedInstance] getAVersion]
                                            w_version:[[EnvPreferences sharedInstance] getBVersion]
                                            c_version:[[EnvPreferences sharedInstance] getCVersion]
                                            b_version:[[EnvPreferences sharedInstance] getWVersion]];
        [self startWait];
    }
    else{
        isShowRequestPrompt = NO;
    }
}

-(void)initCategory {
    //初始化数据源
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    if (!categoryUIView) {
        categoryUIView = [[CategoryUIView alloc] initWithData:CGRectMake(self.view.bounds.size.width, 64, self.view.bounds.size.width/2, self.view.bounds.size.height) dataSource:mutableArray];
    }
    [self.view addSubview:categoryUIView];
    //添加手势隐藏菜单
    UISwipeGestureRecognizer *recognizer=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(categoryDissmis:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [categoryUIView.categoryUITableView addGestureRecognizer:recognizer];
    UISwipeGestureRecognizer *recognizerRight=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(categoryDissmis:)];
    [recognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.tableView addGestureRecognizer:recognizerRight];
    
    __block CategoryViewController *selfObject = self;
    categoryUIView.dismissHandler = ^(){
        [selfObject categoryDissmis:nil];
    };
}
//动画隐藏菜单
-(void) categoryDissmis:(id)sender{
    //展示菜单
    [UIView animateWithDuration:0.2 animations:^{
        [categoryUIView setFrame:CGRectMake(self.view.bounds.size.width, 64 ,self.view.bounds.size.width/2 -10, self.view.bounds.size.height)];
    }];
}
//动画显示菜单
-(void) categoryShow:(id)sender{
    //展示菜单
    [UIView animateWithDuration:0.2 animations:^{
        [categoryUIView setFrame:CGRectMake(self.view.bounds.size.width/2 + 10, 64 ,self.view.bounds.size.width/2 -10, self.view.bounds.size.height)];
    }];
}
#pragma mark-
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BaseUIViewController* controller = segue.destinationViewController;
    
    if ([controller isKindOfClass:[ProductListViewController class]]) {
        
        GoodClass *goodClass = (GoodClass *)sender;
        ProductListViewController *c = (ProductListViewController*)controller;
        c.title = goodClass.name;
        c.cId = goodClass.Id;
    }
}

#pragma mark- uitableview delegate mothed
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"categorycell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    GoodClass *goodClassCell = [self.array objectAtIndex:indexPath.row];
    cell.textLabel.text = goodClassCell.name;
    cell.textLabel.textColor = [UIColor grayColor];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Category" ofType:@"plist"];
    NSArray *imageArray = [NSMutableArray arrayWithContentsOfFile:path];
//    [cell.imageView setImageWithURL:[NSURL URLWithString:goodClassCell.iamgePath]];
    for (NSDictionary *goodImageDic in imageArray) {
        if ([(NSString *)[goodImageDic objectForKey:@"id"] isEqualToString:goodClassCell.Id]) {
            cell.imageView.image = [UIImage imageNamed:[goodImageDic objectForKey:@"image"]];
        }
    }
    
    cell.backgroundColor =[UIColor colorWithWhite:1.0 alpha:0.5];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodClass *goodClassCell = [self.array objectAtIndex:indexPath.row];
    //获取子类商品分类
    categoryUIView.dataSource = (NSMutableArray *)[GoodClass getGoodClassWithParentId:goodClassCell.Id];
    
    __block CategoryViewController *selfObject = self;
    categoryUIView.toListHandler = ^(GoodClass *childGoodClass){
        [selfObject performSegueWithIdentifier:@"toList" sender:childGoodClass];
    };
    [categoryUIView.categoryUITableView reloadData];
    //展示菜单
    [UIView animateWithDuration:0.2 animations:^{
        [self categoryShow:nil];
    }];
    
    
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
            
        case KReqestType_BSUP:
        {
            if (result.resultCode == 0) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    self.array = [GoodClass getGoodClassWithParentId:@""];
                    [self.tableView reloadData];
                    if (!self.array || self.array.count == 0) {
                        isShowRequestPrompt = YES;
                    }
                });
            }
        }
        default:
            break;
    }
}

-(void)httpRequestFailed:(NSNotification *)notification
{
    [super httpRequestFailed:notification];
}

@end
