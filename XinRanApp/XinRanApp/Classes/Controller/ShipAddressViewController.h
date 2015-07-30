//
//  ShipAddressViewController.h
//  XinRanApp
//
//  Created by libj on 15/4/24.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "BaseUIViewController.h"


@interface ShipAddressViewController : BaseUIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *adressTextField;
@property (weak, nonatomic) IBOutlet UITextView *detailAdressTextView;
@property (weak, nonatomic) IBOutlet UITextField *tellphoneTextField;

@property (weak, nonatomic) IBOutlet UILabel *textViewTips;

@end
