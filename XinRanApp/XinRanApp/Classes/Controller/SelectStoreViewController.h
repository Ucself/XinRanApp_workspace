//
//  SelectStoreViewController.h
//  XinRanApp
//
//  Created by tianbo on 14-12-22.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "BaseUIViewController.h"
//#import "AreaPickerView.h"
#import <XRUIView/AreaPickerView.h>
#import "Areas.h"

@protocol SelectStoreViewControllerDelegate <NSObject>

-(void)selectStoreView:(id)selWhouse;

@end


@interface SelectStoreViewController : BaseUIViewController<AreaPickerViewDelegate>

@property(nonatomic, assign) id delegate;
@property(nonatomic, strong) NSArray *arRelationStoreIds;
@property(nonatomic, assign) BOOL isShowRemainds;
@property(nonatomic, assign) BOOL isReturnRoot;

//当前选中区域
@property (strong, nonatomic) Areas *selArea;

@end
