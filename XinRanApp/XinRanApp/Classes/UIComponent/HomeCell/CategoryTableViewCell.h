//
//  CategoryTableViewCell.h
//  XinRanApp
//
//  Created by libj on 15/4/3.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryTableViewCellDelegate <NSObject>

@optional
//点击秒杀
-(void)clickCategoryTableViewCell:(NSInteger)indexPath dicInfor:(NSDictionary *)dicInfor;

@end


@interface CategoryTableViewCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic, assign) id delegate;
@end
