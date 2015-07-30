//
//  ShakeRecordViewController.m
//  XinRanApp
//
//  Created by tianbo on 15-5-22.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "ShakeRecordViewController.h"

#import <XRUIView/RefreshTableView.h>
#import "User.h"

@interface ShakeRecordViewController () <UIScrollViewDelegate>
{
    int pageCount;
    int pageIndex;
    BOOL manualLoading;
}

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet RefreshTableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelTips;

@end



@implementation ShakeRecordViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.refreshDelegate = self;
    
    pageCount = 1;
    pageIndex = 1;
    [self getListData];
    [self startWait];
}

-(void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.refreshDelegate = nil;
}

-(void)getListData
{
    User *user = [[EnvPreferences sharedInstance] getUserInfo];
    [[NetInterfaceManager sharedInstance] activityOrderList:user.userId page:pageIndex];
}

#pragma mark- UITableView Delegate mothed

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shakerecordcell"];
    
    UILabel *labelTime = (UILabel*)[cell viewWithTag:101];
    UILabel *labelName = (UILabel*)[cell viewWithTag:102];
    UILabel *labelStatus = (UILabel*)[cell viewWithTag:103];

    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    
    labelTime.text = [dict objectForKey:@"order_date"];
    labelName.text = [dict objectForKey:@"goods_name"];
    
    int state = [[dict objectForKey:@"order_status"] intValue];
    NSString *text = @"";
    if (state == 0) {   //未领取
        text = @"未领取";
    }
    else if (state == 1) {    //已领取
        text = @"已领取";
    }

    else if (state == 2) {    //已过期
        text = @"已过期";
    }
    labelStatus.text = text;
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
    
    //下拉加载更多view重定位
    [self.tableView tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.tableView scrollViewWillBeginDecelerating:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tableView scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    [self.tableView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

#pragma mark - RefreshTableViewDelegate
-(void) refreshData
{
}

-(void) loadMoreData
{
    if (pageCount > 1 && pageCount > pageIndex) {
        manualLoading = YES;
        
        pageIndex++;
        [self getListData];
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
        case KReqestType_ActivityOrderlist:
        {
            if (result.resultCode == 0) {
                
                pageCount = [[result.data objectForKey:@"pages"] intValue];
                
                if (manualLoading) {
                    //加载更多
                    [self.tableView doneLoadingMoreData];
                    
                    if (pageIndex >= pageCount) {
                        [self.tableView removeFootView];
                    }
                    
                    [self.dataArray addObjectsFromArray:[result.data objectForKey:@"data"]];
                    manualLoading = NO;
                }
                else {
                    self.dataArray = [NSMutableArray arrayWithArray:[result.data objectForKey:@"data"]];
                    
                    if (pageCount > 1) {
                        [self.tableView addFootView];
                    }
                    else {
                        [self.tableView removeFootView];
                    }
                    
                    if (self.dataArray.count == 0) {
                        self.labelTips.hidden = NO;
                        self.labelTips.text = @"当前无中奖记录, 继续加油";
                    }
                    else {
                        self.labelTips.hidden = YES;
                    }
                }
                
                

                [self.tableView reloadData];
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
@end
