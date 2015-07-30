//
//  ActivityProductCell.m
//  XinRanApp
//
//  Created by tianbo on 15-2-5.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "ActivityProductCell.h"
#import <XRNetInterface/UIImageView+AFNetworking.h>

@implementation ActivityProductCell

- (void)awakeFromNib {
    // Initialization code
    self.timerView.hidden = YES;
    
    //self.imgView.layer.borderWidth = 0.3;
    //self.imgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

-(void)dealloc
{
    [self.timerView stop];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setImageUrl:(NSString*)url
{
    [self.imgView setImageWithURL:[NSURL URLWithString:url]];
}

-(void)setTimeInterval:(NSInteger)timeInterval
{
    if (timeInterval > 0) {
        self.timerView.hidden = NO;
        [self.timerView setTotalSeconds:timeInterval];
        [self.timerView start];
    }
}
@end
