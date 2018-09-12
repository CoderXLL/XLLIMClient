//
//  UIView+CircularBorder.h
//  GoldChildren
//
//  Created by 宋明月 on 2017/9/27.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CornerBorder)

/**
 * 边框颜色(16进制颜色字符串值)
 */
@property (nonatomic) IBInspectable NSString *borderColor;

/**
 * 边框宽度
 */
@property (nonatomic) IBInspectable CGFloat borderWidth;

/**
 * 边框圆角半径
 */
@property (nonatomic) IBInspectable CGFloat cornerRadius;

/**
 * 背景颜色(16进制颜色字符串值)
 */
@property (nonatomic) IBInspectable NSString *backgroundColorValue;

@end
