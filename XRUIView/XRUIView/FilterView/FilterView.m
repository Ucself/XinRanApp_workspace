//
//  FilterView.m
//  XRUIView
//
//  Created by tianbo on 15-4-1.
//  Copyright (c) 2015年 Framework. All rights reserved.
//

#import "FilterView.h"
#import "FilterCollectionViewCell.h"
#import "FilterHeaderView.h"
#import "FilterFooterView.h"


#define identifyCell    @"identifyCell"
#define identifyHeader  @"identifyheader"
#define identifyFooter  @"identifyfooter"

@interface FilterView () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    CGSize contentSize;
}

@end

@implementation FilterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)dealloc
{
    self.arCategory = nil;
    self.arBrand = nil;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

-(instancetype) initWithConditionData:(NSDictionary*)condition
{
    self  = [super init];
    if (self) {
        self.arCategory = [condition objectForKey:KCategoryArray];
        self.arBrand = [condition objectForKey:KBrandArray];
        
        self.categoryIndex = -1;
        self.brandIndex = -1;
        contentSize = CGSizeMake(-1, -1);
        [self initUI];
    }
    
    return self;
}

-(void)initUI
{
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.1];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[FilterCollectionViewCell class] forCellWithReuseIdentifier:identifyCell];
    [self.collectionView registerClass:[FilterHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:identifyHeader];
    [self.collectionView registerClass:[FilterFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifyFooter];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self addSubview:self.collectionView];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(self).priorityLow();
    }];
    
    return;
    //屏蔽下面的代码，不需要重置和确认
    
    UIButton *btnReSet = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnReSet.backgroundColor = [UIColor whiteColor];
    //[btnReSet setBackgroundImage:[UIImage imageNamed:@"icon_backtop"] forState:UIControlStateNormal];
    [btnReSet setTitle:@"重置" forState:UIControlStateNormal];
    btnReSet.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnReSet setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [btnReSet addTarget:self action:@selector(btnResetClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnReSet];
    
    UIButton *btnOK = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnOK.backgroundColor = [UIColor orangeColor];
    [btnOK setTitle:@"确认" forState:UIControlStateNormal];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnOK setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnOK addTarget:self action:@selector(btnOKClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnOK];
    
    [btnReSet makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.bottom);
        make.height.equalTo(40);
        make.left.equalTo(self);
        make.width.equalTo(btnOK);
    }];
    
    [btnOK makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.bottom);
        make.height.equalTo(40);
        make.left.equalTo(btnReSet.right);
        make.width.equalTo(btnReSet);
        make.right.equalTo(self);
    }];
    
    //[self.collectionView reloadData];
    
}

- (void)layoutSubviews
{
    if (self.arBrand.count == 0) {
        [self autoLayoutContentView];
    }
}


-(void)autoLayoutContentView
{

    CGSize size = self.collectionView.collectionViewLayout.collectionViewContentSize;
    if (size.height != contentSize.height)  {
        contentSize.height = size.height;
        
        [self.collectionView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.width.equalTo(self);
            if (size.height == 0) {
                make.height.equalTo(46).priorityHigh();
            }
            else {
                make.height.equalTo(size.height).priorityHigh();
            }
            
        }];

    }
    
}

#pragma mark- btn click mothed
-(void)btnResetClick:(id)sender
{
    self.categoryIndex = -1;
    self.brandIndex = -1;
    [self.collectionView reloadData];
}

-(void)btnOKClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(filterView:categoryIndex:brandIndex:)]) {
        [self.delegate filterView:self categoryIndex:self.categoryIndex brandIndex:self.brandIndex];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(filterViewCancel:)]) {
        [self.delegate filterViewCancel:self];
    }
}
#pragma mark- UICollectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
//    if (section == 0) {
//        count = self.arCategory.count;
//    }
//    else if (section == 1) {
//        count = self.arBrand.count;
//    }
    
    count = self.arBrand.count;
    
    return count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self autoLayoutContentView];
    
     FilterCollectionViewCell *cell  = (FilterCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifyCell forIndexPath:indexPath];
    
//    if (indexPath.section == 0) {
//        //取消类别区分
//        cell.labelText.text = [self.arCategory objectAtIndex:indexPath.row];
//        cell.isSelect = self.categoryIndex == indexPath.row ? YES : NO;
//    }
//    else if (indexPath.section == 1) {
//        cell.labelText.text = [self.arBrand objectAtIndex:indexPath.row];
//        cell.isSelect = self.brandIndex == indexPath.row ? YES : NO;
//    }
    
    cell.labelText.text = [self.arBrand objectAtIndex:indexPath.row];
    cell.isSelect = self.brandIndex == indexPath.row ? YES : NO;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        
        FilterHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifyHeader forIndexPath:indexPath];

//        if (indexPath.section == 0) {
//            //取消类别区分
//            header.labelText.text = @"类型区分";
//        }
//        else if (indexPath.section == 1) {
//            header.labelText.text = @"产品品牌";
//        }
        
        header.labelText.text = @"商品品牌";
        if (self.arBrand.count == 0) {
            header.hiddenLine = YES;
            header.labelTips.text = @"暂无筛选条件";
        }
        else {
            header.labelTips.text = @"";
        }
        
        return header;
        
    }else{
        
        FilterFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifyFooter forIndexPath:indexPath];
        return footer;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    int width = deviceWidth/4-10;
    return CGSizeMake(width, 25);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    UIEdgeInsets top = {5,0,5,0};
    return top;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    int width = self.frame.size.width;
    
    return CGSizeMake(width, 35);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    int width = self.frame.size.width;
    return CGSizeMake(width, 1);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DBG_MSG(@"FilterView select indexpath = %@", indexPath);
//    FilterCollectionViewCell *cell = (FilterCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
//    if (indexPath.section == 0) {
//        if (indexPath.row != self.categoryIndex) {
////            FilterCollectionViewCell *temp = (FilterCollectionViewCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.categoryIndex inSection:0]];
////            if (temp) {
////                temp.isSelect = NO;
////            }
//            
//            self.categoryIndex = (int)indexPath.row;
////            cell.isSelect = YES;
//        }
//        
//        
//    }
//    else if (indexPath.section == 1) {
//        if (indexPath.row != self.brandIndex) {
////            FilterCollectionViewCell *temp = (FilterCollectionViewCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.brandIndex inSection:1]];
////            if (temp) {
////                temp.isSelect = NO;
////            }
//            
//            self.brandIndex = (int)indexPath.row;
////            cell.isSelect = YES;
//        }
//    }
    
    //设置当前选中的index
    if (indexPath.row != self.brandIndex) {
        self.brandIndex = (int)indexPath.row;
    }
    //执行协议
    if ([self.delegate respondsToSelector:@selector(filterView:categoryIndex:brandIndex:)]) {
        [self.delegate filterView:self categoryIndex:self.categoryIndex brandIndex:self.brandIndex];
    }
    [self.collectionView reloadData];
}

@end
