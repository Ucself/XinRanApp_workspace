//
//  SegmentedUIView.m
//  XibTableViewTest
//
//  Created by libj on 15/1/13.
//  Copyright (c) 2015年 libj. All rights reserved.
//

#import "SegmentedUIView.h"
#import "SingleUIView.h"
#import "UIImage+bundle.h"
#import "UIView+bundle.h"

#define segmentedStartTag  111
@interface SegmentedUIView () <SingleUIViewDelegate>{

    //一项的宽度
    float elementWith;
}

@end

@implementation SegmentedUIView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//-(void) layoutSubviews{
//    
//    if(segmentSystemVersion >= 8.0){
//        //调用父布局
//        [super layoutSubviews];
//        //加载界面
//        [self initInterface];
//    }
//    else{
//        //加载界面
//        [self initInterface];
//        //调用父布局
//        [super layoutSubviews];
//        
//    }
//}

-(SegmentedUIView *)init
{
    self = (SegmentedUIView *)[UIView uiViewFromBundle:@"SegmentedUIView"];;
    if (self) {
        
    }
    
    return self;
}

-(void)updateConstraints{
    [super updateConstraints];
}

#pragma mark --- 自定义方法

//加载界面信息
-(void) initInterface {
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    
    //数据元素个数
    NSInteger count = 0;
    
    if ([self.delegate respondsToSelector:@selector(numberOfData)]) {
        count = [self.delegate numberOfData];
    }
    //没有数据直接返回
    if (count == 0) {
        return;
    }
    if (count>5) {
        //大于4个的情况
        elementWith = self.bounds.size.width/4.0;
    }
    else if(count>0){
        elementWith = self.bounds.size.width/count;
        //大于0个小于4个的情况，设置不可滑动
        [self.mainUIScrollView setScrollEnabled:NO];
        
    }
    //设置容器的大小
    [self.mainUIScrollView setContentSize:CGSizeMake(elementWith*count, self.mainUIScrollView.bounds.size.height)];
    //临时视图
    UIView *tempUIView=nil;
    
    for (int i=0; i < count; i++) {
        //根据tag查找控件
        SingleUIView *singleUIView = (SingleUIView *)[self viewWithTag:segmentedStartTag+i];
        //如果不存在则新创建一个
        if (!singleUIView) {
//            singleUIView = [[[NSBundle mainBundle] loadNibNamed:@"SingleUIView" owner:self options:nil] objectAtIndex:0];
            singleUIView = (SingleUIView *)[UIView uiViewFromBundle:@"SingleUIView"];
            
            if ([self.delegate respondsToSelector:@selector(stringForIndex:)]) {
                [singleUIView.titleUITitle setText:[self.delegate stringForIndex:i]];
            }
            singleUIView.index = i;
            //设置targ
            singleUIView.tag = segmentedStartTag + i;
            //设置代理协议
            singleUIView.delegate = self;
            //添加点击事件
            [self.mainUIScrollView addSubview:singleUIView];
            
            [singleUIView makeConstraints:^(MASConstraintMaker *make) {
                if (tempUIView==nil) {
                    make.left.equalTo(0);
                }
                else{
                    make.left.equalTo(tempUIView.right);
                }
                make.width.equalTo(elementWith);
                make.top.equalTo(0);
                make.height.equalTo(_mainUIScrollView.height);
            }];
            tempUIView = singleUIView;
            //设置子视图的约束
            [singleUIView initInterface];
        }
    }
    if(!_selectedImageView){
    
        _selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imagesNamedFromBundle:@"Selected"]];
    }
    //添加图标
    [self.mainUIScrollView addSubview:_selectedImageView];
    //设置传入的为选中
    [self setSelectedImageViewOfIndex:self.selectedIndex];
    
}
//外部设置选中项
-(void) setSelectedImageViewOfIndex:(int)index{
    //其他颜色设置问空
    for (UIView *subView in self.mainUIScrollView.subviews) {
        if ([subView isKindOfClass:[SingleUIView class]]) {
            UILabel *titleUITitle = ((SingleUIView *)subView).titleUITitle;
            [titleUITitle setTextColor:[UIColor colorWithRed:175.0/255.0 green:175.0/255.0 blue:175.0/255.0 alpha:1.0]];
            //设置箭头全部消失
            UIImageView *sortImageView = ((SingleUIView *)subView).sortImageView;
            [sortImageView setHidden:YES];
        }
    }
    //根据tag查找控件
    SingleUIView *singleUIView = (SingleUIView *)[self viewWithTag:segmentedStartTag+index];
    //设置图标是否显示
    UIImage *img = [self.delegate segmentedUIView:index];
    singleUIView.sortImageView.image = img;
    if (img) {
        [singleUIView.sortImageView setHidden:NO];
    }
    [singleUIView.titleUITitle setTextColor:[UIColor colorWithRed:58.0/255.0 green:180.0/255.0 blue:156.0/255.0 alpha:1.0]];
//    [singleUIView setBackgroundColor:[UIColor redColor]];
    //设置当前选中的index
    self.selectedIndex = index;
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        _selectedImageView.frame = CGRectMake(self.selectedIndex * elementWith, self.mainUIScrollView.bounds.size.height-15, elementWith, 15);
//        DBG_MSG(@"_selectedImageView===%@",_selectedImageView);
    }];
}

-(int) getSelectedIndex
{
    return self.selectedIndex;
}
//设置当前是否向上
-(void)setCurrentIndexIsUp:(BOOL)isUp{
    if(self.selectedIndex != 4)
    {
        //对品牌筛选起作用
        return;
    }
    SingleUIView *singleUIView = (SingleUIView *)[self viewWithTag:segmentedStartTag + self.selectedIndex];
    [singleUIView setIsUp:isUp];
}
#pragma mark --- <SingleUIViewDelegate>

- (void)singleUIView:(SingleUIView *)singleUIView  isUp:(BOOL)isUp{
    //设置选中index
    self.selectedIndex = singleUIView.index;
    [self setSelectedImageViewOfIndex:singleUIView.index];
    //执行外部协议
    if ([self.delegate respondsToSelector:@selector(segmentedUIView:didSelectRowAtIndexPath:sortType:)]) {
        if (isUp&&[self.delegate segmentedUIView:singleUIView.index]) {
            [self.delegate segmentedUIView:self didSelectRowAtIndexPath:singleUIView.index  sortType:SegmentedSortTypeUp];
        }
        else{

            [self.delegate segmentedUIView:self didSelectRowAtIndexPath:singleUIView.index  sortType:SegmentedSortTypeDrop];
        }
    }
    //第二个协议
    if ([self.delegate respondsToSelector:@selector(segmentedUIView:didSelectSortAtIndexPath:sortType:)]) {
        [self.delegate segmentedUIView:self didSelectSortAtIndexPath:singleUIView.index sortType:SegmentedSortTypeUp];
    }
}

@end
















