//
//  DetailViewController.h
//  XinRanApp
//
//  Created by mac on 14/12/11.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
//#import "BannerView.h"
#import <XRUIView/BannerView.h>

@interface DetailViewController : BaseUIViewController<BannerViewDelegate, UIScrollViewDelegate, UIWebViewDelegate>
{
    
}

@property(nonatomic, strong) NSString *Id;           //商品id
@property(nonatomic, strong) NSString *dId;          //活动id
//@property(nonatomic, strong) NSString *whouseId;     //店铺id
@property(nonatomic, strong) NSString *imageUrl;     //logo图片地址

@end
