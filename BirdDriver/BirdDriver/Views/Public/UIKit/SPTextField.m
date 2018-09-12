//
//  SPTextField.m
//  BirdDriver
//
//  Created by Soul on 17/3/27.
//  Copyright © 2017年 Zhejiang Guoshi Oucheng Asset Management Co., Ltd. All rights reserved.
//

#import "SPTextField.h"

@implementation SPTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.masksToBounds = YES;
        self.tintColor = JMY_MAIN_COLOR;
    }
    return self;
}

- (void)sp_setPlaceHoder:(NSString *)text titleColor:(UIColor *)color fontSize:(float)fontSize{
    if (!kStringIsEmpty(text)) {
        self.placeholder = text;
    }
    if (color) {
        self.textColor = color;
    }
    if (fontSize) {
        self.font = [UIFont systemFontOfSize:fontSize];
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
