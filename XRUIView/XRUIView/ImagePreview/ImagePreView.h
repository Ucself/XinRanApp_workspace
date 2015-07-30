//
//  ImagePreView.h
//  XinRanApp
//
//  Created by tianbo on 14-12-30.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "BaseUIView.h"


@protocol ImagePreViewDelegate <NSObject>

-(void)imagePreViewClick;

@end


@interface ImagePreView : BaseUIView <UIScrollViewDelegate>

@property(assign, nonatomic) id delegate;
-(void)loadImages:(NSArray*)images selectIndex:(int)index;
@end
