//
//  TIpView.h
//  ELive
//
//  Created by  on 13-1-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipsView : UIView
{
    UILabel *textLabel; 
}
@property (nonatomic, retain) UILabel *textLabel;

+(id)sharedInstance;
- (void)showTips:(NSString*)info;
@end
