//
//  UIView+CircularBorder.m
//  GoldChildren
//
//  Created by 宋明月 on 2017/9/27.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import "UIView+CornerBorder.h"

@implementation UIView (CornerBorder)

@dynamic borderColor, borderWidth, cornerRadius, backgroundColorValue;

- (void) setBorderColor:(NSString *) borderColor {
    if (borderColor) {
        [self.layer setBorderColor:[self getColorFromHex:borderColor].CGColor];
    }
}

- (void) setBorderWidth:(CGFloat) borderWidth {
    [self.layer setBorderWidth:borderWidth];
}

- (void) setCornerRadius:(CGFloat) cornerRadius {
    [self.layer setCornerRadius:cornerRadius];
}

- (void) setBackgroundColorValue:(NSString *) backgroundColorValue {
    if (backgroundColorValue) {
        self.backgroundColor = [self getColorFromHex:backgroundColorValue];
    }
}

/**
 *  转换16进制颜色值为UIColor对象。
 *
 *  @param color 6进制颜色值
 *  @return UIColor对象
 */
- (UIColor*) getColorFromHex:(NSString *) color {
    NSString *strColor = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([strColor length] < 6) {
        return [UIColor clearColor];
    }
    if ([strColor hasPrefix:@"0X"] || [strColor hasPrefix:@"0x"]) {
        strColor = [strColor substringFromIndex:2];
    } else if ([strColor hasPrefix:@"#"]) {
        strColor = [strColor substringFromIndex:1];
    }
    if ([strColor length] < 6) {
        return [UIColor clearColor];
    }
    NSRange range;
    range.location = 0;
    range.length = 2;
    // 获取16进制红色颜色字符串
    NSString *redString = [strColor substringWithRange:range];
    // 获取16进制绿色颜色字符串
    range.location = 2;
    NSString *greenString = [strColor substringWithRange:range];
    // 获取16进制蓝色颜色字符串
    range.location = 4;
    NSString *blueString = [strColor substringWithRange:range];
    unsigned int red, green, blue;
    [[NSScanner scannerWithString:redString] scanHexInt:&red];
    [[NSScanner scannerWithString:greenString] scanHexInt:&green];
    [[NSScanner scannerWithString:blueString] scanHexInt:&blue];
    
    return [UIColor colorWithRed:((float)red / 255.0f) green:((float)green / 255.0f) blue:((float)blue / 255.0f) alpha:1.0f];
}
@end
