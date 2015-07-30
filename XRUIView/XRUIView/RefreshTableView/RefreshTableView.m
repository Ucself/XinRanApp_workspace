//
//  RefreshTableView.m
//  YQTManager
//
//  Created by Mark on 13-3-21.
//
//

#import "RefreshTableView.h"

@implementation RefreshTableView
@synthesize refreshDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    if (_refreshHeaderView) {
        [_refreshHeaderView release];
    }
    
    if (_refreshFootView) {
        [_refreshFootView release];
    }
    
    
    [super dealloc];
}


#pragma mark-
-(void)addHeaderView
{
    if (_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.frame.size.height, self.frame.size.width, self.bounds.size.height)];
		_refreshHeaderView.delegate = self;
		[self addSubview:_refreshHeaderView];
    }

}

-(void)addFootView
{
    if (_refreshFootView == nil) {
		_refreshFootView = [[EGORefreshTableFootView alloc] initWithFrame: CGRectZero];
		_refreshFootView.delegate = self;
	}
    
    [self addSubview:_refreshFootView];
    _refreshFootView.hidden = YES;
}

-(void)removeFootView
{
    if (_refreshFootView) {
        [_refreshFootView removeFromSuperview];
    }
}

-(void) modifyMoreFrame{
    if (self.contentSize.height <= self.frame.size.height) {
        _refreshFootView.hidden = YES;
    }
    else {
        _refreshFootView.hidden = NO;
        _refreshFootView.frame = CGRectMake(0.0f, self.contentSize.height, self.frame.size.width, 150);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self modifyMoreFrame];;
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    //	point =scrollView.contentOffset;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    point =scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	CGPoint pt =scrollView.contentOffset;
    if (point.y < pt.y) {//向上提加载更多
		if (!_refreshFootView) {
			return;
		}
        if (_refreshFootView.hidden) {
			return;
		}
		[_refreshFootView egoRefreshScrollViewDidScroll:scrollView];
	}
	else {
        if (!_refreshHeaderView) {
            return;
        }
		[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
	}

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	CGPoint pt =scrollView.contentOffset;
    if (point.y < pt.y) {//向上提加载更多
		if (!_refreshFootView) {
			return;
		}
        if (_refreshFootView.hidden) {
			return;
		}
		[_refreshFootView egoRefreshScrollViewDidEndDragging:scrollView];
	}
	else {
        if (!_refreshHeaderView) {
            return;
        }
		[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	}
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self refreshTableViewDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark EGORefreshTableFootDelegate Methods

- (void)egoRefreshTableFootDidTriggerRefresh:(EGORefreshTableFootView*)view{
	
	[self loadMoreDateSource];
	//[self performSelector:@selector(doneLoadingTableViewData1) withObject:nil afterDelay:3.0f];
	
}

- (BOOL)egoRefreshTableFootDataSourceIsLoading:(EGORefreshTableFootView*)view{
	
	return _reloading; // should return if data source model is reloading
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)refreshTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    if ([self.refreshDelegate respondsToSelector:@selector(refreshData)]) {
        [self.refreshDelegate refreshData];
    }
    
	_reloading = YES;
	
}

- (void)doneLoadingRefreshData{
	
	//  model should call this when its done loading
    if (_reloading) {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    }
    
}

-(void)loadMoreDateSource
{
    if ([self.refreshDelegate respondsToSelector:@selector(loadMoreData)]) {
        [self.refreshDelegate loadMoreData];
    }
    
	_reloading = YES;
}

- (void)doneLoadingMoreData
{
    if (_reloading) {
        _reloading = NO;
        [_refreshFootView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    }
}

@end
