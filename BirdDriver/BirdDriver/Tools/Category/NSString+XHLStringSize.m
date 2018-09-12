//
//  NSString+ZLStringSize.m
//  ZLDropDownMenuDemo
//
//  Created by zhaoliang on 16/1/27.
//  Copyright © 2016年 zhao. All rights reserved.
//

#import "NSString+XHLStringSize.h"

@implementation NSString (XHLStringSize)

- (CGSize)xhl_stringSizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight
{
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    CGSize maxSize = CGSizeMake(maxWidth, maxHeight);
    attr[NSFontAttributeName] = font;
    return [self boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attr context:nil].size;
    
}

- (CGSize)xhl_stringSizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    return [self xhl_stringSizeWithFont:font maxWidth:maxWidth maxHeight:MAXFLOAT];
}

- (CGSize)xhl_stringSizeWithFont:(UIFont *)font
{
    return [self xhl_stringSizeWithFont:font maxWidth:MAXFLOAT maxHeight:MAXFLOAT];
}

//判断输入的是否为纯空格混合换行
- (BOOL)isAllSpace{
    NSString *breakString = [self  stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    NSString *string = [breakString  stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return [string isEqualToString:@""];
}


@end
