//
//  BrandSelectView.h
//  XinRanApp
//
//  Created by tianbo on 15-2-6.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//
//  品牌筛选View

#import "BaseUIView.h"

typedef void (^viewSelectedBrand)(NSString *string);

@interface BrandSelectView : BaseUIView

@property (strong,nonatomic) NSMutableArray *dataSource;
@property (strong,nonatomic) NSString *stringSelectId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) viewSelectedBrand viewSelectedBrandHandler;

-(instancetype)initWithData:(CGRect)frame dataSource:(NSMutableArray *)dataSource;
@end
