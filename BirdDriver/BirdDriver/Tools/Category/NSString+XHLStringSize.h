//
//  NSString+ZLStringSize.h
//  ZLDropDownMenuDemo
//
//  Created by zhaoliang on 16/1/27.
//  Copyright © 2016年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface NSString (XHLStringSize)

- (CGSize)xhl_stringSizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight;
- (CGSize)xhl_stringSizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;
- (CGSize)xhl_stringSizeWithFont:(UIFont *)font;
//判断输入的是否为纯空格混合换行
- (BOOL)isAllSpace;

@end
