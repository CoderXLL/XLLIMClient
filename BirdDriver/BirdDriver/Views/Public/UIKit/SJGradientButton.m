//
//  SJGradientButton.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJGradientButton.h"

@interface SJGradientButton ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation SJGradientButton

//快速初始化实例
+ (instancetype)gradientButton
{
    SJGradientButton *gradientBtn = [SJGradientButton buttonWithType:UIButtonTypeCustom];
    return gradientBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupBase];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setupBase];
    }
    return self;
}

- (void)setupBase
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    UIColor *frontColor = [UIColor colorWithHexString:@"2C344A" alpha:1.0];
    UIColor *backColor = [UIColor colorWithHexString:@"7283B5" alpha:1.0];
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)frontColor.CGColor, (__bridge id)backColor.CGColor, nil];
    gradientLayer.colors = colors;
    gradientLayer.locations = @[@0, @0.65, @1.0];
    [self.layer addSublayer:gradientLayer];
    self.gradientLayer = gradientLayer;
    
    [self setTitleColor:[UIColor colorWithHexString:@"FFBB04" alpha:1.0] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    self.backgroundColor = [UIColor colorWithHexString:@"ECECEC" alpha:1.0];
    
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
}

#pragma mark - setter
- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = [titleStr copy];
    [self setTitle:titleStr forState:UIControlStateNormal];
    [self setTitle:titleStr forState:UIControlStateDisabled];
}

- (void)setIsLogin:(BOOL)isLogin
{
    _isLogin = isLogin;
    if (isLogin) {
        UIColor *frontColor = [UIColor colorWithHexString:@"FFC12C" alpha:1.0];
        UIColor *backColor = [UIColor colorWithHexString:@"FCF24F" alpha:1.0];
        NSArray *colors = [NSArray arrayWithObjects:(__bridge id)frontColor.CGColor, (__bridge id)backColor.CGColor, nil];
        self.gradientLayer.colors = colors;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = SPFont(12.0);
    }
}

- (void)setEnabled:(BOOL)enabled
{
    if (enabled)
    {
        if (!self.gradientLayer.superlayer)
        {
            [self.layer insertSublayer:self.gradientLayer below:self.titleLabel.layer];
        }
    } else {
        [self.gradientLayer removeFromSuperlayer];
    }
    [super setEnabled:enabled];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.layer.cornerRadius = self.frame.size.height*0.5;
    self.layer.masksToBounds = YES;
}

@end
