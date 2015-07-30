//
//  FineProductTableViewCell.m
//  XinRanApp
//
//  Created by tianbo on 15-4-9.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "FineProductTableViewCell.h"
#import "FineProductCollectionViewCell.h"
#import "CustomCollectionViewLayout.h"

#import "ProductForCmd.h"
#import <XRNetInterface/UIImageView+AFNetworking.h>

@interface FineProductTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate, CustomCollectionViewLayoutDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *itemHeights;
@end

@implementation FineProductTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CustomCollectionViewLayout *layout = [[CustomCollectionViewLayout alloc] init];
        layout.layoutDelegate = self;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[FineProductCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [self.contentView addSubview:_collectionView];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}


//重写set属性
-(void)setDataSource:(NSArray *)dataSource{
    
    NSMutableArray *tempDataSource = [[NSMutableArray alloc] init];
    if (dataSource.count > 8) {
        for (int i=0; i<8; i++) {
            [tempDataSource addObject:dataSource[i]];
        }
    }
    else {
        tempDataSource = (NSMutableArray *)dataSource;
    }
    
    if (![_dataSource isEqualToArray:tempDataSource]) {
        _dataSource = (NSArray *)tempDataSource;
        [self.collectionView reloadData];
    }
}

-(int)getContentHeight
{
    return self.collectionView.collectionViewLayout.collectionViewContentSize.height;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataSource.count+2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FineProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    //cell.backgroundColor = [UIColor yellowColor];
    if (indexPath.row == 0) {
        [cell showTopView];
    }
    else if (indexPath.row > self.dataSource.count) {
        [cell showBottomView];
    }
    else {
        [cell showProductView];
        ProductForCmd *pdt = [self.dataSource objectAtIndex:indexPath.row-1];
        [cell.thumbView setImageWithURL:[NSURL URLWithString:pdt.image]];
        cell.title.text = pdt.title;
        cell.price.text = [NSString stringWithFormat:@"¥%.2f", pdt.price];
        cell.saled.text = [NSString stringWithFormat:@"%d人已购", pdt.saled];
    }
    
    return cell;
}

#pragma mark - CustomCollectionViewLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView collectionViewLayout:(CustomCollectionViewLayout *)collectionViewLayout sizeOfItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 ) {
        return CGSizeMake((deviceWidth - 3*10) / 2, 50);
    }
    else if (indexPath.row > self.dataSource.count) {
        if (self.dataSource.count%2 == 0) {
            return CGSizeMake((deviceWidth - 3*10) / 2, 50);
        }
        else {
            return CGSizeMake((deviceWidth - 3*10) / 2, (deviceWidth - 3*10) / 2);
        }
    }
    else {
        return CGSizeMake((deviceWidth - 3*10) / 2, (deviceWidth - 3*10) / 2 + 55);
    }
    
    return CGSizeMake(0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row > self.dataSource.count) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickFineProductCell:)]) {
        [self.delegate clickFineProductCell:(int)indexPath.row-1];
    }
}

@end
