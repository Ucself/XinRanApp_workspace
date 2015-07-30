//
//  UIImage+bundle.m
//  Purchase
//
//  Created by Mark on 13-8-28.
//  Copyright (c) 2013年 tianbo. All rights reserved.
//

#import "UIImage+bundle.h"

@implementation UIImage (bundle)

+(UIImage*) imagesNamedFromBundle:(NSString *)name
{
    NSString *imageName = [NSString stringWithFormat: @"%@/%@",
                           @"XRUIView.bundle",
                           name];
    
    return [UIImage imageNamed:imageName];
}
@end
