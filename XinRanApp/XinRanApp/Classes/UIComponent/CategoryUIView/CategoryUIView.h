//
//  CategoryUIView.h
//  XinRanApp
//
//  Created by libj on 15/2/5.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BaseUIView.h"
#import <XRUIView/BaseUIView.h>

@class GoodClass;

typedef void (^dismissBlock)(void);
typedef void (^performToList)(GoodClass *goodClass);

@interface CategoryUIView : BaseUIView

@property (strong,nonatomic) UITableView *categoryUITableView;
@property (strong,nonatomic) NSMutableArray *dataSource;
@property (nonatomic, copy) dismissBlock dismissHandler;
@property (nonatomic, copy) performToList toListHandler;

-(instancetype)initWithData:(CGRect)frame dataSource:(NSMutableArray *)dataSource;
@end
