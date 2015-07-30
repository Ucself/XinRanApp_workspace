//
//  FilterHeaderView.h
//  XRUIView
//
//  Created by tianbo on 15-4-1.
//  Copyright (c) 2015年 Framework. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterHeaderView : UICollectionReusableView
@property(nonatomic, strong) UILabel *labelText;
@property(nonatomic, strong) UILabel *labelTips;
@property(nonatomic, assign) BOOL hiddenLine;
@end
