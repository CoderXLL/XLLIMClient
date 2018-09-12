//
//  SPLabel.h
//  BirdDriver
//
//  Created by Soul on 17/3/27.
//  Copyright © 2017年 Zhejiang Guoshi Oucheng Asset Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPLabel : UILabel
- (void)sp_setTitle:(NSString *)title titleColor:(UIColor *)color fontSize:(float)fontSize;

- (void)sp_setBorderWidth:(float)width borderColor:(UIColor *)color cornerRadius:(float)radius;

@end
