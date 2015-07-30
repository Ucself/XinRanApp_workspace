//
//  MeOrderTableViewCell.h
//  XinRanApp
//
//  Created by mac on 14/12/17.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@protocol MeOrderTableViewCellDelegate <NSObject>

-(void)onDetailBtnClick:(id)sender Id:(NSString*)orderId;

-(void)onCancelOrder:(int)index;
-(void)onOpreatOrder:(int)index;
@end

@interface MeOrderTableViewCell : UITableViewCell

@property(nonatomic, assign) id delegate;
@property(nonatomic, assign)int index;

@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;//产品图片
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;//订单号
@property (weak, nonatomic) IBOutlet UILabel *productLabel;//产品名称
@property (weak, nonatomic) IBOutlet UILabel *productDetail;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;//领取地址

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//创建时间
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;//产品数量

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//产品单价
@property (weak, nonatomic) IBOutlet UILabel *allpriceLabel;//合计总价

@property (weak, nonatomic) IBOutlet UIButton *btnOpt;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

//通过一个tableView来创建一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
