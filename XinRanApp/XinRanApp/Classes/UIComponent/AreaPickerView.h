//
//  AreaPickerView.h
//  XinRanApp
//
//  Created by tianbo on 14-12-23.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIView.h"

#import <XRDataModel/Areas.h>

@class AreaPickerView;
@protocol AreaPickerViewDelegate <NSObject>

- (void)pickerViewDidChange:(AreaPickerView *)picker;
- (void)pickerViewCancel;
- (void)pickerViewOK:(Areas*)area;

@end

@interface AreaPickerView : BaseUIView

@property(nonatomic, assign) id delegate;
//当前选中的区id
@property (strong, nonatomic) Areas *selArea;

- (AreaPickerView*)initWithDelegate:(id)delegate areas:(NSArray*)areas;
- (void)showInView:(UIView *)view;
- (void)cancelPicker:(UIView *)view;
@end
