//
//  BaseUIViewController.m
//  XinRanApp
//
//  Created by tianbo on 14-12-5.
//  Copyright (c) 2014年 deshan.com All rights reserved.
//

#import "BaseUIViewController.h"
#import "TipsView.h"
#import "WaitView.h"

#import "Common.h"
#import "AppDelegate.h"


@interface BaseUIViewController () <NetPromptDelegate>
{
    BOOL bNetMonitor;
}

@property(nonatomic, weak)UIView *blowView;
@end



@implementation BaseUIViewController

-(void)netStatusMonitor
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate addObserver:self forKeyPath:@"netStatus" options:NSKeyValueObservingOptionNew context:nil];
    bNetMonitor = YES;
}

-(void)dealloc
{
    DBG_MSG(@"enter");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (bNetMonitor) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate removeObserver:self forKeyPath:@"netStatus"];
    }
}

-(void)loadView{
    [super loadView];
    //设置默认网络出现连接情况的配置
    isShowNetPrompt = YES;
    isShowRequestPrompt = NO;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor_Background;
    self.navigationController.navigationBar.barTintColor = UIColor_Background;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
    
    //注册系统通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationEnterBackGround) name:KNotifyEnterBackGround object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationBecomeActive) name:KNotifyBecomeActive object:nil];
    
    //注册网络请求通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(httpRequestFinished:) name:KNotification_RequestFinished object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(httpRequestFailed:) name:KNotification_RequestFailed object:nil];
    
    //监测网络状态
    [self netStatusMonitor];
    
    [self setNavigationBar];
    //设置网络错误提示
    [self getNetPrompt];
}

- (NetPrompt *)getNetPrompt
{
    //即将显示的时候创建
    if (!netPrompt) {
        netPrompt = [[NetPrompt alloc] initWithView:self.view
                                      showTopUIView:NO
                                   showMiddleUIView:NO];
    }
    netPrompt.delegate = self;
    return netPrompt;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置网络请求标识
    [[NetInterfaceManager sharedInstance] setReqControllerId:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //更新网络状态
    [self updateInterfaceWithNetStatus];
}

- (void)viewWillDisappear: (BOOL)animated
{
    [super viewWillDisappear: animated];
}

#pragma mark-
-(void)setNavigationBar
{
    UIView *line  = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 0.6)];
    line.backgroundColor = UIColor_DefGreen;
    [self.navigationController.navigationBar addSubview:line];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]] ;
    [self.navigationController.navigationBar setTintColor:UIColor_DefGreen];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColor_DefGreen}];
}

-(void)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addGotoTopButton:(UIView*)blowView
{
    self.btnGotoTop = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnGotoTop.backgroundColor = [UIColor clearColor];
    [self.btnGotoTop setBackgroundImage:[UIImage imageNamed:@"icon_backtop"] forState:UIControlStateNormal];
    [self.btnGotoTop addTarget:self action:@selector(btnGotoTopClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.blowView = blowView;
    if (blowView) {
        [self.view insertSubview:self.btnGotoTop belowSubview:blowView];
    }
    else {
        [self.view addSubview:self.btnGotoTop];
    }
    
    [self.btnGotoTop makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(40);
        make.height.equalTo(40);
        make.left.equalTo(self.view.right).offset(-50);
        
        if (self.blowView) {
            make.top.equalTo(self.blowView).offset(0);
        }
        else {
            make.top.equalTo(self.view.bottom).offset(0);
        }
        
    }];
}

-(void)showGotoTopButton:(BOOL)show
{
    [self showGotoTopButton:show offset:-50];
}

-(void)showGotoTopButton:(BOOL)show offset:(int)offset
{
    if (self.btnGotoTop.tag == show) {
        return;
    }
    
    int yOffset = 0;
    if (show) {
        yOffset = offset;
    }
    
    
    [self.btnGotoTop remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(40);
        make.height.equalTo(40);
        make.left.equalTo(self.view.right).offset(-50);
        if (self.blowView) {
            make.top.equalTo(self.blowView.top).offset(yOffset);
        }
        else {
            make.top.equalTo(self.view.bottom).offset(yOffset);
        }
        
    }];
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    self.btnGotoTop.tag = show;
}

- (IBAction)btnGotoTopClick:(id)sender {
}

#pragma mark- system notification
-(void)onApplicationEnterBackGround
{
    DBG_MSG(@"Enter");
}

-(void)onApplicationBecomeActive
{
    DBG_MSG(@"Enter");
}


#pragma mark - show alert view
-(void) showAlertWithTitle:(NSString*)title msg:(NSString*)msg
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    alert.delegate = self;
    [alert show];
}

- (void) showAlertWithTitle:(NSString*)title msg:(NSString*)msg showCancel:(BOOL)showCancel
{
    if (!showCancel) {
        [self showAlertWithTitle:title msg:msg];
    }
    else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定", nil];
        alert.delegate = self;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (void)showTipsView:(NSString*)tips
{
    [[TipsView sharedInstance] showTips:tips];
}

- (void) startWait
{
    [[WaitView sharedInstance] start];
}

- (void) stopWait
{
    //[progressView hide:YES];
    [[WaitView sharedInstance] stop];
}

#pragma mark- http request handler
-(void)httpRequestFinished:(NSNotification *)notification
{
    DBG_MSG(@"enter");
    //当前的类名
    NSString *className= [NSString  stringWithUTF8String:object_getClassName(self)];
    //请求时候的类名
    NSString *reqClassName =  [[NetInterfaceManager sharedInstance] getReqControllerId];
    //再次请求成功清除无网络提示
    if ([reqClassName isEqualToString:className]) {
        [netPrompt setIsShowMiddleUIView:NO];
    };
    [self stopWait];
}

-(void)httpRequestFailed:(NSNotification *)notification
{
    [self stopWait];
    ResultDataModel *result = notification.object;
    if (!result) {
        DBG_MSG(@"httpRequestFailed: result is nil!");
        return;
    }
    
    DBG_MSG(@"httpRequestFailed: resultcode= %d", result.resultCode);
    
    //当前的类名
    NSString *className= [NSString  stringWithUTF8String:object_getClassName(self)];
    //请求时候的类名
    NSString *reqClassName =  [[NetInterfaceManager sharedInstance] getReqControllerId];
    
    //无网络状态
    if (isShowRequestPrompt && [reqClassName isEqualToString:className]) {
        //这里是本control 设置不显示中部的
        [netPrompt setIsShowMiddleUIView:isShowRequestPrompt];
        return;
    }
    
    
    [self showTipsView:result.desc];
}

#pragma mark- networkStatusChanged
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [self updateInterfaceWithNetStatus];
}

-(void) updateInterfaceWithNetStatus
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    switch (appDelegate.netStatus)
    {
        case NotNetwork: //无网络
        {
            //如果设置为不显示无网络提示
            if (!isShowNetPrompt) {
                return;
            }
            //显示顶部的显示
            [netPrompt setIsShowTopUIView:isShowNetPrompt];
            break;
        }
        default:
        {
            [netPrompt setIsShowTopUIView:NO];
            break;
        }
    }
}

#pragma mark- http RequestPromptDelegate

- (void) requestNetReloadClick{
    [netPrompt setIsShowMiddleUIView:NO];
    [self startWait];
    [[NetInterfaceManager sharedInstance] reloadRecordData];
    
}
@end



