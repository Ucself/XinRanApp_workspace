//
//  FineProductTableViewCell.h
//  XinRanApp
//
//  Created by tianbo on 15-4-9.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FineProductTableViewCellDelegate<NSObject>

@optional
//点击一个精选商品
-(void)clickFineProductCell:(int) indexPath;

@end

@interface FineProductTableViewCell : UITableViewCell


//数据源
@property (nonatomic, strong) NSArray *dataSource;
//协议
@property (assign,nonatomic) id delegate;

-(int)getContentHeight;
@end
