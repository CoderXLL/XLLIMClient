//
//  SJUpdateTipView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/14.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJUpdateTipView.h"

@interface SJUpdateTipView ()

@property (nonatomic, weak) UIView *coverView;
@property (nonatomic, weak) UIImageView *actionView;
@property (nonatomic, weak) UIButton *touchBtn;
@property (nonatomic, weak) UIButton *closeBtn;
@property (nonatomic, weak) UILabel *tipLabel;

@property (nonatomic, copy) void(^touchBlock)(void);
@property (nonatomic, copy) NSString *appStoreVersion;

@end

@implementation SJUpdateTipView

+ (instancetype)getUpdateTipView:(NSString *)appStoreVersion touchBlock:(void(^)(void))touchBlock
{
    SJUpdateTipView *tipView = [[SJUpdateTipView alloc] init];
    tipView.touchBlock = touchBlock;
    tipView.appStoreVersion = appStoreVersion;
    return tipView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupBase];
    }
    return self;
}

- (void)setupBase
{
    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.6];
    [self addSubview:coverView];
    self.coverView = coverView;
    
    UIImageView *actionView = [[UIImageView alloc] init];
    actionView.image = [UIImage imageNamed:@"nsj_update"];
    actionView.contentMode = UIViewContentModeScaleAspectFit;
    actionView.clipsToBounds = YES;
    [self addSubview:actionView];
    self.actionView = actionView;
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.textColor = [UIColor colorWithHexString:@"2B3248" alpha:1];
//    tipLabel.backgroundColor = [UIColor blackColor];
    tipLabel.font = SPFont(15.0);
    [self addSubview:tipLabel];
    self.tipLabel = tipLabel;
    
    UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [touchBtn addTarget:self action:@selector(touchBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    touchBtn.backgroundColor = [UIColor redColor];
    [self addSubview:touchBtn];
    self.touchBtn = touchBtn;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    closeBtn.backgroundColor = [UIColor blueColor];
    [self addSubview:closeBtn];
    self.closeBtn = closeBtn;
}

#pragma mark - setter
- (void)setAppStoreVersion:(NSString *)appStoreVersion
{
    _appStoreVersion = [appStoreVersion copy];
    self.tipLabel.text = [NSString stringWithFormat:@"是否升级到%@版本?", appStoreVersion];
}

- (void)touchBtnClick
{
    if (self.touchBlock) {
        
        self.touchBlock();
    }
}

- (void)closeBtnClick
{
    [self dismiss];
}

- (void)dismiss
{
    [UIView animateWithDuration:.25f animations:^{
        self.coverView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.frame = keyWindow.bounds;
    [keyWindow addSubview:self];
    self.actionView.transform = CGAffineTransformTranslate(self.actionView.transform, 0, kSJMargin);
    self.tipLabel.transform = CGAffineTransformTranslate(self.tipLabel.transform, 0, kSJMargin);
    [UIView animateWithDuration:.3f animations:^{
        self.actionView.transform = CGAffineTransformIdentity;
        self.tipLabel.transform = CGAffineTransformIdentity;
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.coverView.frame = self.bounds;
    CGFloat actionViewW = self.width-55*2;
    CGFloat actionViewH = actionViewW * 374.0/265;
    self.actionView.frame = CGRectMake(55, (self.height-actionViewH)*0.5, actionViewW, actionViewH);
    self.tipLabel.frame = CGRectMake(self.actionView.x+30, CGRectGetMidY(self.actionView.frame), 150, 20);
    self.touchBtn.frame = CGRectMake(self.actionView.x + 10, self.actionView.centerY+55, self.actionView.width-20, 45);
    self.closeBtn.frame = CGRectMake(self.actionView.x+(self.actionView.width-60)*0.5, CGRectGetMaxY(self.actionView.frame)-35, 60, 35);
}

@end
