//
//  SJBaseRefreshView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/19.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJBaseRefreshView.h"

//刷新高度44
#define SJRefreshViewHeight 64.0f
//图片宽度
#define SJImageW 0.0f
//描述宽度
#define SJLabelW 250.0f

@interface SJBaseRefreshView ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *descLabel;

@end

@implementation SJBaseRefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size.height = SJRefreshViewHeight;
    if (self = [super initWithFrame:frame])
    {
        [self setupBase];
    }
    return self;
}

- (void)setupBase
{
    CGFloat imageH = 30.f;
    CGFloat labelH = 20.f;
    CGFloat imageX = ([UIScreen mainScreen].bounds.size.width - SJImageW - SJLabelW) * 0.5;
    CGFloat imageY = (SJRefreshViewHeight - imageH) * 0.5;
    CGFloat labelY = (SJRefreshViewHeight - labelH) * 0.5;
    
    //图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, SJImageW, imageH)];
    imageView.image = [UIImage imageNamed:@""];
//    [self addSubview:imageView];
    self.imageView = imageView;
    
    //标签
//    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame), labelY, SJLabelW, labelH)];
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SJRefreshViewHeight)];
    descLabel.font = SPFont(14.0);
    descLabel.text = @"上拉即可刷新";
    descLabel.backgroundColor = [UIColor whiteColor];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.textColor = [UIColor colorWithHexString:@"2B3248" alpha:1];
    [self addSubview:descLabel];
    self.descLabel = descLabel;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    //旧的父控件移除监听
    [self.superview removeObserver:self forKeyPath:SJRefreshContentOffset context:nil];
    if (newSuperview)
    {
        //对新的父控件添加监听
        [newSuperview addObserver:self forKeyPath:SJRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
        //父控件全局化
        self.scrollView = (UIScrollView *)newSuperview;
        //原始内间距全局化
        self.originalInset = self.scrollView.contentInset;
    }
    //居中显示图片与提示信息
    self.imageView.x = (newSuperview.width - SJImageW - SJLabelW) * 0.5;
    self.descLabel.x = CGRectGetMaxX(self.imageView.frame);
}

#pragma mark - setter方法
- (void)setRefreshState:(SJRefreshState)refreshState
{
    //如果状态未改变，不需要管
    if (_refreshState == refreshState) return;
    switch (refreshState) {
        case SJRefreshStateNormal:
        {
            [self endAnimation];
            self.descLabel.text = @"上拉即可查看更多";
        }
            break;
        case SJRefreshStatePulling:
        {
            self.descLabel.text = @"松开查看更多";
        }
            break;
        case SJRefreshStateRefreshing:
        {
            [self startAnimation];
            if (self.refreshCallback)
            {
                self.refreshCallback();
            }
            self.descLabel.text = @"跳转中...";
        }
            break;
            
        default:
            break;
    }
    _refreshState = refreshState;
}

- (void)startAnimation
{
    //加载动画
}

- (void)endAnimation
{
    //结束动画
}

- (void)beginRefreshing
{
    self.refreshState = SJRefreshStateRefreshing;
}

- (void)endRefreshing
{
    self.refreshState = SJRefreshStateNormal;
}

@end
