//
//  FilterFooterView.m
//  XRUIView
//
//  Created by tianbo on 15-4-1.
//  Copyright (c) 2015年 Framework. All rights reserved.
//

#import "FilterFooterView.h"
#import <XRUIView/XRUIView.h>

@implementation FilterFooterView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xe6e6e6);
        
//        self.labelText = [[UILabel alloc] init];
//        self.labelText.backgroundColor = [UIColor orangeColor];
//        self.labelText.textColor = [UIColor lightGrayColor];
//        self.labelText.font = [UIFont systemFontOfSize:15];
//        [self addSubview:self.labelText];
//        
//        [self.labelText makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];
    }
    
    return self;
}
@end
