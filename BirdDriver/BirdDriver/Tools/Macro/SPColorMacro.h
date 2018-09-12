//
//  SPColorMacro.h
//  BirdDriver
//
//  Created by Soul on 2018/5/14.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#ifndef SPColorMacro_h
#define SPColorMacro_h

#import "UIColor+Expend.h"

#pragma mark - 颜色宏

#define RGB(r,g,b)          [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


#pragma mark - 通用颜色

#define SP_WHITE_COLOR      [UIColor whiteColor]
#define SP_BLACK_COLOR      [UIColor blackColor]
#define SP_RED_COLOR        [UIColor redColor]
#define SP_CLEAR_COLOR      [UIColor clearColor]
#define SP_ALPHA_COLOR      [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]

#endif /* SPColorMacro_h */
