//
//  SJLeftRefreshView.m
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/30.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJLeftRefreshView.h"


#define kStateTitleFont  [UIFont systemFontOfSize:12]
#define kStateTitleColor [UIColor blackColor]

@interface SJLeftRefreshView ()

@property (nonatomic, assign) CGFloat insetTDelta;

@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSString *>*stateTitles;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIView *coverView;

@end

@implementation SJLeftRefreshView

+ (instancetype)controlWithPullHandler:(void(^)(void))handler
{
    SJLeftRefreshView *control = [[SJLeftRefreshView alloc] init];
    control.pullHandler = handler;
    return control;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // 准备工作
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor whiteColor];
        // 设置宽度
        self.width = 80;
        
        // 默认是普通状态
        self.state = SJLeftRefreshViewStateNormal;
        
        // 初始化文字
        [self setTitle:@"左拉查看更多内容" forState:SJLeftRefreshViewStateNormal];
        [self setTitle:@"释放查看更多内容" forState:SJLeftRefreshViewStatePulling];
        [self setTitle:@"正为您跳转..." forState:SJLeftRefreshViewStateReleased];
        
        // 添加子控件
        [self addSubview:self.coverView];
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@5);
            make.centerX.equalTo(@0);
            make.top.equalTo(@20);
            make.bottom.equalTo(@-10);
        }];
        
        [self.coverView addSubview:self.arrowView];
        [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@20);
            make.centerX.mas_equalTo(self.coverView).offset(0);
            make.centerY.mas_equalTo(self.coverView).offset(-10);
        }];
        
        [self.coverView addSubview:self.stateLabel];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.mas_equalTo(self.coverView).offset(0);
            make.height.equalTo(@35);
            make.centerX.mas_equalTo(self.arrowView.mas_centerX);
            make.top.mas_equalTo(self.arrowView.mas_bottom).offset(5);
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.coverView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.coverView.layer.shadowOffset = CGSizeMake(0, 1);
    self.coverView.layer.shadowOpacity = 0.1;
    self.coverView.layer.shadowRadius = 8;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.coverView.bounds);
    self.coverView.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
}

/*
 * When a view is removed from a superview, the system sends willMoveToSuperview: to the view. The parameter is nil.
 * http://stackoverflow.com/questions/25996906/willmovetosuperview-is-called-twice
 */
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self resignObserverOfScrollView];
    
    if (newSuperview) { // 新的父控件
        // 设置高度
        self.height = newSuperview.height;
        // 设置位置
        self.y = 0;
        
        
        _scrollView = (UIScrollView *)newSuperview;
        _scrollView.alwaysBounceHorizontal = YES;
        
        // 添加监听
        [self becomeObserverOfScrollView];
    }
}

#pragma mark - KVO
- (void)becomeObserverOfScrollView
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:@"contentSize" options:options context:nil];
}

- (void)resignObserverOfScrollView
{
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    [self.superview removeObserver:self forKeyPath:@"contentSize"];;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled) return;
    
    // 这个就算看不见也需要处理
    if ([keyPath isEqualToString:@"contentSize"]) {
        [self scrollViewContentSizeDidChange:change];
    }
    
    // 看不见
    if (self.hidden) return;
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        if (self.state == SJLeftRefreshViewStateReleased) return;
        //偏移量变化
        [self scrollViewContentOffsetDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    // 当前的contentOffset
    CGFloat offsetX = self.scrollView.contentOffset.x;
    
    // 控件刚好出现的 offsetX
    CGFloat triggerOffsetX = self.scrollView.contentSize.width - self.scrollView.width + self.scrollView.contentInset.left;
    
    // 如果是向➡️滑动到看不见控件，直接返回
    if (offsetX <= triggerOffsetX) return;
    
    // 普通 和 即将触发 的临界点
    CGFloat normal2pullingOffsetX = triggerOffsetX + self.width;
    CGFloat pullingPercent = (offsetX - triggerOffsetX) / self.width;
    
    if (self.scrollView.isDragging) { // 如果正在拖拽
        self.pullingPercent = pullingPercent;
        if (self.state == SJLeftRefreshViewStateNormal && offsetX > normal2pullingOffsetX) { // 释放即可触发
            self.state = SJLeftRefreshViewStatePulling;
            
            
        } else if (self.state == SJLeftRefreshViewStatePulling && offsetX <= normal2pullingOffsetX) { // 重新变为普通状态
            self.state = SJLeftRefreshViewStateNormal;
            
            
        }
    } else if (self.state == SJLeftRefreshViewStatePulling) { // 即将触发 && 手松开
        // 开始刷新
        self.pullingPercent = 1.0;
        self.state = SJLeftRefreshViewStateReleased;
    } else if (pullingPercent < 1) {
        
        self.pullingPercent = pullingPercent;
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    // contentSize 变化时，调整位置
    self.x = self.scrollView.contentSize.width;
}

- (void)setTitle:(NSString *)title forState:(SJLeftRefreshViewState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

#pragma mark - 内部方法
- (void)executePullingHandler
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.pullHandler)
        {
            self.pullHandler();
        }
    });
//    self.state = SJLeftRefreshViewStateNormal;
}

- (void)setState:(SJLeftRefreshViewState)state
{
    SJLeftRefreshViewState oldState = self.state;
    if (state == oldState) return;
    _state = state;
    // 设置状态文字
    self.stateLabel.text = self.stateTitles[@(state)];
    
    // 根据状态做事情
    if (state == SJLeftRefreshViewStateNormal)
    {
        if (oldState == SJLeftRefreshViewStateReleased) {   // 由释放状态到普通状态
            self.pullingPercent = 0.0;
            self.arrowView.transform = CGAffineTransformIdentity;
            UIEdgeInsets inset = self.scrollView.contentInset;
            inset.right = 0;
            self.scrollView.contentInset = inset;
            
        } else {  // 有其他状态变成普通状态self.arrowView.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^{
                self.arrowView.transform = CGAffineTransformIdentity;
                UIEdgeInsets inset = self.scrollView.contentInset;
                inset.right = 0;
                self.scrollView.contentInset = inset;
            }];
        }
        
    } else if (state == SJLeftRefreshViewStatePulling) {  // 由其他状态到即将触发状态
        
        [UIView animateWithDuration:0.25 animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
        
    } else if (state == SJLeftRefreshViewStateReleased) {  // 由其他状态到释放状态
        
        [UIView animateWithDuration:0.25 animations:^{
            UIEdgeInsets inset = self.scrollView.contentInset;
            inset.right = 80+ 20;
            self.scrollView.contentInset = inset;
        }];
        [self executePullingHandler];
    }
}

- (void)endRefreshing
{
    self.state = SJLeftRefreshViewStateNormal;
}

#pragma mark - lazy loading
- (NSMutableDictionary<NSNumber *,NSString *> *)stateTitles
{
    if (_stateTitles == nil)
    {
        _stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (_stateLabel == nil)
    {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.numberOfLines = 0;
        _stateLabel.font = kStateTitleFont;
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.textColor = kStateTitleColor;
    }
    return _stateLabel;
}

- (UIImageView *)arrowView
{
    if (_arrowView == nil)
    {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftPulling"]];
        _arrowView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _arrowView;
}

- (UIView *)coverView
{
    if (_coverView == nil)
    {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor whiteColor];
    }
    return _coverView;
}

@end

