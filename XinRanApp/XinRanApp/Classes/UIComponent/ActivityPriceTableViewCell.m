//
//  ActivityPriceTableViewCell.m
//  XinRanApp
//
//  Created by libj on 15/2/3.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "ActivityPriceTableViewCell.h"
#import "ActivityPriceCollectionViewCell.h"
#import <XRNetInterface/UIImageView+AFNetworking.h>
#import <XRDataModel/ProductForCmd.h>
#import "DetailViewController.h"

@interface ActivityPriceTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{

    //Nib注册使用
    UINib *celllNib;
}

@end

@implementation ActivityPriceTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self InitializeUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) InitializeUI{
    //注册cell
    celllNib = [UINib nibWithNibName:@"ActivityPriceCollectionViewCell" bundle:nil];
    [self.activityPriceCollectionView registerNib:celllNib forCellWithReuseIdentifier:@"activityPriceCollectionViewCell"];
    //初始化数据源
}

#pragma mark --- <UICollectionViewDataSource>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;

}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    NSString *priceCellID = @"activityPriceCollectionViewCell";
    ActivityPriceCollectionViewCell *priceCell = (ActivityPriceCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:priceCellID forIndexPath:indexPath];
    
    if(priceCell == nil)
    {
        priceCell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityPriceCollectionViewCell" owner:self options:0] firstObject];
    }
    // 设置相关数据，默认设置显示 根据数据源设置数据
    ProductForCmd *cellInfor = (ProductForCmd *)[self.dataArray objectAtIndex:indexPath.item];
    
    [priceCell.activityImageView setImageWithURL:[NSURL URLWithString:cellInfor.image]];
    [priceCell.activityInforUILable setText:cellInfor.title];
    [priceCell.activityPriceUILable setText:[NSString stringWithFormat:@"%@%0.2f",@"￥",cellInfor.priceActivity]];
    [priceCell.originalPriceUILable setText:[NSString stringWithFormat:@"%@%0.2f",@"￥",cellInfor.price]];
    return priceCell;
}

#pragma mark --- <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    http://192.168.1.22:8082/media/upload/links/20141128124800_100.jpg
    float cellWith = (self.activityPriceCollectionView.bounds.size.width-3*5.f)/2;
    float cellHeight = self.activityPriceCollectionView.bounds.size.height/2;
    return CGSizeMake(cellWith, cellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 0, 5);
}

#pragma mark --- <UICollectionViewDelegate>
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
//    DetailViewController *detailView = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    ProductForCmd *cellInfor = (ProductForCmd *)[self.dataArray objectAtIndex:indexPath.item];
        if (_jumpToDetails) {
        _jumpToDetails(cellInfor);
    }
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    return YES;
}








@end
