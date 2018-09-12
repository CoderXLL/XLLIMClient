//
//  SJPhotoNavigationBar.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/25.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJPhotoNavigationBar.h"

@interface SJPhotoNavigationBar ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, weak) UIView *coverView;
@property (nonatomic, weak) UIButton *backBtn;

@end

@implementation SJPhotoNavigationBar

- (instancetype)init
{
    if (self = [super init])
    {
        [self setupBase];
    }
    return self;
}

- (void)setupBase
{
    self.backgroundColor = [UIColor clearColor];
    
    UIView *coverView = [[UIView alloc] init];
    [self addSubview:coverView];
    self.coverView = coverView;
    
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.0f];
    UIImage *backImage = [UIImage imageNamed:@"back_white"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"我的图册"  forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = font;
//    backBtn.backgroundColor = [UIColor redColor];
//    backBtn.imageView.backgroundColor = [UIColor blueColor];
//    backBtn.titleLabel.backgroundColor = [UIColor yellowColor];
    backBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [backBtn setImage:backImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToBack)forControlEvents:UIControlEventTouchDown];
    [self addSubview:backBtn];
    self.backBtn = backBtn;
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"2B3248" alpha:0.9].CGColor, (__bridge id)[UIColor colorWithHexString:@"2B3248" alpha:0.65].CGColor, (__bridge id)[UIColor colorWithHexString:@"2B3248" alpha:0].CGColor];
    self.gradientLayer.locations = @[@0, @0.4, @1];
    [self.coverView.layer addSublayer:self.gradientLayer];
}

- (void)popToBack
{
    if (self.popBlock)
    {
        self.popBlock();
    }
}

//重写隐藏功能
- (void)setHidden:(BOOL)hidden
{
    if (hidden) {
        
        self.y = 0;
//        self.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
            self.y = -self.height;
//            self.transform = CGAffineTransformTranslate(self.transform, 0, -CGRectGetMaxY(self.frame));
        }completion:^(BOOL finished) {
            [super setHidden:hidden];
        }];
    } else {
        [super setHidden:hidden];
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
           
            self.y = 0;
//            self.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.coverView.frame = self.bounds;
    self.gradientLayer.frame = self.coverView.layer.bounds;
    
    UIImage *backImage = [UIImage imageNamed:@"Set_back"];
    CGFloat titleImageMargin = 10;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.0f];
    CGSize size = [@"我的图册" boundingRectWithSize:CGSizeMake(10, kScreenWidth/2) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    CGFloat btnH = MIN(backImage.size.height * scale + titleImageMargin*2, 45);
    CGFloat btnW = size.width + backImage.size.width * scale + titleImageMargin*2;
    self.backBtn.frame = CGRectMake(15.0, (kNavBarHeight - 20 - btnH)/2.0+20, btnW, btnH);
    //-5微调
    self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, self.backBtn.width - backImage.size.width * scale);
    self.backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -titleImageMargin*0.5, 0, -titleImageMargin * 4);
}

@end
