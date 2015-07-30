//
//  BaseUITableViewCell.m
//  XinRanApp
//
//  Created by mac on 14/12/10.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "ActivityTableViewCell.h"

#import <XRNetInterface/UIImageView+AFNetworking.h>

@implementation ActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setImageUrl:(NSString*)url
{
    [self.bkImageView setImageWithURL:[NSURL URLWithString:url]];
}
@end
