//
//  SPButton.m
//  BirdDriver
//
//  Created by Soul on 17/3/27.
//  Copyright © 2017年 Zhejiang Guoshi Oucheng Asset Management Co., Ltd. All rights reserved.
//

#import "SPButton.h"

@interface SPButton ()

@end

@implementation SPButton

// add by polo 2017.9.9  
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setEnabled:YES];
        [self.layer setMasksToBounds:YES];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setEnabled:YES];
         self.layer.cornerRadius = 4.0f;
        [self.layer setMasksToBounds:YES];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self layoutIfNeeded];
}


- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    if (enabled) {
        [self setTitleColor:SP_WHITE_COLOR forState:UIControlStateNormal];
        [self setBackgroundColor:JMY_MAIN_COLOR];
    }else{
        [self setTitleColor:SP_WHITE_COLOR forState:UIControlStateDisabled];
        [self setBackgroundColor:JMY_BTN_DISABLD_COLOR];
    }
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
    [super setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:state];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
}

- (void)sp_setTitle:(NSString *)title titleColor:(UIColor *)color fontSize:(float)fontSize{
    self.layer.masksToBounds = YES;
    
    if (!kStringIsEmpty(title)) {
        [self setTitle:title forState:UIControlStateNormal];
    }
    if (color) {
        [self setTitleColor:color forState:UIControlStateNormal];
    }
    if (fontSize) {
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
}

- (void)sp_setBorderWidth:(float)width borderColor:(UIColor *)color cornerRadius:(float)radius{
    if (width) {
        self.layer.borderWidth = width;
    }
    if (color) {
        self.layer.borderColor = color.CGColor;
    }
    if (radius) {
        self.layer.cornerRadius = radius;
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
