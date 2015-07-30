//
//  NetInterfaceManager.m
//  XinRanApp
//
//  Created by tianbo on 14-12-8.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "NetInterfaceManager.h"
#import "JsonBuilder.h"
#import "ResultDataModel.h"

#import <XRNetInterface/XRNetInterface.h>
#import "EnvPreferences.h"
#import "User.h"


@interface NetInterfaceManager ()
{
    NSString *recordUrl;
    NSString *recordBody;
    RequestType recordRequestType;
    int recordIsPost;
    
    NSString *controllerId;
}

@property(nonatomic, copy) void (^successBlock)(NSString* msg);
@property(nonatomic, copy) void (^failedBlock)(NSString* msg);
@end

@implementation NetInterfaceManager

+(NetInterfaceManager*)sharedInstance
{
    static NetInterfaceManager *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}



-(void)dealloc
{
    self.successBlock = nil;
    self.failedBlock = nil;
}

-(void)setSuccessBlock:(void (^)(NSString*))success failedBlock:(void (^)(NSString*))failed
{
    self.successBlock = success;
    self.failedBlock = failed;
}

#pragma mark-

//重新加载上一次的请求
-(void) reloadRecordData {
    
    if (recordUrl && recordBody) {
        switch (recordIsPost) {
            case 1:
                [self postRequst:recordUrl body:recordBody requestType:recordRequestType];
                break;
            case 0:
                [self getRequst:recordUrl body:recordBody requestType:recordRequestType];
                break;
            default:
                break;
        }
    }
    
}

//会话过期处理方法
-(void)tokenExpireHandler {
    
    //// stup 1. 登录
    User *user = [[EnvPreferences sharedInstance] getUserInfo];
    if (user && user.username && user.pwd) {
        
        NSString *body = [[JsonBuilder sharedInstance] jsonWithLogin:user.username pwd:user.pwd type: LoginType_Email];
        NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_Login];
        
        [[NetInterface sharedInstance] httpPostRequest:url body:body suceeseBlock:^(NSString *msg){
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                //转化josn数据到ResultDataModel
                ResultDataModel *result = [[ResultDataModel alloc] initWithDictionary:[JsonBuilder dictionaryWithJson:msg decode:NO key:nil] reqType:KReqestType_Login];
                
                if (result.resultCode == 0) {
                    //解析出token字符串
                    NSString *token = [JsonBuilder tokenStringWithJosn:msg decode:NO key:nil];
                    [[EnvPreferences sharedInstance] setToken:token];

                    //// stup 2. 重新请求
                    [self reloadRecordData];
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //通知页面
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_RequestFailed object:result];
                    });
                }
                
            });
            
        }failedBlock:^(NSError *error) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //转化错误信息到ResultDataModel
                ResultDataModel *result = [[ResultDataModel alloc] initWithErrorInfo:error reqType:KReqestType_Login];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //通知页面
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_RequestFailed object:result];
                });
                
            });
            
        }];
    }
}

#pragma mark-
-(void)postRequst:(NSString*)url body:(NSString*)body requestType:(int)type
{
    //记录一次请求数据
    recordUrl = url;
    recordBody = body;
    recordRequestType = type;
    recordIsPost = 1;
    
    NSString *token = [[EnvPreferences sharedInstance] getToken];
    [[NetInterface sharedInstance] setToken:token];
    [[NetInterface sharedInstance] httpPostRequest:url body:body suceeseBlock:^(NSString *msg){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //解析出token字符串
            if (type == KReqestType_Register || type == KReqestType_Login) {
                NSString *token = [JsonBuilder tokenStringWithJosn:msg decode:NO key:nil];
                [[EnvPreferences sharedInstance] setToken:token];
            }
            
            //转化josn数据到ResultDataModel
            ResultDataModel *result = [[ResultDataModel alloc] initWithDictionary:[JsonBuilder dictionaryWithJson:msg decode:NO key:nil] reqType:type];
            
            if (result.resultCode == 401 || result.resultCode == 403) {
                //鉴权失效重置token
                [[EnvPreferences sharedInstance] setToken:nil];
                
                [self tokenExpireHandler];
                return ;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //通知页面
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_RequestFinished object:result];
            });
        });
        
    }failedBlock:^(NSError *error) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //转化错误信息到ResultDataModel
            ResultDataModel *result = [[ResultDataModel alloc] initWithErrorInfo:error reqType:type];
            
            if (result.resultCode == 401 || result.resultCode == 403) {
                //鉴权失效重置token
                [[EnvPreferences sharedInstance] setToken:nil];
                
                [self tokenExpireHandler];
                return ;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
            //通知页面
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_RequestFailed object:result];
            });
            
        });
       
    }];
}

-(void)getRequst:(NSString*)url body:(NSString*)body requestType:(int)type
{
    //记录一次请求数据
    recordUrl = url;
    recordBody = body;
    recordRequestType = type;
    recordIsPost = 0;
    
    NSString *token = [[EnvPreferences sharedInstance] getToken];
    [[NetInterface sharedInstance] setToken:token];
    [[NetInterface sharedInstance] httpGetRequest:url body:body suceeseBlock:^(NSString *msg){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //转化josn数据到ResultDataModel
            ResultDataModel *result = [[ResultDataModel alloc] initWithDictionary:[JsonBuilder dictionaryWithJson:msg decode:NO key:nil] reqType:type];
            
            if (result.resultCode == 401 || result.resultCode == 403) {
                //鉴权失效重置token
                [[EnvPreferences sharedInstance] setToken:nil];
                
                [self tokenExpireHandler];
                return ;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //通知页面
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_RequestFinished object:result];
            });
            
        });
        
    }failedBlock:^(NSError *error) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //转化错误信息到ResultDataModel
            ResultDataModel *result = [[ResultDataModel alloc] initWithErrorInfo:error reqType:type];
            
            if (result.resultCode == 401 || result.resultCode == 403) {
                //鉴权失效重置token
                [[EnvPreferences sharedInstance] setToken:nil];
                
                [self tokenExpireHandler];
                return ;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //通知页面
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_RequestFailed object:result];
            });
            
        });
    }];
}

/**
 *  设置当前的ViewController
 *
 *  @param controller name
 */
-(void)setReqControllerId:(NSString*)cId
{
    //DBG_MSG(@"--controllerid=%@", cId)
    controllerId= cId;
}

-(NSString*)getReqControllerId
{
    return controllerId;
}

/**
 *  登录接口
 *
 *  @param name 用户手机号或邮箱
 *  @param pwd  密码
 */
-(void)login:(NSString*)name pwd:(NSString*)pwd type:(int)type
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithLogin:name pwd:pwd type:type];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_Login];
    //url = @"http://www.baidu.com";
    
    [self postRequst:url body:body requestType:KReqestType_Login];
    
}

/**
 *  注册接口
 *
 *  @param name   用户手机号或邮箱
 *  @param pwd    密码
 *  @param type   1：手机号码；2：邮箱
 *  @param sphone 密保手机号码
 */
-(void)regist:(NSString*)name pwd:(NSString*)pwd type:(int)type sphone:(NSString*)sphone code:(NSString*)code
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithRegister:name pwd:pwd type:type sphone:sphone code:code];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_Register];

    [self postRequst:url body:body requestType:KReqestType_Register];
}

/**
 *  注销接口
 */
-(void)logout
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithLogout];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_Logout];
    
    [self getRequst:url body:body requestType:KReqestType_Logout];
}

/**
 *  修改密码
 *
 *  @param old  旧密码
 *  @param newp 新密码
 */
-(void)changePwd:(NSString*)old new:(NSString*)newp
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithChangePwd:old new:newp];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_ChangePwd];
    
    [self postRequst:url body:body requestType:KReqestType_ChangePwd];
}

/**
 *  用户快速注册密码发送接口
 *
 *  @param phoneNumber 手机号码
 */
-(void)sendRgeSMS:(NSString*)phoneNumber
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithSendRgeSMS:phoneNumber];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_Sendregsms];
    
    [self postRequst:url body:body requestType:KReqestType_Sendregsms];
}

/**
 *  用户礼品券接口
 *
 *  @param type 类型：0全部，1未领取，2已领取
 *  @param page 当前页，不传默认为第一页
 */
-(void)coupons:(int)type page:(int)page
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithCoupons:type page:page];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_Coupons];
    
    [self postRequst:url body:body requestType:KReqestType_Coupons];
}

/**
 *  获取当前活动信息
 */
-(void)getAct
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithGetAct];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_Act];
    
    [self getRequst:url body:body requestType:KReqestType_Act];
}

/**
 *  获取活动商品详细情况信息
 *
 *  @param Id  商品id
 *  @param did 商品所在活动id
 */
-(void)getProductDetail:(NSString*)Id did:(NSString*)did
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithGetProductDetail:Id did:did];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_Gds];
    
    [self getRequst:url body:body requestType:KReqestType_Gds];
}

/**
 *  获取门店和区域详细情况信息
 */
-(void)getAreawhouse
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithGetAreawhouse];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_Areawhouse];
    
    [self getRequst:url body:body requestType:KReqestType_Areawhouse];
}

/**
 *  发送短信验证码接口
 *
 *  @param phoneNumber 手机号码
 */
-(void)sendrcode:(NSString*)phoneNumber
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithSendrcode:phoneNumber];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_Sendrcode];
    
    [self postRequst:url body:body requestType:KReqestType_Sendrcode];
}

/**
 *  用于忘记密码重新设置密码
 *
 *  @param phoneNumber 手机号码
 *  @param code        验证码
 *  @param newPwd      新密码
 */
-(void)changePwdBCode:(NSString*)phoneNumber code:(NSString*)code newPwd:(NSString*)newPwd
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithChangePwdBCode:phoneNumber code:code newPwd:newPwd];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_Changepwdbcode];
    
    [self postRequst:url body:body requestType:KReqestType_Changepwdbcode];
}

/**
 *  获取礼品券详情信息
 *
 *  @param Id 礼品券id
 */
-(void)getCouponDetail:(NSString*)Id
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithGetCouponDetail:Id];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_Getcoupon];
    
    [self getRequst:url body:body requestType:KReqestType_Getcoupon];
}

/**
 *  发送礼品券验证码
 *
 *  @param Id 礼品券id
 */
-(void)sendgfcode:(NSString*)Id
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithSendgfcode:Id];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_Sendgfcode];
    
    [self postRequst:url body:body requestType:KReqestType_Sendgfcode];
}


/**
 *  获取专题详细信息
 *
 *  @param terminalCode 终端类型：1安卓，2：ios，3安卓平板，4：ios平板
 *  @param activityId   专题活动id
 *  @param warehouseId  店铺id
 */
-(void)adetail:(NSString*)activityId warehouseid:(NSString*)warehouseId
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithAdetail:activityId warehouseid:warehouseId];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_Adetail];
    
    [self getRequst:url body:body requestType:KReqestType_Adetail];
}

/**
 *  获取一个分类的所有商品信息
 *

 *  @param type         商品类型
 *  @param warehouseId  店铺id
 */
-(void)adetailClass:(int)type warehouseid:(NSString*)warehouseId
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithAdetailClass:type warehouseid:warehouseId];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_Adetailclass];
    
    [self getRequst:url body:body requestType:KReqestType_Adetailclass];
}

/**
 *  验证短信验证码
 *
 *  @param phoneNumber 手机号码
 *  @param code        短信验证码
 */
-(void)checkCode:(NSString*)phoneNumber code:(NSString*)code
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithCheckCode:phoneNumber code:code];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, KUrl_Checkcode];
    
    [self postRequst:url body:body requestType:KReqestType_CheckCode];
}

/**
 *  购买
 *
 *  @param goodId 商品Id
 *  @param adwid  门店Id
 */
-(void)purchase:(NSString*)goodId adwid:(NSString*)adwid
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithPurchase:goodId adwid:adwid];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_Purchase];
    
    [self postRequst:url body:body requestType:KReqestType_Purchase];
}

#pragma mark- v1.0 add interface
/**
 *  获取用户默认店铺
 */
-(void)getDefWhouse
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithGetDefWHouse];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_GetdefWhouse];
    
    [self postRequst:url body:body requestType:KReqestType_Getdefwhouse];
}

/**
 *  设置用户默认店铺
 *
 *  @param wid  店铺 id
 */
-(void)setDefWhouse:(NSString*)wid
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithSetDefWHouse:wid];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_SetdefWhouse];
    
    [self postRequst:url body:body requestType:KReqestType_SetdefWhouse];
}

/**
 *  用户获取商城基本信息
 *
 *  @param a_version 区域版本号
 *  @param w_version 门店版本号
 *  @param c_version 分类版本号
 *  @param b_version 品牌版本号
 */
-(void)getBSUP:(NSString*)a_version
     w_version:(NSString*)w_version
     c_version:(NSString*)c_version
     b_version:(NSString*)b_version
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithBSUP:a_version w_version:w_version c_version:c_version b_version:b_version];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_BSUP];
    
    [self getRequst:url body:body requestType:KReqestType_BSUP];
}

/**
 *  获取普通商品详情
 *
 *  @param gId 商品id
 */
-(void)goods:(NSString*)gId
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithGoods:gId];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_Goods];
    
    [self getRequst:url body:body requestType:kreqestType_Goods];
}

/**
 *  用户获取分类商品列表信息
 *
 *  @param cid     分类 id
 *  @param page    页码
 *  @param sort    排序类型： 1 价格降序， 2 价格升序， 3 上架时间升序， 4 上架时间升序， 5 点击升序， 6 点击升序
 *  @param branId  品牌 id
 */
-(void)goodsByClass:(NSString*)cId page:(int)page sort:(int)sort brandId:(NSString*)brandId
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithGoodsByClass:cId page:page sort:sort brandId:brandId];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_GoodsByClass];
    
    [self getRequst:url body:body requestType:KReqestType_GoodsByClass];
}

/**
 *     用户获取活动专题商品列表信息
 *
 *  @param sId  专题 id
 *  @param wId  门店 id
 */
-(void)actGoodsList:(NSString*)sId wId:(NSString*)wId
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithActGoodsList:sId wId:wId];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_ActGoodsList];
    
    [self getRequst:url body:body requestType:KReqestType_ActGoodsList];
}

/**
 *      用户获取订单列表信息
 *
 *  @param type 类型 0 全部， 1 未领取， 2 已领取， 3 已取消
 *  @param page 页码
 */
-(void)myOrders:(int)type page:(int)page
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithMyOrders:type page:page];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_MyOrders];
    
    [self getRequst:url body:body requestType:KReqestType_MyOrders];
}

/**
 *   用户获取订单详情信息
 *
 *  @param Id 订单id
 */
-(void)orderDetail:(NSString*)Id
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithOrderDetail:Id];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_OrderDetail];
    
    [self getRequst:url body:body requestType:KReqestType_OrderDetail];
}

/**
 *   用户取消订单
 *
 *  @param Id 订单id
 */
-(void)cancelOrder:(NSString*)Id
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithCancelOrder:Id];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_CancelOrder];
    
    [self postRequst:url body:body requestType:KReqestType_CancelOrder];
}

/**************************************************************
 Version 1.1
 **************************************************************/

/**
 *  获取首页相关信息
 *
 */
-(void)homeInfo
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithHomeInfo];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_Home];
    
    [self getRequst:url body:body requestType:kReqestType_Home];
}

/**
 *  常规商品购买
 *
 *  @param gid 商品id
 *  @param wid 店铺id
 *  @param num 购买数量
 *  @param consigneeId 收货人id
 *  @param payType 支付方式
 */
-(void)commonBuy:(NSString*)gId num:(int)num consigneeId:(NSString*)consigneeId payType:(int)payType;
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithBuy2:gId num:num consigneeId:consigneeId payType:payType];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_buy];
    
    [self postRequst:url body:body requestType:kReqestType_Buy];
}

/**
 *  秒杀购买
 *
 *  @param did 活动id
 *  @param wid 店铺id
 */
-(void)secKillBuy:(NSString*)did wid:(NSString*)wid
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithSecKillBuy:did wId:wid];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_SekBuy];
    
    [self postRequst:url body:body requestType:kReqestType_SekBuy];
}

/**
 *   获取收货 人信息列表
 */
-(void)getConsignee
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithGetConsignee];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_Getconsignee];
    
    [self getRequst:url body:body requestType:KReqestType_Getconsignee];
}

/**
 *   修改收货 人信息 接口
 *
 *  @param Id     Id
 *  @param name    收货人 名字
 *  @param areaId  收货人 所在区域 id
 *  @param addr    收货人详细 地址
 *  @param phone   收货 人电话
 */
-(void)updateConsignee:(NSString*)Id
                  name:(NSString*)name
                areaId:(NSString*)areaId
                  addr:(NSString*)addr
                 phone:(NSString*)phone
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithUpdateConsignee:Id name:name areaId:areaId addr:addr phone:phone];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_Updateconsignee];
    
    [self postRequst:url body:body requestType:KReqestType_Updateconsignee];
}


/**
 *  确认收货接口
 *
 *  @param Id 订单id
 *
 */
-(void)finishOrder:(NSString*)Id
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithFinishOrder:Id];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_Finishorder];
    
    [self postRequst:url body:body requestType:KReqestType_Finishorder];
}

/**
 *  微信支付接口
 *
 *  @param pdtName  商品名称
 *  @param price 总价
 *  @param orderId  订单id
 */
-(void)weixinPay:(NSString*)pdtName price:(NSString*)price orderId:(NSString*)orderId
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithweixinPay:pdtName price:price orderId:orderId];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_WXPay];
    
    [self postRequst:url body:body requestType:KReqestType_weixinPay];
}

/**
 *  微信支付确认接口
 *
 *  @param orderId 订单id
 */
-(void)checkWXPay:(NSString*)orderId
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithCheckWxPay:orderId];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_Checkwxpay];
    
    [self postRequst:url body:body requestType:KReqestType_CheckWXPay];
}
/**
 *  支付宝支付接口
 *
 *  @param pdtName  商品名称
 *  @param price 总价
 *  @param orderId  订单id
 */
-(void)aliPay:(NSString*)pdtName price:(NSString*)price orderId:(NSString*)orderId
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithweixinPay:pdtName price:price orderId:orderId];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_AliPay];
    
    [self postRequst:url body:body requestType:KReqestType_AliPay];
}


/*****************************************************
 Version 1.4
 *****************************************************/

/**
 *  抽奖活动接口
 *
 *  @param uid 用户id
 */
-(void)activityIndex:(NSString*)uid
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithActivityIndex:uid];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_ActivityIndex];
    
    [self postRequst:url body:body requestType:KReqestType_ActivityIndex];
}

/**
 *  摇一摇接口
 *
 *  @param uid 用户id
 */
-(void)activityLottery:(NSString*)uid
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithActivityLottery:uid];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_ActivityLottery];
    
    [self postRequst:url body:body requestType:KReqestType_ActivityLottery];
}

/**
 *  奖品列表接口
 *
 *  @param uid 用户id
 */
-(void)activityOrderList:(NSString*)uid page:(int)page
{
    NSString *body = [[JsonBuilder sharedInstance] jsonWithActivityOrderList:uid page:page];
    NSString *url = [NSString stringWithFormat:@"%@%@", KServerAddr, Kurl_ActivityOrderlist];
    
    [self postRequst:url body:body requestType:KReqestType_ActivityOrderlist];
}
@end
