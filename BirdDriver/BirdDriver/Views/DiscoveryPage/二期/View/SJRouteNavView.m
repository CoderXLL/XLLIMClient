//
//  SJRouteNavView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJRouteNavView.h"
#import "SJBackButton.h"
#import <WXApi.h>

@interface SJRouteNavView ()

@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UIButton *postBtn;
@property (nonatomic, weak) SJBackButton *backBtn;
@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation SJRouteNavView

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
    self.layer.shadowColor = SJ_TITLE_COLOR.CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowRadius = 8;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, kScreenWidth, kNavBarHeight));
    self.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.backgroundColor = [UIColor clearColor];
    UIView *bgView = [[UIView alloc] init];
    bgView.alpha = 0;
    [self addSubview:bgView];
    self.bgView = bgView;
    
    SJBackButton *backBtn = [SJBackButton buttonWithType:UIButtonTypeCustom];
    backBtn.titleStr = @"    ";
    backBtn.imageStr = @"back_white";
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToBack)forControlEvents:UIControlEventTouchDown];
    [self addSubview:backBtn];
    self.backBtn = backBtn;
    
    UIButton *postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [postBtn setImage:[UIImage imageNamed:@"route_post_white"] forState:UIControlStateNormal];
    [postBtn addTarget:self action:@selector(postBtnClick) forControlEvents:UIControlEventTouchUpInside];
    if ([WXApi isWXAppInstalled]) {
        [self addSubview:postBtn];
    }
    self.postBtn = postBtn;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = SPFont(18.0);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"路线";
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
}

- (void)popToBack
{
    if (self.clickBlock) {
        
        self.clickBlock(YES);
    }
}

- (void)postBtnClick
{
    if (self.clickBlock) {
        self.clickBlock(NO);
    }
}

- (void)setBgAlpha:(CGFloat)bgAlpha
{
    self.bgView.backgroundColor = bgAlpha <= 0?[UIColor clearColor]:[UIColor whiteColor];
    self.bgView.alpha = bgAlpha;
    [self.backBtn setTitleColor:bgAlpha <= 0.4?[UIColor whiteColor]:[UIColor blackColor] forState:UIControlStateNormal];
    self.backBtn.imageStr = bgAlpha <= 0.4?@"back_white":@"Set_back";
    [self.postBtn setImage:bgAlpha<=0.4?[UIImage imageNamed:@"route_post_white"]:[UIImage imageNamed:@"route_post_black"] forState:UIControlStateNormal];
    self.titleLabel.textColor = bgAlpha<=0.4?[UIColor whiteColor]:[UIColor colorWithHexString:@"2B3248" alpha:1];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat statusH = iPhoneX?44:20;
    self.bgView.frame = self.bounds;
    self.backBtn.frame = CGRectMake(13, (self.height-statusH-35)*0.5+statusH+5, 100, 35);
    self.postBtn.frame = CGRectMake(self.width-57-10, (self.height-statusH-35)*0.5+statusH, 57, 35);
    self.titleLabel.frame = CGRectMake((self.width-100)*0.5, (self.height-statusH-20)*0.5+statusH, 100, 20);
}

@end

