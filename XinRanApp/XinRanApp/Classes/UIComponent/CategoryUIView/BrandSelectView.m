//
//  BrandSelectView.m
//  XinRanApp
//
//  Created by tianbo on 15-2-6.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "BrandSelectView.h"
#import "Brand.h"
#import "BrandTableViewCell.h"

@interface BrandSelectView ()<UITableViewDataSource, UITableViewDelegate>{

}



@end

@implementation BrandSelectView

-(instancetype)initWithData:(CGRect)frame dataSource:(NSMutableArray *)dataSource{
    
    if(self = [super initWithFrame:frame]){
        //设置数据源
        self.dataSource = dataSource;
        //加载界面
        [self initializeInterface];
    }
    return self;
}

- (void) initializeInterface{
    //设置为透明色
    [self setBackgroundColor:[UIColor clearColor]];//[UIColor colorWithWhite:0.0 alpha:0.7]];
    //中间放一个view
    UIView *viewMain= [UIView new];
    viewMain.tag = 101;
    [viewMain setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:viewMain];
    
    [viewMain makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.equalTo(self.left).offset(50);
        make.bottom.equalTo(self.bottom);
        make.right.equalTo(self.right);
    }];
    //名称
    UILabel *label = [UILabel new];
    label.text = @"品牌筛选";
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont fontWithName:nil size:15]];
    [viewMain addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewMain.top).offset(30);
        make.left.equalTo(viewMain.left);
        make.right.equalTo(viewMain.right);
        make.height.equalTo(30);
    }];
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnClose setTitle:@"" forState:UIControlStateNormal];
    [self addSubview:btnClose];
    [btnClose makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(50);
        make.height.equalTo(30);
        make.right.equalTo(viewMain.right).offset(-5);
        make.centerY.equalTo(label);
    }];
//    UIImageView *imageViewClose = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_category_close"]];
    UIImageView *imageViewClose = [[UIImageView alloc] initWithFrame:CGRectMake(17, 8, 15, 15)];
    [imageViewClose setImage:[UIImage imageNamed:@"brand_close"]];
    [btnClose addSubview:imageViewClose];
    [btnClose addTarget:self action:@selector(closeBrand:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //设置tableView的相关数据
    if(!self.tableView){
        self.tableView = [[UITableView alloc] init];
    }
    [self addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //设置tableView的布局
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.bottom);
        make.right.equalTo(viewMain.right);
        make.bottom.equalTo(viewMain.bottom);
        make.left.equalTo(viewMain.left);
    }];
    //添加手势右滑动关闭
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeBrand:)];
    [self addGestureRecognizer:rightSwipe];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    UIView *viewMain = [self viewWithTag:101];
    if (viewMain) {
        viewMain.layer.shadowPath = [[UIBezierPath bezierPathWithRect:viewMain.bounds] CGPath];
        viewMain.layer.shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.9].CGColor;
        viewMain.layer.shadowOffset = CGSizeMake(0, 3);
        viewMain.layer.shadowOpacity = 0.6;
        viewMain.layer.shadowRadius = 3.0;
    }
}

//动画关闭Brand
-(void) closeBrand:(id)sender{
    //关闭前取消背景色
    
    //手势与点击X按钮不延迟关闭
    float delayTime = 0.0;
    if(sender == nil){
        delayTime = 0.5;
    }else{
        [self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    }
    
    [UIView animateWithDuration:0.2
                          delay:delayTime
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self setFrame:CGRectMake(deviceWidth, 0, deviceWidth, deviceHeight)];
                     }
                     completion:nil];
}
#pragma mark ---<UITableViewDelegate>
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)sectio{
    return 1;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    //取消所有选中
    for (int i=0; i<_dataSource.count; i++) {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        BrandTableViewCell *tempCell = (BrandTableViewCell *)[tableView cellForRowAtIndexPath:tempIndexPath];
        //全部设置为未选中
        [tempCell setIsSelected:YES];
    }
    
    //设置当前选中的cell
    BrandTableViewCell *cell = (BrandTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setIsSelected:cell.isSelected];
    //选中的数据传输出去
    if(_viewSelectedBrandHandler){
        _viewSelectedBrandHandler(((Brand*)_dataSource[indexPath.row]).Id);
    }
    //重新加载数据，然后关闭筛选
    [self closeBrand:nil];
}

#pragma mark ---<UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"CellSelect";
    BrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[BrandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    Brand *brand = [self.dataSource objectAtIndex:indexPath.row];
    
    cell.lableName.text = brand.name;
    if ([brand.Id isEqualToString:_stringSelectId]) {
        [cell.imageViewIcon setImage:[UIImage imageNamed:@"brand_selected"]];
    }
    else{
        [cell.imageViewIcon setImage:[UIImage imageNamed:@"brand_not_selected"]];
    }
    return cell;
}




@end
