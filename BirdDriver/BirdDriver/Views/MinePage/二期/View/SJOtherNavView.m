//
//  SJUserNavView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJOtherNavView.h"
#import "SJBackButton.h"
#import <WXApi.h>

@interface SJOtherNavView ()

@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *rightBtn;
@property (nonatomic, weak) SJBackButton *backBtn;

@end

@implementation SJOtherNavView

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
    backBtn.imageStr = @"back_white";
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popToBack)forControlEvents:UIControlEventTouchDown];
    [self addSubview:backBtn];
    self.backBtn = backBtn;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"我的";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"nav_post_white"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    self.rightBtn = rightBtn;
}

- (void)rightBtnClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(navView:didClick:)])
    {
        [self.delegate navView:self didClick:NO];
    }
}

- (void)popToBack
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(navView:didClick:)])
    {
        [self.delegate navView:self didClick:YES];
    }
}

#pragma mark - setter
- (void)setTitleName:(NSString *)titleName
{
    _titleName = [titleName copy];
    self.titleLabel.text = titleName;
}

- (void)setNavType:(SJUserNavType)navType
{
    _navType = navType;
    switch (navType) {
        case SJUserNavViewMine:
        {
            [self.rightBtn setImage:[UIImage imageNamed:@"nav_post_white"] forState:UIControlStateNormal];
            if (![WXApi isWXAppInstalled]) {
                self.rightBtn.hidden = YES;
            }
        }
            break;
        case SJUserNavViewOther:
        {
            [self.rightBtn setImage:[UIImage imageNamed:@"nav_more_white"] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

- (void)setBgAlpha:(CGFloat)bgAlpha
{
    self.bgView.backgroundColor = bgAlpha <= 0?[UIColor clearColor]:[UIColor whiteColor];
    self.bgView.alpha = bgAlpha;
    [self.backBtn setTitleColor:bgAlpha <= 0.4?[UIColor whiteColor]:[UIColor blackColor] forState:UIControlStateNormal];
    self.backBtn.imageStr = bgAlpha <= 0.4?@"back_white":@"Set_back";
    if (self.navType == SJUserNavViewMine)
    {
        [self.rightBtn setImage:bgAlpha<=0.4?[UIImage imageNamed:@"nav_post_white"]:[UIImage imageNamed:@"nav_post_black"] forState:UIControlStateNormal];
    } else {
        [self.rightBtn setImage:bgAlpha<=0.4?[UIImage imageNamed:@"nav_more_white"]:[UIImage imageNamed:@"nav_more_black"] forState:UIControlStateNormal];
    }
    self.titleLabel.textColor = bgAlpha <= 0.4?[UIColor whiteColor]:[UIColor colorWithHexString:@"2B3248" alpha:1];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bgView.frame = self.bounds;
    CGFloat statusH = iPhoneX?44:20;
    self.backBtn.frame = CGRectMake(13, (self.height-statusH-35)*0.5+statusH+5, 100, 35);
    self.rightBtn.frame = CGRectMake(self.width-57-10, (self.height-statusH-35)*0.5+statusH, 57, 35);
    CGFloat titleWidth = self.width-(CGRectGetMaxX(self.backBtn.frame)+5)-(57+10+5);
    self.titleLabel.frame = CGRectMake((self.width-titleWidth)*0.5, (self.height-statusH-20)*0.5+statusH, titleWidth, 20);
}

@end



