//
//  SPTextView.h
//  BirdDriver
//
//  Created by Soul on 17/3/27.
//  Copyright © 2017年 Zhejiang Guoshi Oucheng Asset Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPTextView : UITextView

@property (nonatomic, strong) NSString *placeholder; //textView占位符
@property (nonatomic, strong) UIColor *placeholderColor; //占位符字体颜色

- (void)sp_setTextColor:(UIColor *)color fontSize:(float)fontSize;

- (void)sp_setBorderWidth:(float)width borderColor:(UIColor *)color cornerRadius:(float)radius;

@end
