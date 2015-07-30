//
//  AreaPickerView.h
//  XinRanApp
//
//  Created by tianbo on 14-12-23.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIView.h"

@interface Area: NSObject

@property(nonatomic, strong) NSString *Id;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *pId;     //上级id
@end

@class AreaPickerView;
@protocol AreaPickerViewDelegate <NSObject>

- (void)pickerViewDidChange:(AreaPickerView *)picker;
- (void)pickerViewCancel;
- (void)pickerViewOK:(Area*)province city:(Area*)city district:(Area*)district;

@end

@interface AreaPickerView : BaseUIView

@property(nonatomic, assign) id delegate;

- (AreaPickerView*)initWithDelegate:(id)delegate areas:(NSArray*)areas;
- (AreaPickerView*)initWithDelegate:(id)delegate arProvince:(NSArray*)arProvince arCity:(NSArray*)arCity arDistrict:(NSArray*)arDistrict;
- (void)showInView:(UIView *)view;
- (void)cancelPicker:(UIView *)view;

-(void)setAreas:(id)province city:(id)city district:(id)district;
@end
