//
//  FilterView.h
//  XRUIView
//
//  Created by tianbo on 15-4-1.
//  Copyright (c) 2015年 Framework. All rights reserved.
//

#import <XRUIView/XRUIView.h>

#define KCategoryArray  @"CategoryArray"
#define KBrandArray     @"BrandArray"

@class FilterView;
@protocol FilterViewDelegate <NSObject>

-(void)filterView:(FilterView*)filterView categoryIndex:(int)categoryIndex brandIndex:(int)brandIndex;
-(void)filterViewCancel:(FilterView*)filterView;
@end


@interface FilterView : BaseUIView
{
    
}
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, assign) int categoryIndex;
@property(nonatomic, assign) int brandIndex;

@property(nonatomic, copy) NSArray *arCategory;
@property(nonatomic, copy) NSArray *arBrand;

@property(nonatomic, assign) id delegate;

-(instancetype) initWithConditionData:(NSDictionary*)condition;

@end


