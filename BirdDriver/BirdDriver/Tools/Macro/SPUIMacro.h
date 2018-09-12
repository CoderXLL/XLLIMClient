//
//  UIMacro.h
//  HxhFinancialNew
//
//  Created by Soul on 2017/6/23.
//  Copyright © 2017年 Zhejiang Guoshi Oucheng Asset Management Co., Ltd. All rights reserved.
//

#ifndef UIMacro_h
#define UIMacro_h

#import "UIView+QuickFrame.h"

#define HUD_TimeInterval_default .4f
#define kSJMargin                15.0  //鸟司机边缘间距

/*
 *手机屏幕判断
 */
#pragma mark - 手机屏幕判断

#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1080, 1920), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

/*
 *屏幕高度尺寸计算
 */
#pragma mark - 屏幕高度尺寸计算

#define kUIBounds [[UIScreen mainScreen] bounds]
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kNavBarHeight (iPhoneX ? 88 : 64)
#define kTabBarHeight 49
#define kSegementHeight 50.0f
#define kStatusBarHeight  [[UIApplication sharedApplication] statusBarFrame].size.height

#define kLine_HeightT_1_PPI         (1/[UIScreen mainScreen].scale)
#define NullDataView_defaultSize    CGSizeMake(200,240)  //暂无数据视图大小

#pragma mark - 字体
#define SPFont(size)  [UIFont systemFontOfSize:(size)]
#define SPBFont(size) [UIFont boldSystemFontOfSize:(size)]

//判断设备的操做系统是不是小于ios9


#define IOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 9.0)
#define IOS8_10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 10.0)
#define IOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IOS11 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)

#endif /* UIMacro_h */

