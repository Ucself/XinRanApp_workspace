//
//  WoUIView+bundle.m
//  XRUIView
//
//  Created by libj on 15/3/30.
//  Copyright (c) 2015年 Framework. All rights reserved.
//

#import "UIView+bundle.h"

@implementation UIView (bundle)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(UIView*) uiViewFromBundle:(NSString *)name{
    
    NSBundle *bundle= [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"XRUIView" withExtension:@"bundle"]];
    
    return [[bundle loadNibNamed:name owner:self options:nil] objectAtIndex:0];

}

@end
