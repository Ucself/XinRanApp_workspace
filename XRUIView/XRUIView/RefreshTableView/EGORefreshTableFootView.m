//
//  EGORefreshTableHeaderView.m
//  Demo
//

#define KDefautInsetsBottom      49.0f
#define KRefreshInsetsBottom     85.0f

#import "EGORefreshTableFootView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableFootView (Private)
- (void)setState:(EGOPullRefreshState1)aState;
@end

@implementation EGORefreshTableFootView

@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
        //self.backgroundColor = [UIColor redColor];
		//self.backgroundColor = SEARCHBARBGCOLOR;
//		ImageView *img = [[ImageView alloc] initWithPath:@"NoticeBgNormal.png" ImageType:ImageDefault];
//		self.backgroundView = img;
//		self.backgroundView.alpha = 0.5;
//		[img release];
		
//		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, RefreshViewHight - 30.0f, self.frame.size.width, 20.0f)];
//		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		label.font = [UIFont systemFontOfSize:12.0f];
//		label.textColor = TEXT_COLOR;
//		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
//		label.backgroundColor = [UIColor clearColor];
//		label.textAlignment = UITextAlignmentCenter;
//		[self addSubview:label];
//		_lastUpdatedLabel=label;
//		[label release];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 15.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
//		CALayer *layer = [CALayer layer];
//		layer.frame = CGRectMake(25.0f, RefreshViewHight - RefreshViewHight, 30.0f, 55.0f);
//		layer.contentsGravity = kCAGravityResizeAspect;
//		layer.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
//		
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
//		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
//			layer.contentsScale = [[UIScreen mainScreen] scale];
//		}
//#endif
//		
//		[[self layer] addSublayer:layer];
//		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(105.0f, 15.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
		
		
		[self setState:EGOOPullRefreshNormal1];
		
    }
	
    return self;
	
}


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		//NSDate *date = [_delegate egoRefreshTableFootDataSourceLastUpdated:self];
		
//		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//		[formatter setAMSymbol:@"上午"];
//		[formatter setPMSymbol:@"下午"];
//		[formatter setDateFormat:@"yyyy/MM/dd hh:mm:a"];
//		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最后更新: %@", [formatter stringFromDate:date]];
//        
//		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
//		[[NSUserDefaults standardUserDefaults] synchronize];
//		[formatter release];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}

}

- (void)setState:(EGOPullRefreshState1)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling1:
			
			_statusLabel.text = NSLocalizedString(@"上拉加载更多⋯", @"上拉加载更多⋯");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			//_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal1:
			
			if (_state == EGOOPullRefreshPulling1) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				//_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = NSLocalizedString(@"上拉加载更多", @"上拉加载更多");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			//_arrowImage.hidden = NO;
			//_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoading1:
			
			_statusLabel.text = NSLocalizedString(@"加载中⋯", @"加载中⋯");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			//_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

//手指屏幕上不断拖动调用此方法
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
    UIEdgeInsets insets = scrollView.contentInset;
	if (_state == EGOOPullRefreshLoading1) {

		scrollView.contentInset =  UIEdgeInsetsMake(insets.top, insets.left, KRefreshInsetsBottom, insets.right);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableFootDataSourceIsLoading:self];
		}
		
		if (_state == EGOOPullRefreshPulling1 && scrollView.contentOffset.y + (scrollView.frame.size.height) < scrollView.contentSize.height + KRefreshInsetsBottom && scrollView.contentOffset.y > 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormal1];
		} else if (_state == EGOOPullRefreshNormal1 && scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + KRefreshInsetsBottom  && !_loading) {
			[self setState:EGOOPullRefreshPulling1];
		}
		
		if (scrollView.contentInset.bottom != insets.bottom) {
			scrollView.contentInset = insets;
		}
		
	}
	
}

//当用户停止拖动，并且手指从屏幕中拿开的的时候调用此方法
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([self.delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableFootDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + KRefreshInsetsBottom && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableFootDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableFootDidTriggerRefresh:self];
		}
		
		[self setState:EGOOPullRefreshLoading1];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        UIEdgeInsets insets = scrollView.contentInset;
        insets.bottom = KRefreshInsetsBottom;
        [scrollView setContentInset:insets];
		[UIView commitAnimations];
		
	}
	
}

//当开发者页面页面刷新完毕调用此方法，[delegate egoRefreshScrollViewDataSourceDidFinishedLoading: scrollView];
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    UIEdgeInsets insets = scrollView.contentInset;
    insets.bottom = KDefautInsetsBottom;
    [scrollView setContentInset:insets];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal1];

}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	//_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}


@end
