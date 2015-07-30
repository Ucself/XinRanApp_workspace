//
//  FilterCollectionViewCell.m
//  XRUIView
//
//  Created by tianbo on 15-4-1.
//  Copyright (c) 2015年 Framework. All rights reserved.
//

#import "FilterCollectionViewCell.h"
#import <XRUIView/XRUIView.h>

@implementation FilterCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.labelText = [[UILabel alloc] init];
        self.labelText.backgroundColor = [UIColor clearColor];
        self.labelText.textColor = [UIColor lightGrayColor];
        self.labelText.font = [UIFont systemFontOfSize:14];
        self.labelText.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.labelText];
        
        [self.labelText makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    return self;
}

-(void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    if (isSelect) {
        self.labelText.textColor = [UIColor orangeColor];
        self.layer.borderWidth=0.5;
        self.layer.borderColor=[UIColor orangeColor].CGColor;
    }
    else {
        self.labelText.textColor = [UIColor lightGrayColor];
        self.layer.borderWidth=0.0;
        self.layer.borderColor=[UIColor clearColor].CGColor;
    }
}
@end
