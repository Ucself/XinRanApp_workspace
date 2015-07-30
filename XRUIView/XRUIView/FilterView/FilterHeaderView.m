//
//  FilterHeaderView.m
//  XRUIView
//
//  Created by tianbo on 15-4-1.
//  Copyright (c) 2015年 Framework. All rights reserved.
//

#import "FilterHeaderView.h"
#import <XRUIView/XRUIView.h>

@implementation FilterHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.labelText = [[UILabel alloc] init];
        self.labelText.backgroundColor = [UIColor clearColor];
        self.labelText.textColor = [UIColor darkGrayColor];
        self.labelText.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.labelText];
        
        [self.labelText makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        self.labelTips = [[UILabel alloc] init];
        self.labelTips.backgroundColor = [UIColor clearColor];
        self.labelTips.textColor = [UIColor darkGrayColor];
        self.labelTips.font = [UIFont systemFontOfSize:15];
        self.labelTips.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.labelTips];
        
        [self.labelTips makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = UIColorFromRGB(0xe6e6e6);
        line.tag = 123;
        [self addSubview:line];
        
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.bottom.equalTo(self);
            make.height.equalTo(1);
            make.right.equalTo(self).offset(-15);
        }];
    }
    
    return self;
}

-(void)setHiddenLine:(BOOL)hiddenLine
{
    UIView *view = [self viewWithTag:123];
    if (view) {
        view.hidden = hiddenLine;
    }
}

@end
