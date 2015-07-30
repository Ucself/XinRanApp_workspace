//
//  AreaPickerView.m
//  XinRanApp
//
//  Created by tianbo on 14-12-23.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "AreaPickerView.h"


@interface AreaPickerView ()
{
    
    
}

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

//区域数组
@property (strong, nonatomic) NSArray *arProvince;
@property (strong, nonatomic) NSMutableArray *arShowCitys;
@property (strong, nonatomic) NSMutableArray *arShowDistrict;

@end

@implementation AreaPickerView



- (AreaPickerView*)initWithDelegate:(id)delegate areas:(NSArray*)areas
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"AreaPickerView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
        
        if (areas && areas.count > 0) {
            self.arProvince = areas;
            self.arShowCitys = [[areas objectAtIndex:0] objectForKey:@"items"];
            self.arShowDistrict = [[self.arShowCitys objectAtIndex:0] objectForKey:@"items"];
        }
        
    }
    
    return self;
}

-(void)dealloc
{
    self.arProvince = nil;
    self.arShowCitys = nil;
    self.arShowDistrict = nil;
    self.selArea = nil;
}

-(void)setSelArea:(Areas *)selArea
{
    _selArea = selArea;
    
    //定位到当前选中区域
    BOOL bBreak = NO;
    for (int i=0; i<self.arProvince.count; i++) {
        
        NSDictionary *dictProvince = [self.arProvince objectAtIndex:i];
        //Areas *province = [dictProvince objectForKey:@"area"];
        NSArray *arCitys = [dictProvince objectForKey:@"items"];
        
        for (int j=0; j<arCitys.count; j++) {
            NSDictionary *dictCity = [arCitys objectAtIndex:j];
            //Areas *city = [dictCity objectForKey:@"area"];
            NSArray *arDistrict = [dictCity objectForKey:@"items"];
            
            for (int k=0; k<arDistrict.count; k++) {
                Areas *district = [arDistrict objectAtIndex:k];
                if ([district.Id isEqualToString:selArea.Id]) {

                    self.arShowCitys = [NSMutableArray arrayWithArray:arCitys];
                    self.arShowDistrict = [NSMutableArray arrayWithArray:arDistrict];
                    if ([self.pickerView selectedRowInComponent:0] != i) {
                        [self.pickerView selectRow:i inComponent:0 animated:YES];
                        [self.pickerView reloadComponent:0];
                    }
                    if ([self.pickerView selectedRowInComponent:1] != j) {
                        [self.pickerView selectRow:j inComponent:1 animated:YES];
                        [self.pickerView reloadComponent:1];
                    }
                    if ([self.pickerView selectedRowInComponent:2] != k) {
                        [self.pickerView selectRow:k inComponent:2 animated:YES];
                        [self.pickerView reloadComponent:2];
                    }
                    bBreak = YES;
                    break;
                }
            }
            
            if (bBreak) {
                break;
            }
        }
        
        if (bBreak) {
            break;
        }
    }


    [self.pickerView reloadAllComponents];
}

- (IBAction)btnOkClick:(id)sender {
    
    Areas *sel = nil;
    if (self.arShowDistrict && self.arShowDistrict.count>0) {
        int selIndex = (int)[self.pickerView selectedRowInComponent:2];
        sel = (Areas*)[self.arShowDistrict objectAtIndex:selIndex];
    }
    else {  //如果没有区,返回城市
        int selIndex = (int)[self.pickerView selectedRowInComponent:1];
        sel = (Areas*)[[self.arShowCitys objectAtIndex:selIndex] objectForKey:@"area"];
    }
    
    
    
    if ([self.delegate respondsToSelector:@selector(pickerViewOK:)]) {
        [self.delegate pickerViewOK:sel];
    }
    
}


- (IBAction)btnCancelClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pickerViewCancel)]) {
        [self.delegate pickerViewCancel];
    }
}


#pragma mark - PickerView delegate
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
//            Areas *area = [[self.arProvince objectAtIndex:row] objectForKey:@"area"];
//            string = area.name;
//        }
//            break;
//        case 1:
//        {
//            Areas *area = [[self.arShowCitys objectAtIndex:row] objectForKey:@"area"];
//            string = area.name;
//        }
//            break;
//        case 2:
//        {
//            Areas *area = [self.arShowDistrict objectAtIndex:row];
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
            Areas *area = [[self.arProvince objectAtIndex:row] objectForKey:@"area"];
            string = area.name;
        }
            break;
        case 1:
        {
            Areas *area = [[self.arShowCitys objectAtIndex:row] objectForKey:@"area"];
            string = area.name;
        }
            break;
        case 2:
        {
            Areas *area = [self.arShowDistrict objectAtIndex:row];
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
            self.arShowCitys = [[self.arProvince objectAtIndex:row] objectForKey:@"items"];
            [self.pickerView reloadComponent:1];
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
            
            self.arShowDistrict = [[self.arShowCitys objectAtIndex:0] objectForKey:@"items"];
            [self.pickerView reloadComponent:2];
            [self.pickerView selectRow:0 inComponent:2 animated:YES];
            
        }
            break;
        case 1:
        {
            self.arShowDistrict = [[self.arShowCitys objectAtIndex:row] objectForKey:@"items"];
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
