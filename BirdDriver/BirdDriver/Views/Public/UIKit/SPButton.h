//
//  SPButton.h
//  BirdDriver
//
//  Created by Soul on 17/3/27.
//  Copyright © 2017年 Zhejiang Guoshi Oucheng Asset Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIButton+WebCache.h>

@interface SPButton : UIButton

/**
 工厂方法设置数据

 @param title 设置按钮标题
 @param color 设置按钮标题颜色
 @param fontSize 设置字体大小
 */
- (void)sp_setTitle:(NSString *)title
         titleColor:(UIColor *)color
           fontSize:(float)fontSize;


/**
 工厂方法设置边框

 @param width 设置边框线
 @param color 设置边框颜色
 @param radius 设置圆角大小
 */
- (void)sp_setBorderWidth:(float)width
              borderColor:(UIColor *)color
             cornerRadius:(float)radius;


@end
