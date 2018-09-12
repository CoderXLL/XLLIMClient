//
//  SJGradientLabel.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/27.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJGradientLabel.h"

@interface SJGradientLabel ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, weak) UILabel *descLabel;

@end

@implementation SJGradientLabel

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
    self.backgroundColor = [UIColor whiteColor];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    UIColor *frontColor = [UIColor colorWithHexString:@"888888" alpha:1.0];
    UIColor *backColor = [UIColor colorWithHexString:@"939FC7" alpha:1.0];
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)frontColor.CGColor, (__bridge id)backColor.CGColor, nil];
    gradientLayer.colors = colors;
    gradientLayer.locations = @[@0, @0.65, @1.0];
    gradientLayer.cornerRadius = 4.0;
    self.layer.cornerRadius = 4.0;
    self.clipsToBounds = YES;
    [self.layer addSublayer:gradientLayer];
    self.gradientLayer = gradientLayer;
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.font = SPFont(11.0);
    descLabel.backgroundColor = [UIColor whiteColor];
    descLabel.layer.cornerRadius = 4.0;
    descLabel.clipsToBounds = YES;
    descLabel.textColor = [UIColor colorWithHexString:@"8A898A" alpha:1];
    [self addSubview:descLabel];
    self.descLabel = descLabel;
}

#pragma mark - setter
- (void)setDescStr:(NSString *)descStr
{
    _descStr = [descStr copy];
    self.descLabel.text = descStr;
}


- (void)layoutSubviews
{
    self.gradientLayer.frame = self.layer.bounds;
    self.descLabel.frame = CGRectMake(1, 1, self.width-2, self.height-2);
}

@end
