//
//  ImagePreView.m
//  XinRanApp
//
//  Created by tianbo on 14-12-30.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "ImagePreView.h"
#import <XRNetInterface/UIImageView+AFNetworking.h>

#import "PZPagingScrollView.h"
#import "PZPhotoView.h"

@interface ImagePreView ()<PZPagingScrollViewDelegate, PZPhotoViewDelegate>

@property (nonatomic, strong) NSArray *arImages;

@property (strong, nonatomic) PZPagingScrollView *scrollView;
@property (strong, nonatomic)  UIPageControl *pageControl;
@end

@implementation ImagePreView

- (void)initUI
{
    self.scrollView = [[PZPagingScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    //self.scrollView.delegate = self;
    self.scrollView.pagingViewDelegate = self;
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
    [self addSubview:self.pageControl];
    
    [self.pageControl makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottom).offset(-30);
        make.centerX.equalTo(self);
        make.width.equalTo(@100);
        
    }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        self.backgroundColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.0 alpha:0.9];
    }
    return self;
}

-(void)dealloc
{
    self.arImages = nil;
    self.scrollView = nil;
    self.pageControl = nil;
}

-(void)loadImages:(NSArray*)images selectIndex:(int)index
{
    self.arImages = images;
    self.pageControl.currentPage = index;
    self.pageControl.numberOfPages = images.count;

    return;
//    UIView* contentView = UIView.new;
//    contentView.backgroundColor = [UIColor clearColor];
//    [self.scrollView addSubview:contentView];
//    [contentView makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.scrollView);
//        make.height.equalTo(self.scrollView);
//    }];
//    
//    //循环添加
//    UIView *lastView = nil;
//    for (int i = 0; i < images.count; i++) {
//        
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        imageView.backgroundColor = [UIColor clearColor];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        NSString *url = [images objectAtIndex:i];
//        [imageView setImageWithURL: [NSURL URLWithString:url]];
//        [contentView addSubview:imageView];
//        
//        imageView.tag=i;
//        UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
//        [Tap setNumberOfTapsRequired:1];
//        [Tap setNumberOfTouchesRequired:1];
//        imageView.userInteractionEnabled=YES;
//        [imageView addGestureRecognizer:Tap];
//        
//        [imageView makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(lastView ? lastView.right : @0);
//            //make.top.equalTo(@150);
//            //make.bottom.equalTo(@-150);
//            make.centerY.equalTo(self.scrollView);
//            make.width.equalTo(self.scrollView.width);
//            make.height.equalTo(290);
//            //make.height.equalTo(contentView);
//        }];
//        
//        lastView = imageView;
//    }
//    
//    [contentView makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(lastView.right);
//    }];

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.scrollView displayPagingViewAtIndex:self.pageControl.currentPage];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    });
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    int index = fabs(self.scrollView.contentOffset.x) / self.scrollView.frame.size.width;
    self.pageControl.currentPage = index;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)pScrollView
{

}

- (void)imagePressed:(UITapGestureRecognizer *)sender
{
    UIView *view = (UIView*)sender.view;
    DBG_MSG(@"pressed view tag:%ld", view.tag);
    
    if ([self.delegate respondsToSelector:@selector(imagePreViewClick)]) {
        [self.delegate imagePreViewClick];
    }
}


#pragma mark - PZPagingScrollViewDelegate
#pragma mark -

- (Class)pagingScrollView:(PZPagingScrollView *)pagingScrollView classForIndex:(NSUInteger)index {
    // all page views are photo views
    return [PZPhotoView class];
}

- (NSUInteger)pagingScrollViewPagingViewCount:(PZPagingScrollView *)pagingScrollView {
    return self.arImages.count;
}

- (UIView *)pagingScrollView:(PZPagingScrollView *)pagingScrollView pageViewForIndex:(NSUInteger)index {
    PZPhotoView *photoView = [[PZPhotoView alloc] initWithFrame:self.bounds];
    photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    photoView.photoViewDelegate = self;
    
    return photoView;
}

- (void)pagingScrollView:(PZPagingScrollView *)pagingScrollView preparePageViewForDisplay:(UIView *)pageView forIndex:(NSUInteger)index {
    assert([pageView isKindOfClass:[PZPhotoView class]]);
    assert(index < self.arImages.count);
    
    PZPhotoView *photoView = (PZPhotoView *)pageView;
    //UIImage *image = [self.arImages objectAtIndex:index];
    //[photoView displayImage:image];
    NSString *url = [self.arImages objectAtIndex:index];
    [photoView displayImageUrl:url];
    
    
}

- (void)pagingScrollView:(PZPagingScrollView *)pagingScrollView didPageViewForDisplay:(UIView *)pageView forIndex:(NSUInteger)index
{
    self.pageControl.currentPage = index;
}

#pragma mark - PZPhotoViewDelegate
#pragma mark -

- (void)photoViewDidSingleTap:(PZPhotoView *)photoView {
    //[self toggleFullScreen];
    DBG_MSG(@"enter");

    if ([self.delegate respondsToSelector:@selector(imagePreViewClick)]) {
        [self.delegate imagePreViewClick];
    }
}

- (void)photoViewDidDoubleTap:(PZPhotoView *)photoView {
    // do nothing
    DBG_MSG(@"enter");
}

- (void)photoViewDidTwoFingerTap:(PZPhotoView *)photoView {
    // do nothing
    DBG_MSG(@"enter");
}

- (void)photoViewDidDoubleTwoFingerTap:(PZPhotoView *)photoView {
    //[self logLayout];
    DBG_MSG(@"enter");
}

@end
