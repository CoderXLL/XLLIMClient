//
//  UIColor+Expend.h
//  BirdDriver
//
//  Created by Soul on 17/3/27.
//  Copyright © 2017年 Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HEXCOLOR(hex)                       HEXCOLORA(hex,1)
#define HEXCOLORA(hex,a)                    [UIColor colorWithHexString:hex alpha:a]

@interface UIColor (Expend)


/**
 根据16进制获取颜色
 
 @param hexString @"ffffff"6位数，不带#
 @param alpha 透明通道
 @return UIColor
 */
+ (instancetype)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/**
 *  @brief  随机颜色
 *
 *  @return UIColor
 */
+ (UIColor *)randomColor;

/**
 UIColor转ffffff格式的字符串
 
 @param color 随机颜色
 @return UIColor
 */
+ (NSString *)hexStringFromColor:(UIColor *)color;

@end
