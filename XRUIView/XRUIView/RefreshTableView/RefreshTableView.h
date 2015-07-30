//
//  RefreshTableView.h
//  YQTManager
//
//  Created by Mark on 13-3-21.
//
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFootView.h"

@protocol RefreshTableViewDelegate<NSObject>
-(void) refreshData;
-(void) loadMoreData;

@end

@interface RefreshTableView : UITableView<EGORefreshTableHeaderDelegate,EGORefreshTableFootDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;//刷新的控件
	EGORefreshTableFootView *_refreshFootView;//加载更多
    BOOL _reloading;
    
    CGPoint point;//判断是上拉还是下拉

    id refreshDelegate;
}

@property(nonatomic, assign)id refreshDelegate;

-(void)addHeaderView;
-(void)addFootView;
-(void)removeFootView;

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)doneLoadingRefreshData;
- (void)doneLoadingMoreData;

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
@end
