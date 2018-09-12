//
//  SJMineNavView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJMineNavView.h"

@interface SJMineNavView ()

@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *postBtn;
@property (nonatomic, weak) UIView *sepLine;
@property (nonatomic, weak) UIButton *setBtn;

@end

@implementation SJMineNavView

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
    self.layer.shadowColor = HEXCOLOR(@"2B3248").CGColor;
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
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"我的";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIButton *postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [postBtn setImage:[UIImage imageNamed:@"nav_post_white"] forState:UIControlStateNormal];
//    postBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
//    postBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
//    postBtn.backgroundColor = [UIColor redColor];
    [postBtn addTarget:self action:@selector(postBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:postBtn];
    self.postBtn = postBtn;
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE" alpha:1];
    [self addSubview:sepLine];
    self.sepLine = sepLine;
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn setImage:[UIImage imageNamed:@"nav_set_white"] forState:UIControlStateNormal];
//    setBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
//    setBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
//    setBtn.backgroundColor = [UIColor blueColor];
    [setBtn addTarget:self action:@selector(setBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:setBtn];
    self.setBtn = setBtn;
}

- (void)postBtnClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPostBtn:)])
    {
        [self.delegate didClickPostBtn:self];
    }
}

- (void)setBtnClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickSetBtn:)])
    {
        [self.delegate didClickSetBtn:self];
    }
}

#pragma mark - setter
- (void)setBgAlpha:(CGFloat)bgAlpha
{
    self.bgView.backgroundColor = bgAlpha <= 0?[UIColor clearColor]:[UIColor whiteColor];
    self.bgView.alpha = bgAlpha;
    [self.postBtn setImage:bgAlpha<=0.4?[UIImage imageNamed:@"nav_post_white"]:[UIImage imageNamed:@"nav_post_black"] forState:UIControlStateNormal];
    self.sepLine.backgroundColor = bgAlpha<=0.4?[UIColor colorWithHexString:@"EEEEEE" alpha:1.0]:[UIColor colorWithHexString:@"2B3248" alpha:1];
    [self.setBtn setImage:bgAlpha<=0.4?[UIImage imageNamed:@"nav_set_white"]:[UIImage imageNamed:@"nav_set_black"] forState:UIControlStateNormal];
    self.titleLabel.textColor = bgAlpha <= 0.4?[UIColor whiteColor]:[UIColor colorWithHexString:@"2B3248" alpha:1];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bgView.frame = self.bounds;
    CGFloat btnW = 50;
    CGFloat statusH = iPhoneX?44:20;
    self.postBtn.frame = CGRectMake(self.width-btnW-5, (self.height-statusH-35)*0.5+statusH-1, btnW, 35);
    self.sepLine.frame = CGRectMake(self.postBtn.x-1, self.postBtn.y+7.5, 1, 20);
    self.setBtn.frame = CGRectMake(self.sepLine.x-1-btnW, self.postBtn.y, self.postBtn.width, self.postBtn.height);
    self.titleLabel.frame = CGRectMake((self.width-100)*0.5, (self.height-statusH-30)*0.5+statusH, 100, 30);
}

@end



