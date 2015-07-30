//
//  BaseDetailTableViewCell.m
//  XinRanApp
//
//  Created by mac on 14/12/11.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "NewProductChildTableViewCell.h"
#import <XRNetInterface/UIImageView+AFNetworking.h>

@implementation NewProductChildTableViewCell

- (void)awakeFromNib {
    // Initialization code
//    self.headImageView.layer.borderWidth = 0.3;
//    self.headImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)dealloc
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setImageUrl:(NSString*)url
{
    [self.headImageView setImageWithURL:[NSURL URLWithString:url]];
}


@end
