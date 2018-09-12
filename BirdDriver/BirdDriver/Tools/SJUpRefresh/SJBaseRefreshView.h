//
//  SJBaseRefreshView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/19.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

//监听的鬼东西
#define SJRefreshContentOffset @"contentOffset"

//不需要MJ那么多种状态
typedef NS_ENUM(NSInteger, SJRefreshState) {
    
    SJRefreshStateNormal = 1000, //普通状态
    SJRefreshStatePulling,       //拉拽状态
    SJRefreshStateRefreshing     //刷新状态
};

@interface SJBaseRefreshView : UIView

//父控件
@property (nonatomic, weak) UIScrollView *scrollView;
//原本的内间距
@property (nonatomic, assign) UIEdgeInsets originalInset;
//当前状态
@property (nonatomic, assign) SJRefreshState refreshState;
//上拉刷新回调
@property (nonatomic, copy) void(^refreshCallback)(void);

/**
 开始刷新
 */
- (void)beginRefreshing;

/**
 结束刷新
 */
- (void)endRefreshing;

@end
