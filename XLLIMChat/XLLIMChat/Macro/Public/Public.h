//
//  Public.h
//  XLLBaseProject
//
//  Created by 肖乐 on 2018/4/2.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//  公共类

//UI设定宏
#define XLLFont(size) [UIFont systemFontOfSize:(size)]
#define XLLBFont(size) [UIFont boldSystemFontOfSize:(size)]
#define XLLCGM(X, Y, W, H) CGRectMake((X), (Y), (W), (H))
#define CGMinX(_obj) CGRectGetMinX(_obj.frame)
#define CGMaxX(_obj) CGRectGetMaxX(_obj.frame)
#define CGMinY(_obj) CGRectGetMinY(_obj.frame)
#define CGMaxY(_obj) CGRectGetMaxY(_obj.frame)
#define CGWidth(_obj) CGRectGetWidth(_obj.frame)
#define CGHeight(_obj) CGRectGetHeight(_obj.frame)

// 屏幕尺寸
#define UI_SCREEN_WIDTH      ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT     ([[UIScreen mainScreen] bounds].size.height)

//色彩宏定义
#define RGBA(R, G, B, A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]
#define RGB(R, G, B) RGBA(R, G, B, 1.0)
#define RandomColor RGB(arc4random()%255, arc4random()%255, arc4random()%255)

// 全局色
#define XLLGlobalColor RGB(37, 37, 67)
// 浅色字颜色
#define XLLLightColor [@"999999" rgbColor]

// 快速创建字符串的宏定义
#define XLLStr(...) [NSString stringWithFormat:__VA_ARGS__]
// 打印日志
#ifdef DEBUG
#   define XLLLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#   define ELog(err) {if(err) XLLLog(@"%@", err)}
#else
#   define XLLLog(...)
#   define ELog(err)
#endif

//系统版本
#define IOS10_ONLY ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 11.0)
#define IOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 9.0)
#define IOS8_10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 10.0)
#define IOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IOS11 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)
#define iOSSystemVersion(SV) ([[[UIDevice currentDevice] systemVersion] floatValue] >= (SV))
//硬件版本
#define IS_IPHONE_X ([[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 812.0f)
#define IS_IPHONE_SE ([[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_6S ([[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_IPHONE_6S_PLUS ([[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f)

/** 通知宏 */
#define XLLNotificationCenter [NSNotificationCenter defaultCenter]
#define XLLUserDefaults [NSUserDefaults standardUserDefaults]

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 空值判断
static inline BOOL IsEmptyValue(id _Nullable thing) {
    return (thing == nil)
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *) thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *) thing count] == 0)
    || ([thing isKindOfClass:[NSNull class]]);
}

// 为空, 返回nil 针对NSString
static inline NSString *_Nullable checkValueNil(NSString *_Nullable value) {
    if (IsEmptyValue(value)) {
        return nil;
    }
    return value;
}

// 为空, 返回@"" 针对NSString
static inline NSString *_Nullable CheckValue(NSString *_Nullable value) {
    if (IsEmptyValue(value)) {
        return @"";
    }
    return value;
}

@interface Public : NSObject

/**
 * APP 名称
 */
+ (NSString*)appName;

/**
 * 版本号
 */
+ (NSString*)appVersion;

/**
 * Build号
 */
+ (NSString*)appBuild;

/**
 收回键盘
 */
+ (void)hideKeyboard;

/**
 公共的提示框
 */
+ (void)globalTipsVC:(UIViewController *_Nullable)vc tips:(NSString *)tips;

@end

NS_ASSUME_NONNULL_END
