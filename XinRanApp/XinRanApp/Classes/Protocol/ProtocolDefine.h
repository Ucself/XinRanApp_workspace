//
//  ProtocolDefine.h
//  XinRanApp
//
//  Created by tianbo on 14-12-5.
//  Copyright (c) 2014年 deshan.com All rights reserved.
//
//
//  通信协议基础定义

#ifndef XinRanApp_ProtocolDefine_h
#define XinRanApp_ProtocolDefine_h

#pragma mark- url 定义

//#define KDeveloperServer
#define KFinalServer
//#define KQAServer
//#define KTuBinTestServer
//#define HPKServer

//测试地址
#ifdef KTuBinTestServer
#define KServerAddr                @"http://192.168.0.38:9099/api"
#define KImageDonwloadAddr         @"http://192.168.0.38:9099"
#endif

//开发环境地址
#ifdef KDeveloperServer
#define KServerAddr                @"http://192.168.1.10:80/api"
#define KImageDonwloadAddr         @"http://192.168.1.10:80"
#endif

//正式地址
#ifdef KFinalServer
#define KServerAddr                @"http://www.xinran.com/api"
#define KImageDonwloadAddr         @"http://www.xinran.com"
#endif

//QAserver
#ifdef KQAServer
#define KServerAddr                @"http://192.168.1.22:8082/api"
#define KImageDonwloadAddr         @"http://192.168.1.22:8082"
#endif

//HPKServer
#ifdef HPKServer
#define KServerAddr                @"http://192.168.1.52:9013/api"
#define KImageDonwloadAddr         @"http://192.168.1.52:9013"
#endif


/******************************************************
 *  v0.6 接口
 ******************************************************/

//用户注册接口  POST
#define KUrl_Register              @"/user/regist/"

//用户登录接口  POST
#define KUrl_Login                 @"/user/login/"

//用户注销接口  POST
#define KUrl_Logout                @"/user/logout/"

//修改密码接口  POST
#define KUrl_ChangePwd             @"/user/changepwd/"

//用户快速注册密码发送接口  POST
#define KUrl_Sendregsms            @"/user/sendregsms/"

//用户礼品券接口, v1.0废除
#define KUrl_Coupons               @"/user/coupons/"

//获取活动接口   GET
#define KUrl_Act                   @"/act/"

//商品详情接口  GET
#define KUrl_Gds                   @"/gds/"

//区域和门店数据接口  GET
#define KUrl_Areawhouse            @"/areawhouse/"

//发送短信验证码接口  POST
#define KUrl_Sendrcode             @"/user/sendrcode/"

//忘记密码接口  POST
#define KUrl_Changepwdbcode        @"/user/changepwdbcode/"

//礼品券详情接口, v1.0废除
#define KUrl_Getcoupon             @"/user/getcoupon/"

//礼品券验证码发送接口  POST
#define KUrl_Sendgfcode            @"/user/sendgfcode/"

//首页信息获取接口  GET
#define KUrl_Index                 @"/index/"

//专题详细信息获取接口  GET
#define KUrl_Adetail               @"/adetail/"

//商品分类获取接口  GET
#define KUrl_Adetailclass          @"/adetailclass/"

//验证短信验证码
#define KUrl_Checkcode             @"/user/checkrcode/"

//购买接口
#define Kurl_Purchase              @"/order/purchasegift/"

/******************************************************
 *  v1.0 接口
 ******************************************************/

//获取用户默认店铺 接口  POST
#define Kurl_GetdefWhouse              @"/user/getdefwhouse/"

// 设置用户默认店铺 接口 POST
#define Kurl_SetdefWhouse              @"/user/setdefwhouse/"

// 用户获取商城基本信息 接口  GET
#define Kurl_BSUP                      @"/bsup/"

// 用户获取分类商品列表信息 接口   GET
#define Kurl_GoodsByClass              @"/goodsbyclass/"

// 用户获取分类商品详细信息 接口  GET
#define Kurl_Goods                     @"/goods/"

// 用户获取活动专题商品列表信息 接口  GET
#define Kurl_ActGoodsList              @"/actgoodslist/"

// 用户获取订单列表信息 接口 GET
#define Kurl_MyOrders                  @"/user/myorders/"

// 用户获取订单详情信息 接口 GET
#define Kurl_OrderDetail               @"/user/order/"

// 用户取消订单 接口 POST
#define Kurl_CancelOrder               @"/user/cancelorder/"



/******************************************************
 *  v1.0 接口
 ******************************************************/
// 首页数据接口（最新 ）  GET
#define Kurl_Home                 @"/home"

// 常规商品购买接口   POST
#define Kurl_buy                  @"/buy"

// 秒杀商品购买接口   POST
#define Kurl_SekBuy               @"/sekbuy"

// 微信支付接口
#define Kurl_wxpay                @"/wxpay"


/******************************************************
 *  v1.3 接口
 ******************************************************/

//  获取收货 人信息列表 接口
#define Kurl_Getconsignee               @"/getconsignee"

// 修改收货 人信息 接口
#define Kurl_Updateconsignee            @"/updateconsignee"

// 确认收货接口
#define Kurl_Finishorder                @"/user/finishorder/"

// 微信支付接口
#define Kurl_WXPay                      @"/wxpay"

// 支付宝支付接口
#define Kurl_AliPay                     @"/alipay"

//微信支付确认接口
#define Kurl_Checkwxpay                 @"/checkwxpay"


/******************************************************
 *  v1.4 接口
 ******************************************************/

// 抽奖活动 接口
#define Kurl_ActivityIndex               @"/activity/index/"

// 摇一摇 接口
#define Kurl_ActivityLottery             @"/activity/lottery/"

// 奖品列表 接口
#define Kurl_ActivityOrderlist             @"/activity/orderlist/"

//****************************************************************
#define KResultCode                @"resultcode"
#define KResultInfo                @"errorinfo"

//请求类型
typedef enum {
    KReqestType_Login = 0,
    KReqestType_Register,
    KReqestType_Logout,
    KReqestType_ChangePwd,
    KReqestType_Sendregsms,
    KReqestType_Coupons,
    KReqestType_Act,
    KReqestType_Gds,
    KReqestType_Areawhouse,
    KReqestType_Sendrcode,
    KReqestType_Changepwdbcode,
    KReqestType_Getcoupon,
    KReqestType_Sendgfcode,
    KReqestType_Index,
    KReqestType_Adetail,
    KReqestType_Adetailclass,
    KReqestType_CheckCode,
    KReqestType_Purchase,
    //v1.0
    KReqestType_Getdefwhouse,
    KReqestType_SetdefWhouse,
    KReqestType_BSUP,
    KReqestType_GoodsByClass,
    KReqestType_ActGoodsList,
    KReqestType_MyOrders,
    KReqestType_OrderDetail,
    KReqestType_CancelOrder,
    kreqestType_Goods,
    
    //v1.1
    kReqestType_Home,
    kReqestType_Buy,
    kReqestType_SekBuy,
    
    
    //1.3
    KReqestType_Getconsignee,
    KReqestType_Updateconsignee,
    KReqestType_Finishorder,
    KReqestType_weixinPay,
    KReqestType_CheckWXPay,
    KReqestType_AliPay,
    
    //1.4 抽奖
    KReqestType_ActivityIndex,
    KReqestType_ActivityLottery,
    KReqestType_ActivityOrderlist,
}RequestType;




//登示类型
typedef enum{
    LoginType_Phone = 0,
    LoginType_Email,
}LoginType;



#pragma mark- 回调消息通知
//请求回调消息通知
#define KNotification_RequestFinished     @"HttpRequestFinishedNoitfication"
#define KNotification_RequestFailed       @"HttpRequestFailedNoitfication"
#define KNotification_UserLoginDone       @"HttpRequestUserLoginDoneNoitfication"

#pragma mark- JSON基础字符串定义
#define KTerminalCode                      @"2"                        //终端类型：1安卓，2：ios，3：安卓平板，4：ios平板
#define KJsonElement_Result                @"result"                   //返回结果
#define KJsonElement_Token                 @"token"                    //
#define KJsonElement_Version               @"version"
#define KJsonElement_User                  @"user"                     //
#define KJsonElement_Type                  @"type"                     //
#define KJsonElement_Name                  @"name"                     //
#define KJsonElement_ID	                   @"id"                       //
#define KJsonElement_GID	               @"gid"                       //
#define KJsonElement_Did                   @"did"                      //活动id
#define KJsonElement_ADid                  @"adid"                     //活动id
#define KJsonElement_Data                  @"data"                     //
#define KJsonElement_State                 @"state"                    //
#define KJsonElement_States                @"states"
#define KJsonElement_UId                   @"uid"

//用户相关
#define KJsonElement_Terminal            @"terminal"                   //终端类型：1安卓，2：ios，3：安卓平板，4：ios平板
#define KJsonElement_Password            @"password"                   //
#define KJsonElement_Pwd                 @"pwd"
#define KJsonElement_SPhone              @"sphone"                     //密保手机号码
#define KJsonElement_UserName            @"username"                   //
#define KJsonElement_Phone               @"phone"                      //手机号码
#define KJsonElement_OldPwd              @"oldpwd"                     //
#define KJsonElement_NewPwd              @"newpwd"                     //
#define KJsonElement_Code                @"code"                       //验证码
#define KjsonElement_Agrades_name        @"agrades_name"               //等级名称
#define KjsonElement_grades              @"grades"                     //等级名称
#define KJsonElement_Card_no             @"card_no"                    //会员卡号
#define KjsonElement_email               @"email"                      //邮件
#define KjsonElement_last_login_time     @"last_login_time"            //最后登录时间


//首页
#define KJsonElement_Seckills            @"seckills"                       //秒杀商品信息列表
#define KJsonElement_New_goods           @"new_goods"                      //新品列表
#define KJsonElement_Commond_goods       @"commond_goods"     //推荐列表
#define KJsonElement_LinkType            @"link_type"                      //广告参数
#define KJsonElement_LinkUrl             @"link_url"                       //广告参数
#define KJsonElement_Seconds             @"seconds"                        //秒杀参数
#define KJsonElement_ArrayKills          @"ArrayKills"                        //秒杀数组

//订单相关
#define KJsonElement_Page                @"page"                    //当前页
#define KJsonElement_Count               @"count"                   //总数量
#define KJsonElement_Pages               @"pages"                   //总页数
#define KJsonElement_SN                  @"sn"                      //订单编号
#define KJsonElement_WhouseAddress       @"whouseaddress"           //店铺地址
#define KJsonElement_WhouseNames         @"whousename"              //店铺名称
#define KJsonElement_BuyerName           @"buyername"               //店铺名称

//商品活动信息
#define KJsonElement_Ads                 @"ads"                     //广告信息列表
#define KJsonElement_Current             @"current"                 //当前活动
#define KJsonElement_Next                @"next"                    //下一期活动
#define KJsonElement_Before              @"before"                  //上一期活动
#define KJsonElement_Goods               @"goods"                   //商品对象数
#define KJsonElement_Gc                  @"gc"                      //类型
#define KJsonElement_Image               @"image"                   //图片地址
#define KJsonElement_Price               @"price"                   //价格
#define KJsonElement_Price1              @"price1"                  //价格
#define KJsonElement_OldPrice            @"old_price"                  //价格
#define KJsonElement_Desc                @"desc"                    //描述
#define KJsonElement_Body                @"body"                    //详细信息
#define KJsonElement_Comd                @"comd"                    //是否推荐
#define KJsonElement_Start               @"start"                   //是否开始
#define KJsonElement_Sconds              @"sconds"                  //剩余时间
#define KJsonElement_Limit               @"limit"                   //限制数量
#define KJsonElement_Limit_buy           @"limit_buy"
#define KJsonElement_Limit_grades        @"limit_grades"            //限制等级
#define KJsonElement_Pic                 @"pic"                     //图片
#define KJsonElement_Url                 @"url"                     //url
#define KJsonElement_Video               @"video"                   //媒体信息
#define KJsonElement_Status              @"status"                  //状态
#define KJsonElement_Pid                 @"pid"                     //活动id
#define KJsonElement_Order               @"order"                   //
#define KJsonElement_CreateDate          @"create_date"             //
#define KJsonElement_Commends            @"commends"                //推荐商品

#define KJsonElement_Images              @"images"                  //图片列表
#define KJsonElement_Num                 @"num"                     //数量
#define KJsonElement_CouponPrice         @"coupon_price"            //礼品价格
#define KJsonElement_StartDate           @"startdate"               //开始时间
#define KJsonElement_Start_Date           @"start_date"             //开始时间
#define KJsonElement_AddTime              @"addtime"             //开始时间

#define KJsonElement_Sale                @"sale"                    //
#define KJsonElement_Remaind             @"remaind"                 //
#define KJsonElement_Icon                @"icon" 
#define KJsonElement_GoodsId             @"goodsid"



//门店相关
#define KJsonElement_WID                 @"wid"                  //门店id
#define KJsonElement_Warehouseid         @"warehouseid"                  //门店id
#define KJsonElement_Whouse              @"whouse"                       //门店信息
#define KJsonElement_Areas               @"areas"                        //区域信息
#define KJsonElement_Address             @"address"                      //领取地址
#define KJsonElement_Adwid               @"adwid"                        //
#define KJsonElement_Areaid              @"area"                         //
#define KJsonElement_Goodsn              @"goodsn"                       //
#define KJsonElement_Saled               @"saled"                        //
#define KJsonElement_Whouses             @"whouses"
#define KJsonElement_Latitude            @"latitude"                     //纬度
#define KJsonElement_Longitude           @"longitude"                    //经度
#define KJsonElement_WList               @"wlist"
#define KJsonElement_Storate             @"storate"

//订单详情
#define KJsonElement_Area_Id             @"area_id"                  //收货人区域id
#define KJsonElement_Consignee_Id        @"consignee_id"             //收货人id
#define KJsonElement_Pay_Type            @"pay_type"                 //支付方式

#define KJsonElement_consignee            @"consignee"              //收货人
#define KJsonElement_finnshed_time        @"finnshed_time"          //订单完成时间
#define KJsonElement_payment_id           @"payment_id"             //支付方式
#define KJsonElement_payment_name         @"payment_name"           //支付名称
#define KJsonElement_payment_time         @"payment_time"           //支付时间
#define KJsonElement_shipping_code        @"shipping_code"          //物流编号
#define KJsonElement_shipping_company     @"shipping_company"       //物流公司
#define KJsonElement_shipping_time        @"shipping_time"          //送货时间

//专题相关
#define KJsonElement_Activities                   @"activities"                //专题数组
#define KJsonElement_ActivityId                   @"activityid"
#define KJsonElement_Activity_title               @"activity_title"
#define KJsonElement_Activity_banner              @"activity_banner"
#define KJsonElement_Activity_desc                @"activity_desc"
#define KJsonElement_Activity_start_date          @"activity_start_date"
#define KJsonElement_Activity_end_date            @"activity_end_date"


//商城版本信息
#define KJsonElement_AVersion                   @"a_version"
#define KJsonElement_WVersion                   @"w_version"
#define KJsonElement_CVersion                   @"c_version"
#define KJsonElement_BVersion                   @"b_version"

#define KJsonElement_CID                        @"cid"        //分类id
#define KJsonElement_Sort                       @"sort"       //排序类型
#define KJsonElement_SID                        @"sid"        //专题 id

//品牌信息
#define KJsonElement_BrandId                    @"brandid"       //品牌id
#define KJsonElement_Brands                     @"brands"        //品牌数组
#define KJsonElement_BrandsDesc                 @"brand_desc"    //品牌描述

//商品分类
#define KJsonElement_GClass                     @"gclass"              //分类
#define KJsonElement_GCName                     @"gc_name"             //分类名称
#define KJsonElement_GCPID                      @"gc_parent_id"        //
#define KJsonElement_GCSort                     @"gc_sort"             //
#define KJsonElement_Iconfilepath               @"icon_file_path"      //

#define KJsonElement_TotalFee                   @"total_fee"
#define KJsonElement_Trade_no                   @"out_trade_no"
#define KJsonElement_OID                        @"oid"

#endif


