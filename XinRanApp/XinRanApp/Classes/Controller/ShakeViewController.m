//
//  ShakeViewController.m
//  XinRanApp
//
//  Created by tianbo on 15-5-19.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "ShakeViewController.h"
#import "AudioToolbox/AudioToolbox.h"

#import "User.h"
#import "Product.h"

#import <XRNetInterface/UIImageView+AFNetworking.h>




#define KWinningViewTag   10010
#define KLostViewTag      10011

#define KCode_RemaindNull     30001       //抽奖数数用完
#define KCode_Lost            30002       //未中奖
#define KCode_Expire          30003       //已期
#define KCode_NoAuth          30004       //用户无权限

@interface ShakeViewController () <UIGestureRecognizerDelegate>
{
    BOOL bshake;
}

@property (weak, nonatomic) IBOutlet UIButton *btnShake;
@property (weak, nonatomic) IBOutlet UIImageView *imgHand;
@property (weak, nonatomic) IBOutlet UILabel *labelRemaindNum;

@end

@implementation ShakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.type == 1) {   //按次
        self.labelRemaindNum.text = [NSString stringWithFormat:@"您本期还可以摇 %d 次", self.remaindNum];
    }
    else{  //按天
        self.labelRemaindNum.text = [NSString stringWithFormat:@"您今天还可以摇 %d 次", self.remaindNum];
    }
    
    [self setupLabelColor:self.labelRemaindNum];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupLabelColor:(UILabel*)label
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,7)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(8,2)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(10,1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 7)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(8, 2)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(10, 1)];
    label.attributedText = str;
}

-(void)setupNavigationBar
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbktrans"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    
    UIImage *image = [UIImage imageNamed:@"btn_back-1"];
    CGRect buttonFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNavigationBar];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

-(void)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
/** 开始摇一摇 */
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    DBG_MSG(@"motionBegan");

    [self onShake];
}

/** 摇一摇结束（需要在这里处理结束后的代码） */
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    // 不是摇一摇运动事件
    if (motion != UIEventSubtypeMotionShake) return;
    DBG_MSG(@"motionEnded");

    
}

/** 摇一摇取消（被中断，比如突然来电） */
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    DBG_MSG(@"motionCancelled");
    //[self stopWait];
}

- (IBAction)btnShakeClick:(id)sender {
    [self onShake];
}

-(void)onShake
{
    if (bshake) {
        return;
    }
    
    bshake = YES;
    
    [self animateShakeView:self.imgHand];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    if (self.remaindNum == 0) {
        [self showLostView:KCode_RemaindNull];
        return;
    }
    
    [self performSelector:@selector(sendShakeInfo) withObject:nil afterDelay:0.5];
}

-(void)animateShakeView:(UIView*)viewToShake
{
    CGFloat t = 12.0;
    CGAffineTransform translateTop  =CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0, t);
    CGAffineTransform translateBottom =CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0, -t);
    
    viewToShake.transform = translateBottom;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:5.0];
        viewToShake.transform = translateTop;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
    
}


-(void)sendShakeInfo
{
    User *user = [[EnvPreferences sharedInstance] getUserInfo];
    [[NetInterfaceManager sharedInstance] activityLottery:user.userId];
    //[self startWait];
}

#pragma mark- http request handler
-(void)httpRequestFinished:(NSNotification *)notification
{
    DBG_MSG(@"enter");
    [self stopWait];
    ResultDataModel *result = notification.object;
    if (!result) {
        DBG_MSG(@"http result is nil!");
        return;
    }
    
    NSDictionary *dict = result.data;
    switch (result.requestType) {
        case KReqestType_ActivityLottery:
        {
            
            if (result.resultCode == 0) {
                //prize:  1~5 :1~5等奖
                //        6：未中奖
                //        7：次数已用完
                //        8：活动已过期（未开始，无活动）
                int code = [[dict objectForKey:@"prize"] intValue];
                if (code < 6) {
                    //中奖
                    [self showWinningView:dict];
                }
                else if (code == 6) {
                    [self showLostView:KCode_Lost];
                }
                else if (code == 7) {
                    [self showLostView:KCode_RemaindNull];
                }
                else if (code == 8) {
                    [self showLostView:KCode_Expire];
                }
                
                self.remaindNum = [[dict objectForKey:@"residue"] intValue];
                
                if (self.type == 1) {   //按次
                    self.labelRemaindNum.text = [NSString stringWithFormat:@"您本期还可以摇 %d 次", self.remaindNum];
                }
                else{  //按天
                    self.labelRemaindNum.text = [NSString stringWithFormat:@"您今天还可以摇 %d 次", self.remaindNum];
                }
                
                [self setupLabelColor:self.labelRemaindNum];
                
            }
            else if (result.resultCode == 1) {
                [self showLostView:KCode_NoAuth];
            }
            
        }
            break;

            
        default:
            break;
    }
}

-(void)httpRequestFailed:(NSNotification *)notification
{
    [super httpRequestFailed:notification];
    ResultDataModel *result = notification.object;
    if (!result) {
        DBG_MSG(@"http result is nil!");
        return;
    }
    
    switch (result.requestType) {
        case KReqestType_ActivityLottery:
        {
            bshake = NO;
        }
            break;
        default:
            break;
    }
}



#pragma mark-
-(void)showWinningView:(NSDictionary*)pdt
{
    UIView *view = [self winningView:pdt];
    [self.view addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(280);
        make.height.equalTo(315);
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];
}

-(void)showLostView:(int)code
{
    __block UIView *view = [self lostView:code];
    [self.view addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(200);
        make.height.equalTo(85);
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];
    
    [UIView animateWithDuration:0.4 delay:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished){
        [view removeFromSuperview];
        view = nil;
        
        bshake = NO;
    }];

}

-(UIView*)winningView:(NSDictionary*)dict
{
    NSDictionary *pdt = [dict objectForKey:@"prize_info"];
    UIView *view = [UIView new];
    view.tag = KWinningViewTag;
    //view.backgroundColor = [UIColor grayColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"win_bk"]];
    [view addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view);
        make.left.equalTo(view).offset(35);
        make.bottom.equalTo(view);
        make.right.equalTo(view).offset(-35);
    }];
    
    UIImageView *imgTitle = [[UIImageView alloc] init];
    [view addSubview:imgTitle];
    [imgTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(5);
        make.centerX.equalTo(view);
        make.width.equalTo(86);
        make.height.equalTo(32);
    }];
    
    int prize = [[dict objectForKey:@"prize"] intValue];
    [imgTitle setImage:[UIImage imageNamed:[NSString stringWithFormat:@"prize_%d", prize]]];
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnClose setBackgroundImage:[UIImage imageNamed:@"winclose"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(closeWinningView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnClose];
    [btnClose makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(30);
        make.height.equalTo(30);
        make.top.equalTo(5);
        make.right.equalTo(view).offset(-20);
    }];
    
    UIImageView *thmbView = [[UIImageView alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%@", KImageDonwloadAddr, [pdt objectForKey:@"item_images"]];
    [thmbView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"icon_defaut_img"]];
    thmbView.backgroundColor = [UIColor redColor];
    [view addSubview:thmbView];
    [thmbView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(40);
        make.centerX.equalTo(view);
        make.width.equalTo(140);
        make.height.equalTo(140);
    }];
    
    UILabel *labelName = [UILabel new];
    labelName.backgroundColor = [UIColor clearColor];
    labelName.textColor = [UIColor darkGrayColor];
    labelName.textAlignment = NSTextAlignmentCenter;
    labelName.font = [UIFont systemFontOfSize:18];
    labelName.text = [pdt objectForKey:@"item_name"];
    [view addSubview:labelName];
    [labelName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(thmbView.bottom).offset(15);
        make.width.equalTo(view);
        make.height.equalTo(30);
        make.centerX.equalTo(view);
    }];
    
    UILabel *labelPrice = [UILabel new];
    labelPrice.backgroundColor = [UIColor clearColor];
    labelPrice.textColor = [UIColor darkGrayColor];
    labelPrice.textAlignment = NSTextAlignmentCenter;
    labelPrice.font = [UIFont systemFontOfSize:16];
    labelPrice.text = [NSString stringWithFormat:@"原价: %0.2f", [[pdt objectForKey:@"activity_price"] floatValue]];
    [view addSubview:labelPrice];
    [labelPrice makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelName.bottom);
        make.width.equalTo(view);
        make.height.equalTo(30);
        make.centerX.equalTo(view);
    }];
    
    UILabel *labelActiPrice = [UILabel new];
    labelActiPrice.backgroundColor = [UIColor clearColor];
    labelActiPrice.textColor = UIColor_DefOrange;
    labelActiPrice.textAlignment = NSTextAlignmentCenter;
    labelActiPrice.font = [UIFont systemFontOfSize:16];
    labelActiPrice.text = [NSString stringWithFormat:@"兑换价: %0.2f", [[pdt objectForKey:@"activity_price"] floatValue]];
    [view addSubview:labelActiPrice];
    [labelActiPrice makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelPrice.bottom);
        make.width.equalTo(view);
        make.height.equalTo(30);
        make.centerX.equalTo(view);
    }];
    
    UILabel *labelTip = [UILabel new];
    labelTip.backgroundColor = [UIColor clearColor];
    labelTip.textColor = UIColor_DefGreen;
    labelTip.textAlignment = NSTextAlignmentCenter;
    labelTip.font = [UIFont systemFontOfSize:14];
    labelTip.text = @"去门店领取大奖吧!";
    [view addSubview:labelTip];
    [labelTip makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelActiPrice.bottom);
        make.width.equalTo(view);
        make.height.equalTo(30);
        make.centerX.equalTo(view);
    }];
    
    return view;
}

-(UIView*)lostView:(int)code
{
    UIView *view = [UIView new];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tips_bk"]];
    [view addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    UILabel *labelTip = [UILabel new];
    labelTip.backgroundColor = [UIColor clearColor];
    labelTip.textColor = [UIColor whiteColor];
    labelTip.textAlignment = NSTextAlignmentCenter;
    labelTip.font = [UIFont systemFontOfSize:16];
    labelTip.numberOfLines = 0;
    
    [view addSubview:labelTip];
    [labelTip makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(view);
        make.height.equalTo(60);
        make.centerX.equalTo(view);
        make.centerY.equalTo(view);
    }];
    
    if (code == KCode_RemaindNull) {
        if (self.type == 1) {   //按次
            labelTip.text = @"您本场抽奖机会用完啦, \n下期请早哟!";
        }
        else {  //按天
            labelTip.text = @"您今天抽奖机会用完啦, \n明天请早哟!";
        }
        
    }
    else if (code == KCode_Expire) {
        labelTip.text = @"当前活动已过期, \n下期请早哟!";
    }
    else if (code == KCode_Lost) {
        labelTip.text = @"哎呀, 差一点就中奖了, \n再试试!";
    }
    else {
        labelTip.text = @"用户没有权限!";
    }
    
    
    return view;
}

-(void)closeWinningView
{
    bshake = NO;
    
    __block UIView *view = [self.view viewWithTag:KWinningViewTag];
    if (view) {
        [UIView animateWithDuration:0.4 animations:^{
            view.alpha = 0;
            
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            view = nil;
        }];
        
    }
}
@end
