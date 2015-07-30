//
//  BrandTableViewCell.m
//  XinRanApp
//
//  Created by libj on 15/2/7.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "BrandTableViewCell.h"
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
//#import "Masonry.h"
#import <XRUIView/Masonry.h>

@interface BrandTableViewCell (){

}

@end

@implementation BrandTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self iniializeInterface];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [self iniializeInterface];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self iniializeInterface];
    }
    return self;
}

-(void)setIsSelected:(BOOL)isSelected{
    
    _isSelected =!isSelected;
    if (_isSelected) {
        [_imageViewIcon setImage:[UIImage imageNamed:@"brand_selected"]];
    }
    else {
        [_imageViewIcon setImage:[UIImage imageNamed:@"brand_not_selected"]];
    }
}

#pragma mark ----
-(void) iniializeInterface{
    //名称控件
    if (!_lableName) {
        _lableName = [UILabel new];
    }
    [self addSubview:_lableName];
    [_lableName setTextColor:[UIColor lightGrayColor]];
    [_lableName setFont:[UIFont fontWithName:nil size:15]];
    [_lableName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(30);
        make.centerY.equalTo(self.centerY);
        make.height.equalTo(22);
        make.width.equalTo(150);
    }];
    //设置选中图标的样式,默认设置为未选中
    if (!_imageViewIcon) {
        _imageViewIcon = [UIImageView new];
    }
    [self addSubview:_imageViewIcon];
    [_imageViewIcon makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-20);
        make.centerY.equalTo(self.centerY);
        make.height.equalTo(15);
        make.width.equalTo(15);
    }];
//    [_imageViewIcon setImage:[UIImage imageNamed:@"brand_not_selected"]];
}

@end





