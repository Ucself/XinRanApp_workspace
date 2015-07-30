//
//  BannerView.m
//  XinRanApp
//
//  Created by mac on 14/12/11.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "BannerView.h"
#import <XRNetInterface/UIImageView+AFNetworking.h>

@interface BannerView ()

@property (nonatomic, strong) NSArray *banners;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic)  UIPageControl *pageControl;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) BOOL isStop;
@end

@implementation BannerView



- (void)initUI
{
    float height = self.frame.size.height;
    float width = self.frame.size.width;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(self);
    }];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    self.pageControl.numberOfPages = 4;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor lightTextColor];
    self.pageControl.currentPageIndicatorTintColor = UIColor_DefGreen;
    [self addSubview:self.pageControl];
    
    [self.pageControl makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottom).offset(-30);
        make.centerX.equalTo(self);
        make.width.equalTo(@100);
        
    }];
}

- (void)addTimer
{
    if (!self.autoTurning)
        return;
    
    if (self.timer) {
        [self removeTimer];        
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)startTimer
{
    if (_isStop) {
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

- (void)stopTimer
{
    _isStop = YES;
    [self.timer setFireDate:[NSDate distantFuture]];

}

- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextImage
{
    // 1.增加pageControl的页码
    float height = self.frame.size.height;
    float width = self.frame.size.width;
    
    int page = (int)self.pageControl.currentPage + 1;
    [self.scrollView scrollRectToVisible:CGRectMake(width * (page+1),0,width,height) animated:YES];
    
    //实循环效果
    if (self.pageControl.currentPage == _banners.count - 1){
        //[self.scrollView scrollRectToVisible:CGRectMake(width,0,width,height) animated:NO];
        [self performSelector:@selector(firstImage) withObject:nil afterDelay:0.3];
    }
 
}

-(void)firstImage
{
    float height = self.frame.size.height;
    float width = self.frame.size.width;
    [self.scrollView scrollRectToVisible:CGRectMake(width,0,width,height) animated:NO];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 开启定时器
    [self addTimer];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        
        self.imageMode = UIViewContentModeScaleToFill;
        //[self.pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

-(void)dealloc
{
    [self removeTimer];
    
    self.banners = nil;
    self.scrollView = nil;
    self.pageControl = nil;
}

-(void)clearAll
{
    for (UIView *view in self.scrollView.subviews) {
        if (view && [view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
}


//-(void)loadBanners:(NSArray *)banners
//{
//    [self removeTimer];
//    self.banners = banners;
//    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
//    for (int i = 0; i < banners.count; i++) {
//        Ads *banner = [banners objectAtIndex:i];
//        [array addObject: banner.picAddr];
//    }
//    
//    [self addImagesUrl:array];
//    
//    [self addTimer];
//}

-(void)loadImagesUrl:(NSArray*)imagesUrl
{
    self.banners = imagesUrl;
    [self addImagesUrl:imagesUrl];
}

-(void)addImagesUrl:(NSArray*)urls
{
    float height = self.frame.size.height;
    float width = [[UIScreen mainScreen] bounds].size.width;
    
    [self clearAll];
    UIView *lastView = nil;
    
    //添加最后一个到最前面
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,width, height)];
    imageView.contentMode = self.imageMode;
    //imageView.image = [UIImage imageNamed:[banners objectAtIndex:banners.count-1]];
    NSString *url = [urls objectAtIndex:urls.count- 1];
    [imageView setImageWithURL: [NSURL URLWithString:url]];
    [self.scrollView addSubview:imageView];
    
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    
    lastView = imageView;
    
    //循环添加
    for (int i = 0; i < urls.count; i++) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(width + width*i, 0,width, height)];
        imageView.contentMode = self.imageMode;
        NSString *url = [urls objectAtIndex:i];
        [imageView setImageWithURL: [NSURL URLWithString:url]];
        [self.scrollView addSubview:imageView];
        
        imageView.tag=i;
        UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
        [Tap setNumberOfTapsRequired:1];
        [Tap setNumberOfTouchesRequired:1];
        imageView.userInteractionEnabled=YES;
        [imageView addGestureRecognizer:Tap];
        
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastView.right);
            make.top.equalTo(@0);
            make.width.equalTo(self.scrollView);
            make.height.equalTo(self.scrollView);
        }];
        
        lastView = imageView;
    }
    
    //添加第一个到最后面
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(width * (urls.count+1), 0,width, height)];
    imageView.contentMode = self.imageMode;
    url = [urls objectAtIndex:0];
    [imageView setImageWithURL: [NSURL URLWithString:url]];
    [self.scrollView addSubview:imageView];
    
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lastView.right);
        make.top.equalTo(@0);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    
    
    //以下代码为了适配不同屏幕尺寸，临时使用不同的宽度，奇怪。。。。
    //width = [[UIScreen mainScreen] bounds].size.width;
    self.pageControl.numberOfPages = urls.count;
    [self.scrollView setContentSize:CGSizeMake(width * ([urls count] + 2), height)];
    [self.scrollView scrollRectToVisible:CGRectMake(lastView.frame.size.width,0,width,height) animated:NO];
    
    if (ISIOS8BEFORE) {//解决ios7 不能滚动问题
        [self layoutIfNeeded];
    }

}

-(void)refreshContentSize
{
    float height = self.frame.size.height;
    float width = [[UIScreen mainScreen] bounds].size.width;
    [self.scrollView setContentSize:CGSizeMake(width * (self.banners.count + 2), height)];
    [self.scrollView setContentOffset:CGPointMake(width, 0)];
}


-(void)awakeFromNib
{
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = self.width.view.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage=(page-1);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)pScrollView
{
    float height = self.frame.size.height;
    float width = self.frame.size.width;
    
    int currentPage = floor((self.scrollView.contentOffset.x - self.scrollView.frame.size.width
                             / ([self.banners count]+2)) / self.scrollView.frame.size.width) + 1;
    

    if (currentPage==0) {
    //go last but 1 page
        [self.scrollView scrollRectToVisible:CGRectMake(width * [self.banners count],0,width,height) animated:NO];

    } else
    if (currentPage==([self.banners count]+1)) {
        //如果是最后+1,也就是要开始循环的第一个
        [self.scrollView scrollRectToVisible:CGRectMake(width,0,width,height) animated:NO];
    }
}

- (void)imagePressed:(UITapGestureRecognizer *)sender
{
    UIView *view = (UIView*)sender.view;
    DBG_MSG(@"pressed view tag:%ld", (long)view.tag);
    if ([self.delegate respondsToSelector:@selector(bannerViewWithIndex:)]) {
        [self.delegate bannerViewWithIndex:(int)view.tag];
    }
}

@end
