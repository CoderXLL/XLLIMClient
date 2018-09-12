//
//  SJCommentReportView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJCommentReportView.h"

@interface SJCommentReportView ()

//蒙层
@property (nonatomic, weak) UIView *coverView;
@property (nonatomic, weak) UIButton *actionBtn;

@property (nonatomic, copy) void(^clickBlock)(void);

@end

@implementation SJCommentReportView

+ (instancetype)createCommentReportView:(void(^)(void))clickBlock
{
    SJCommentReportView *reportView = [[SJCommentReportView alloc] init];
    reportView.clickBlock = clickBlock;
    return reportView;
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
    coverView.backgroundColor = [UIColor clearColor];
    [self addSubview:coverView];
    self.coverView = coverView;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGestureClick)];
    [self.coverView addGestureRecognizer:gesture];
    
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [actionBtn setBackgroundImage:[UIImage imageNamed:@"complain_bg"] forState:UIControlStateNormal];
    [actionBtn setTitle:@"投诉" forState:UIControlStateNormal];
    [actionBtn setTitleColor:[UIColor colorWithHexString:@"2B3248" alpha:1.0] forState:UIControlStateNormal];
    actionBtn.titleLabel.font = SPFont(12.0);
    [actionBtn addTarget:self action:@selector(actionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:actionBtn];
    self.actionBtn = actionBtn;
}

- (void)tagGestureClick
{
    [self dismissView];
}

- (void)actionBtnClick
{
    [self dismissView];
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (void)showInLocation:(CGPoint)location
{
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    self.actionBtn.frame = CGRectMake(location.x-50, location.y+15, 87, 50);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.actionBtn.transform = CGAffineTransformTranslate(self.actionBtn.transform, 0, -10);
    self.actionBtn.alpha = 0.7;
    [UIView animateWithDuration:.25f animations:^{
        self.actionBtn.transform = CGAffineTransformIdentity;
        self.actionBtn.alpha = 1.0;
    }];
}

- (void)dismissView
{
    [UIView animateWithDuration:.25f animations:^{
        self.actionBtn.transform = CGAffineTransformTranslate(self.actionBtn.transform, 0, -10);
        self.actionBtn.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.coverView.frame = self.bounds;
}

@end
