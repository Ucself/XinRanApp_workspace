//
//  AreaPickerView.m
//  XinRanApp
//
//  Created by tianbo on 14-12-23.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "AreaPickerView.h"
#import "UIView+bundle.h"

@implementation Area



@end

@interface AreaPickerView ()
{
    
    
}

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

//区域数组
@property (strong, nonatomic) NSArray *arProvince;
@property (strong, nonatomic) NSArray *arCitys;
@property (strong, nonatomic) NSArray *arDistrict;

//显示的城市的区域
@property (strong, nonatomic) NSMutableArray *arShowCitys;
@property (strong, nonatomic) NSMutableArray *arShowDistrict;

@end

@implementation AreaPickerView



- (AreaPickerView*)initWithDelegate:(id)delegate Area:(NSArray*)Area
{
    //self = [[[NSBundle mainBundle] loadNibNamed:@"AreaPickerView" owner:self options:nil] objectAtIndex:0];
    self = (AreaPickerView *)[UIView uiViewFromBundle:@"AreaPickerView"];;
    if (self) {
        self.delegate = delegate;
        
//        if (Area && Area.count > 0) {
//            self.arProvince = Area;
//            self.arShowCitys = [[Area objectAtIndex:0] objectForKey:@"items"];
//            self.arShowDistrict = [[self.arShowCitys objectAtIndex:0] objectForKey:@"items"];
//        }
        
    }
    
    return self;
}

- (AreaPickerView*)initWithDelegate:(id)delegate arProvince:(NSArray*)arProvince arCity:(NSArray*)arCity arDistrict:(NSArray*)arDistrict
{
    self = (AreaPickerView *)[UIView uiViewFromBundle:@"AreaPickerView"];;
    if (self) {
        self.delegate = delegate;
        
        self.arProvince = arProvince;
        self.arCitys = arCity;
        self.arDistrict = arDistrict;
        
        self.arShowCitys = [self arShowCityWithArea:[self.arProvince objectAtIndex:0]];
        self.arShowDistrict = [self arShowDistrictArea:[self.arCitys objectAtIndex:0]];
    }
    
    return self;
}

-(void)dealloc
{
    self.arProvince = nil;
    self.arCitys = nil;
    self.arDistrict = nil;
    
    self.arShowCitys = nil;
    self.arShowDistrict = nil;

}

//显示的数组
-(NSMutableArray*)arShowCityWithArea:(Area*)area
{
    if (!area || !area.pId || area.pId.length == 0) {
        return nil;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    
    for (Area *temp in self.arCitys) {
        if ([area.Id isEqualToString:temp.pId]) {
            [array addObject:temp];
        }
    }
    return array;
}

-(NSMutableArray*)arShowDistrictArea:(Area*)area
{
    if (!area || !area.pId || area.pId.length == 0) {
        return nil;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    
    for (Area *temp in self.arDistrict) {
        if ([area.Id isEqualToString:temp.pId]) {
            [array addObject:temp];
        }
    }
    return array;
}

-(void)setAreas:(id)province city:(id)city district:(id)district
{
    if (!province) {
        return;
    }
    
    Area *p = nil;
    Area *aProvince = (Area*)province;
    for (int i=0; i<self.arProvince.count; i++) {
        p = [self.arProvince objectAtIndex:i];
        if ([p.Id isEqualToString:aProvince.Id]) {
            if ([self.pickerView selectedRowInComponent:0] != i) {
                [self.pickerView selectRow:i inComponent:0 animated:YES];
                [self.pickerView reloadComponent:0];
            }
            
            break;
        }
    }
    
    self.arShowCitys = [self arShowCityWithArea:p];
    Area *c = nil;
    Area *aCity = (Area*)city;
    for (int i=0; i<self.arShowCitys.count; i++) {
        c = [self.arShowCitys objectAtIndex:i];
        if ([c.Id isEqualToString:aCity.Id]) {
            if ([self.pickerView selectedRowInComponent:1] != i) {
                [self.pickerView selectRow:i inComponent:1 animated:YES];
                [self.pickerView reloadComponent:1];
            }
            
            break;
        }
    }
    
    self.arShowDistrict = [self arShowDistrictArea:c];
    Area *aDistrict = (Area*)district;
    for (int i=0; i<self.arShowDistrict.count; i++) {
        Area *d = [self.arShowDistrict objectAtIndex:i];
        if ([d.Id isEqualToString:aDistrict.Id]) {
            if ([self.pickerView selectedRowInComponent:2] != i) {
                [self.pickerView selectRow:i inComponent:2 animated:YES];
                [self.pickerView reloadComponent:2];
            }
            
            break;
        }
    }
    
    
    [self.pickerView reloadAllComponents];
}

//-(void)setSelArea:(Area *)selArea
//{
//    _selArea = selArea;

    //定位到当前选中区域
//    BOOL bBreak = NO;
//    for (int i=0; i<self.arProvince.count; i++) {
//        
//        NSDictionary *dictProvince = [self.arProvince objectAtIndex:i];
//        //Area *province = [dictProvince objectForKey:@"area"];
//        NSArray *arCitys = [dictProvince objectForKey:@"items"];
//        
//        for (int j=0; j<arCitys.count; j++) {
//            NSDictionary *dictCity = [arCitys objectAtIndex:j];
//            //Area *city = [dictCity objectForKey:@"area"];
//            NSArray *arDistrict = [dictCity objectForKey:@"items"];
//            
//            for (int k=0; k<arDistrict.count; k++) {
//                Area *district = [arDistrict objectAtIndex:k];
//                if ([district.Id isEqualToString:selArea.Id]) {
//
//                    self.arShowCitys = [NSMutableArray arrayWithArray:arCitys];
//                    self.arShowDistrict = [NSMutableArray arrayWithArray:arDistrict];
//                    if ([self.pickerView selectedRowInComponent:0] != i) {
//                        [self.pickerView selectRow:i inComponent:0 animated:YES];
//                        [self.pickerView reloadComponent:0];
//                    }
//                    if ([self.pickerView selectedRowInComponent:1] != j) {
//                        [self.pickerView selectRow:j inComponent:1 animated:YES];
//                        [self.pickerView reloadComponent:1];
//                    }
//                    if ([self.pickerView selectedRowInComponent:2] != k) {
//                        [self.pickerView selectRow:k inComponent:2 animated:YES];
//                        [self.pickerView reloadComponent:2];
//                    }
//                    bBreak = YES;
//                    break;
//                }
//            }
//            
//            if (bBreak) {
//                break;
//            }
//        }
//        
//        if (bBreak) {
//            break;
//        }
//    }


//    [self.pickerView reloadAllComponents];
//}

- (IBAction)btnOkClick:(id)sender {
    Area *province = nil;
    Area *city = nil;
    Area *district = nil;
    int selIndex = (int)[self.pickerView selectedRowInComponent:0];
    province = (Area*)[self.arProvince objectAtIndex:selIndex];

    if (self.arShowDistrict && self.arShowDistrict.count>0) {
        
        int selIndex = (int)[self.pickerView selectedRowInComponent:1];
        city = [self.arShowCitys objectAtIndex:selIndex];

        
        selIndex = (int)[self.pickerView selectedRowInComponent:2];
        district = (Area*)[self.arShowDistrict objectAtIndex:selIndex];

    }
    else {  //如果没有区,返回城市
        int selIndex = (int)[self.pickerView selectedRowInComponent:1];
        if (self.arShowCitys && self.arShowCitys.count != 0) {
            city = (Area*)[self.arShowCitys objectAtIndex:selIndex];
        }
        
    }
    
    
    
    if ([self.delegate respondsToSelector:@selector(pickerViewOK:city:district:)]) {
        [self.delegate pickerViewOK:province city:city district:district];
    }
    
}


- (IBAction)btnCancelClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pickerViewCancel)]) {
        [self.delegate pickerViewCancel];
    }
}


#pragma mark - PickerView delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return self.arProvince.count;
            break;
        case 1:
            return self.arShowCitys.count;
            break;
        case 2:
            return self.arShowDistrict.count;
            break;
        default:
            break;
    }
    
    return 0;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    NSString *string = @"";
//    switch (component) {
//        case 0:
//        {
//            Area *area = [[self.arProvince objectAtIndex:row] objectForKey:@"area"];
//            string = area.name;
//        }
//            break;
//        case 1:
//        {
//            Area *area = [[self.arShowCitys objectAtIndex:row] objectForKey:@"area"];
//            string = area.name;
//        }
//            break;
//        case 2:
//        {
//            Area *area = [self.arShowDistrict objectAtIndex:row];
//            string = area.name;
//        }
//            break;
//        default:
//            break;
//    }
//
//    return string;
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = view ? (UILabel *) view : [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:17]];
    label.textAlignment = NSTextAlignmentCenter;
    //label.backgroundColor = [UIColor redColor];
    
    NSString *string = @"";
    switch (component) {
        case 0:
        {
            Area *area = [self.arProvince objectAtIndex:row];
            string = area.name;
        }
            break;
        case 1:
        {
            Area *area = [self.arShowCitys objectAtIndex:row];
            string = area.name;
        }
            break;
        case 2:
        {
            Area *area = [self.arShowDistrict objectAtIndex:row];
            string = area.name;
        }
            break;
        default:
            break;
    }
    label.text = string;

    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            self.arShowCitys = [self arShowCityWithArea:[self.arProvince objectAtIndex:row]];//[[self.arProvince objectAtIndex:row] objectForKey:@"items"];
            [self.pickerView reloadComponent:1];
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
            
            if (self.arShowCitys && self.arShowCitys.count != 0) {
                self.arShowDistrict = [self arShowDistrictArea:[self.arShowCitys objectAtIndex:0]];//[[self.arShowCitys objectAtIndex:0] objectForKey:@"items"];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
            }
            else {
                self.arShowDistrict = nil;
            }
            
            [self.pickerView reloadComponent:2];
            [self.pickerView selectRow:0 inComponent:2 animated:YES];
        }
            break;
        case 1:
        {
            self.arShowDistrict = [self arShowDistrictArea:[self.arShowCitys objectAtIndex:row]];
            [self.pickerView reloadComponent:2];
            [self.pickerView selectRow:0 inComponent:2 animated:YES];
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
    
    
//    if([self.delegate respondsToSelector:@selector(pickerViewDidChange:)]) {
//        [self.delegate pickerViewDidChange:self];
//    }
}

- (void)showInView:(UIView *) view
{
    self.tag = 111;
    if ([view viewWithTag:111]) {
        return;
    }
    
    [view addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.width.equalTo(view);
        make.top.equalTo(view.bottom);
        make.height.equalTo(@220);
    }];
    [view layoutIfNeeded];
    
    [UIView animateWithDuration:0.4 animations:^{
        
        [self remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.width.equalTo(view);
            make.top.equalTo(view.bottom).offset(-220);
            make.height.equalTo(@220);
        }];
        
        [view layoutIfNeeded];
    }];

}

- (void)cancelPicker:(UIView *) view
{
    //包含视图再设置取消
    if (![view viewWithTag:111]) {
        return;
    }
    [UIView animateWithDuration:0.4 animations:^{
        
                         [self remakeConstraints:^(MASConstraintMaker *make) {
                             make.left.equalTo(0);
                             make.width.equalTo(view);
                             make.top.equalTo(view.bottom);
                             make.height.equalTo(@220);
                         }];
                         
                         [view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
     }];
}

@end
