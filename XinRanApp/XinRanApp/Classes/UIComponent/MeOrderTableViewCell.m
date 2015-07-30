//
//  MeOrderTableViewCell.m
//  XinRanApp
//
//  Created by mac on 14/12/17.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "MeOrderTableViewCell.h"
#import <XRNetInterface/UIImageView+AFNetworking.h>

@implementation MeOrderTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"MeOrderTableViewCellIdent";
    MeOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MeOrderTableViewCell" owner:self options:0] firstObject];
    }

    return cell;

}

//- (void)setOrder:(Order *)order
//{
//    _order = order;
//    
//    if (![order.sn isKindOfClass:[NSNull class]]) {
//        self.orderLabel.text = order.sn;//产品编号
//    }
    
//    self.productLabel.text = order.name;//产品名称
//    
//    NSRange rang = {0,10};
//    NSString *startTime = [order.addTime substringWithRange:rang];
//    self.timeLabel.text = startTime;//开始日期
//    [self.headerImageView setImageWithURL:[NSURL URLWithString:order.image]]; //头部图片列表
//    self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f",order.price];
//    self.allpriceLabel.text = [NSString stringWithFormat:@"￥%0.2f",order.price * order.num];
//    self.numberLabel.text = [NSString stringWithFormat:@"× %d", order.num];//产品数量   
//    
//    switch (order.status) {
//        case OrderStatus_NotPayment://未付款
//            [self.stateButton setTitle:@"待自提" forState:UIControlStateNormal];
//            
//            break;
//        case OrderStatus_Received://已收货
//            [self.stateButton setTitle:@"已完成" forState:UIControlStateNormal];
//            break;
//        case OrderStatus_Cancel://已取消
//            [self.stateButton setTitle:@"已取消" forState:UIControlStateNormal];
//            break;
//        case OrderStatus_Invalid://过期
//
//            [self.stateButton setTitle:@"已取消" forState:UIControlStateNormal];
//            break;
//        default:
//            break;
//    }
//    
//}



-(void)dealloc
{

}

- (void)awakeFromNib {
    // Initialization code
    self.headerImageView.layer.borderWidth = 0.3;
    self.headerImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 获取礼品券按钮
//- (IBAction)detailButton:(id)sender {
//    //DBG_MSG(@"cellId=%@",self.orderLabel.text);
//    
//    if ([self.delegate respondsToSelector:@selector(onDetailBtnClick:Id:)]) {
//        [self.delegate onDetailBtnClick:sender Id:self.order.Id];
//        DBG_MSG(@"orderId=%@", self.order.Id);
//    }
//
//}

- (IBAction)btnCancelClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(onCancelOrder:)]) {
        [self.delegate onCancelOrder:self.index];
        DBG_MSG(@"orderId=%d", self.index);
    }
}

- (IBAction)btnOptClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(onOpreatOrder:)]) {
        [self.delegate onOpreatOrder:self.index];
        DBG_MSG(@"orderId=%d", self.index);
    }
}

//-(void)clickTiming{
//    //这是点击进入的获取兑换卷
//    if ([self.delegate respondsToSelector:@selector(buttonClickTiming)]) {
//        [self.delegate performSelector:@selector(buttonClickTiming)];
//    }
//
//}
//-(void)timingButtonInfor:(id)sender{
//    //这是点击进入的获取兑换卷
//    if ([self.delegate respondsToSelector:@selector(timingButtonInfor:)]) {
//        [self.delegate performSelector:@selector(timingButtonInfor:)];
//    }
//}
@end
