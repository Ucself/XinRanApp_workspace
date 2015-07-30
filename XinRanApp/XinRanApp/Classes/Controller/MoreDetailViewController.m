//
//  MoreDetailViewController.m
//  XinRanApp
//
//  Created by mac on 14/12/16.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "MoreDetailViewController.h"


@interface MoreDetailViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation MoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
- (void)initUI
{
    NSString *title = nil;
    NSString *path = nil;
    switch (self.type) {
        case MoreDetailViewType_PayMethod:
            title = @"支付方式";
            path = [[NSBundle mainBundle] pathForResource:@"payMethod" ofType:@"html"];
            break;
        case MoreDetailViewType_DistributionMethod:
            title = @"配送方式";
            path = [[NSBundle mainBundle] pathForResource:@"distributionMethod" ofType:@"html"];
            break;
        case MoreDetailViewType_AuthenticGuarantee:
            path = [[NSBundle mainBundle] pathForResource:@"authenticGuarantee" ofType:@"html"];
            title = @"正品保障";
            break;
        case MoreDetailViewType_ReturnGoods:
            title = @"退换货政策";
            path = [[NSBundle mainBundle] pathForResource:@"returnGoods" ofType:@"html"];
            break;
        case MoreDetailViewType_AboutUs:
            path = [[NSBundle mainBundle] pathForResource:@"aboutUs" ofType:@"html"];
            title = @"关于我们";
            break;
        default:
            break;
    }
    
    self.title = title;
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [self.webView loadRequest:request];
}

#pragma make --- <UIWebViewDelegate>
-(void)webViewDidFinishLoad:(UIWebView *)webView{

    if(self.type == MoreDetailViewType_AboutUs){
        NSString *curVer = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        [webView stringByEvaluatingJavaScriptFromString:[@"setVersion('" stringByAppendingFormat:@"  v%@%@", curVer, @"')"]];
    }
}
@end
