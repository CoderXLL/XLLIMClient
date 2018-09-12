//
//  SJStatisticEventTool.h
//  BirdDriver
//
//  Created by Soul on 2018/8/13.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//
// 统计自定义时间，用于数据分析

#import <Foundation/Foundation.h>

#import <UMMobClick/MobClick.h>

//aabbccdd 12位表示事件，34位页面层级，56两位表示控件，78表示顺序
typedef NS_ENUM(NSInteger, UMengEventId) {
    Nsj_Event_Common    = 00000000,     //默认无参
    //===================登录注册相关==================
    Nsj_Event_LR        = 10000000,
    //===================我的页面相关==================
    Nsj_Event_Mine      = 20000000,
    //===================首页页面相关==================
    Nsj_Event_Home      = 30000000,
    //===================发现页面相关==================
    Nsj_Event_Discovery = 40000000,
};

@interface SJStatisticEventTool : NSObject

//鸟斯基行为统计，友盟id，鸟斯基id，行为名称
+ (void)umengEvent:(UMengEventId)eventId
             NsjId:(NSString *)nsjId
           NsjName:(NSString *)nsjName;

//默认无参，计数事件
//+ (void)umengEventName:(NSString *)name;

//带参数，计次事件
//+ (void)umengEvent:(UMengEventId)eventId
//             Times:(NSInteger)counter
//        Parameters:(NSDictionary *)parameters;

@end
