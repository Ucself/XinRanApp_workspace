//
//  BaseUIViewController.h
//  XinRanApp
//
//  Created by tianbo on 14-12-5.
//  Copyright (c) 2014年 deshan.com All rights reserved.
//
//
//  UIViewController基础类

#import <UIKit/UIKit.h>


#import "NetInterfaceManager.h"
#import "ResultDataModel.h"

#import "EnvPreferences.h"
#import <XRCommon/XRCommon.h>
#import <XRUIView/NetPrompt.h>

@class Reachability;



//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
//#import "Masonry.h"
#import <XRUIView/Masonry.h>

@protocol BaseUIViewControllerDelegate <NSObject>

-(void)controllerBackWithData:(id)data;

@end

@interface BaseUIViewController : UIViewController
{
    NetPrompt * netPrompt;
    BOOL isShowNetPrompt;
    BOOL isShowRequestPrompt;
}
@property(nonatomic, assign) id delegate;

//返回顶部按钮
@property(nonatomic, strong) UIButton *btnGotoTop;

//提示信息
- (void) showTipsView:(NSString*)tips;
- (void) showAlertWithTitle:(NSString*)title msg:(NSString*)msg;
- (void) showAlertWithTitle:(NSString*)title msg:(NSString*)msg showCancel:(BOOL)showCancel;

- (void) startWait;
- (void) stopWait;

-(void)httpRequestFinished:(NSNotification *)notification;
-(void)httpRequestFailed:(NSNotification *)notification;


-(void)addGotoTopButton:(UIView*)blowView;
-(void)showGotoTopButton:(BOOL)show;
-(void)showGotoTopButton:(BOOL)show offset:(int)offset;
@end
