//
//  CategoryUIView.m
//  XinRanApp
//
//  Created by libj on 15/2/5.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "CategoryUIView.h"
#import <XRDataModel/GoodClass.h>

@interface CategoryUIView ()<UITableViewDelegate,UITableViewDataSource>
{


}

@end


@implementation CategoryUIView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithData:(CGRect)frame dataSource:(NSMutableArray *)dataSource{
    
    if(self = [super initWithFrame:frame]){
        //设置数据源
        self.dataSource = dataSource;
        //加载界面
        [self initializeInterface];

    }
    return self;
}
//布局布局更改的时候调用
//-(void)layoutSubviews{
//
//}

//-(void)drawRect:(CGRect)rect{
//
//}

#pragma mark --- custom methods

- (void) initializeInterface{
    
    self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];
    self.layer.shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.9].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowOpacity = 0.6;
    self.layer.shadowRadius = 3.0;
    
    //设置为透明色
    [self setBackgroundColor:[UIColor whiteColor]];//[UIColor colorWithWhite:1.0 alpha:0.1]];
    //设置tableView的相关数据
    if(!_categoryUITableView){
        self.categoryUITableView = [[UITableView alloc] init];
    }
    [self addSubview:_categoryUITableView];
    self.categoryUITableView.delegate = self;
    self.categoryUITableView.dataSource = self;
    //设置tableView的布局
    [_categoryUITableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.right.equalTo(self.right);
        make.bottom.equalTo(self.bottom);
        make.left.equalTo(self.left);
    }];
    
    [_categoryUITableView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.9]];
}
//点击空白处隐藏菜单
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

    if (_dismissHandler) {
        _dismissHandler();
    }
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
    
    GoodClass *goodClass = (GoodClass *)[_dataSource objectAtIndex:indexPath.row];
    //控制器跳转
    if (_toListHandler) {
        _toListHandler(goodClass);
    }
    //分类隐藏
    if (_dismissHandler) {
        _dismissHandler();
    }
}
#pragma mark ---<UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"CellCategory";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    GoodClass *goodClass =[self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.text = goodClass.name;
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    //消除背景色
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel  setBackgroundColor:[UIColor clearColor]];
    return cell;
}

@end














