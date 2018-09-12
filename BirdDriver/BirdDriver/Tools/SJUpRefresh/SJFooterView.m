//
//  SJFooterView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/19.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJFooterView.h"

#define SJRefreshContentSize @"contentSize"

@interface SJFooterView ()

@property (assign, nonatomic) int lastRefreshCount;

@end

@implementation SJFooterView

+ (instancetype)footer
{
    return [[SJFooterView alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.refreshState = SJRefreshStateNormal;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    //原始父控件移除监听
    [self.superview removeObserver:self forKeyPath:SJRefreshContentSize context:nil];
    if (newSuperview)
    {
        //新控件监听contentSize
        [newSuperview addObserver:self forKeyPath:SJRefreshContentSize options:NSKeyValueObservingOptionNew context:nil];
        //重新调整位置
        [self setFrameWithContentSize];
    }
}

//位置调整
- (void)setFrameWithContentSize
{
    //内容的高度
    CGFloat contentHeight = self.scrollView.contentSize.height;
    //滑动视图原始高度
    CGFloat scrollHeight = self.scrollView.height-self.scrollView.contentInset.top-self.scrollView.contentInset.bottom;
    //刷新视图必须在此下方，所以找出两者最大
    self.y = MAX(contentHeight, scrollHeight);
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //仿MJ严谨逻辑处理
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;
    if ([keyPath isEqualToString:SJRefreshContentSize])
    {
        //KVO捕获了contentSize属性变换
        //调整位置
        [self setFrameWithContentSize];
    } else if ([keyPath isEqualToString:SJRefreshContentOffset]) {
        
        //偏移量变化
        if (self.refreshState == SJRefreshStateRefreshing) return;
        //重点，根据偏移量设置状态
        [self setStateWithContentOffset];
    }
}

- (void)setStateWithContentOffset
{
    //当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.contentOffset.y;
    
    //尾部控件刚好出现的offsetY
    CGFloat happenOffsetY = [self happenOffsetY];
    
    //如果是向下滚动到看不见尾部控件，直接返回
    if (currentOffsetY <= happenOffsetY) return;
    
    //滑动时
    if (self.scrollView.isDragging)
    {
        //普通状态和即将刷新状态的临界点
        CGFloat normalTopullingOffsetY = happenOffsetY + self.frame.size.height;
        
        //转为即将刷新状态
        if (self.refreshState == SJRefreshStateNormal && currentOffsetY > normalTopullingOffsetY) {
            self.refreshState = SJRefreshStatePulling;
            
            //转为普通状态
        }else if (self.refreshState == SJRefreshStatePulling && currentOffsetY <= normalTopullingOffsetY) {
            self.refreshState = SJRefreshStateNormal;
        }
        
        //松手时，如果是松开就可以进行刷新的状态，则进行刷新
    } else if (self.refreshState == SJRefreshStatePulling) {
        self.refreshState = SJRefreshStateRefreshing;
    }
}

//刚好看到descLabel控件时的垂直偏移量
- (CGFloat)happenOffsetY
{
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0)
    {
        return deltaH - self.originalInset.top;
    }
    return - self.originalInset.top;
}

//滚动视图全尺寸与高度只差
- (CGFloat)heightForContentBreakView
{
    CGFloat h = self.scrollView.height - self.originalInset.bottom - self.originalInset.top;
    return self.scrollView.contentSize.height - h;
}

- (void)setRefreshState:(SJRefreshState)refreshState
{
    //若状态未改变，直接返回
    if (self.refreshState == refreshState) return;
    
    //保存旧状态
    SJRefreshState oldState = self.refreshState;
    
    //调用父类方法
    [super setRefreshState:refreshState];
    
    switch (refreshState) {
        case SJRefreshStateNormal:
        {
            //如果由刷新状态返回到普通状态
            if (oldState == SJRefreshStateRefreshing)
            {
                [UIView animateWithDuration:0.25f animations:^{
                    UIEdgeInsets inset = self.scrollView.contentInset;
                    inset.bottom = self.originalInset.bottom;
                    self.scrollView.contentInset = inset;
                }];
            }
            CGFloat deltaH = [self heightForContentBreakView];
            int currentCount = [self totalDataCountInScrollView];
            //刚刷新完毕
            if (oldState == SJRefreshStateRefreshing && deltaH > 0 && currentCount != self.lastRefreshCount)
            {
                CGPoint offset = self.scrollView.contentOffset;
                offset.y = self.scrollView.contentOffset.y;
                self.scrollView.contentOffset = offset;
            }
        }
            break;
            
        case SJRefreshStatePulling:
            break;
            
        case SJRefreshStateRefreshing:
        {
            //记录刷新前的数量
            self.lastRefreshCount = [self totalDataCountInScrollView];
            
            [UIView animateWithDuration:0.25f animations:^{
                CGFloat bottom = self.frame.size.height + self.originalInset.bottom;
                CGFloat deltaH = [self heightForContentBreakView];
                //如果内容高度小于view的高度
                if (deltaH < 0)
                {
                    bottom -= deltaH;
                }
                UIEdgeInsets inset = self.scrollView.contentInset;
                inset.bottom = bottom;
                self.scrollView.contentInset = inset;
            }];
        }
            break;
        default:
            break;
    }
    
    self.refreshState = refreshState;
}

- (int)totalDataCountInScrollView
{
    int totalCount = 0;
    
    if ([self.scrollView isKindOfClass:[UITableView class]])
    {
        UITableView *tableView = (UITableView *)self.scrollView;
        
        for (int section = 0; section < tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
        
    } else if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self.scrollView;
        
        for (int section = 0; section < collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

@end

