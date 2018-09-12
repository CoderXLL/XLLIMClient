//
//  JANotificationConstant.h
//  BirdDriver
//
//  Created by Soul on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//
//  通知管理中心

#ifndef JANotificationConstant_h
#define JANotificationConstant_h

#define SPNotificationCenter [NSNotificationCenter defaultCenter]

static NSString * const kNotify_Global_Error    = @"kGlobalError";                      //发送验证码

#pragma mark - 登录相关
static NSString * const kNotify_Login_Request   = @"NotificationNameLoginRequest";      //通知名-未登录
static NSString * const kNotify_loginSuccess    = @"NotificationName_loginSuccess";     //登录成功
static NSString * const kNotify_logoutSuccess   = @"NotificationName_logoutSuccess";    //登出成功

static NSString * const kNotify_isSignUp        = @"NotificationName_isSign";           //通知名-签到
static NSString * const kNotify_purchaseSuccess = @"NotificationName_purchaseSuccess";  //购买成功

static NSString * const kNotify_homeNoteDetail  = @"NotificationName_HomeNotedetail";   //首页点击帖子详情
static NSString * const kNotify_homeJump        = @"NotificationName_homeJump";         //首页左拉查看更多
static NSString * const kNotify_notePraise      = @"NotificationName_notePraise";       //帖子点赞通知

static NSString * const kNotify_routeScrollUnEnable =
    @"NotificationName_routeScrollUnEnable"; //路线详情轮播不可滚动
static NSString * const kNotify_routeScrollEnable =
@"NotificationName_routeScrollEnable"; //路线详情轮播可滚动

static NSString * const kSJSharePageKey         = @"kSJSharePageKey";                   //记录分享类型
static NSString * const kSJShareDetailsIdKey    = @"kSJShareDetailsIdKey";              //记录分享的帖子或活动ID

#endif /* JANotificationConstant_h */
