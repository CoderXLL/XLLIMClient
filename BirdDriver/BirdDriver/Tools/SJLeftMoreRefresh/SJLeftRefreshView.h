//
//  SJLeftRefreshView.m
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/30.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SJLeftRefreshViewState) {
    SJLeftRefreshViewStateNormal,       // 普通状态
    SJLeftRefreshViewStatePulling,      // 释放即可触发回调事件
    SJLeftRefreshViewStateReleased,     // 释放并触发回调事件
};

NS_ASSUME_NONNULL_BEGIN

@interface SJLeftRefreshView : UIView

@property (nonatomic, assign) SJLeftRefreshViewState state;

@property (nonatomic, weak, readonly) UIScrollView *scrollView;

@property (nonatomic, copy, nullable) void(^pullHandler)(void);

@property (assign, nonatomic) CGFloat pullingPercent;


/// 构造方法创建 SCTrailingPullControl，默认设置了 frame
+ (instancetype)controlWithPullHandler:(void(^)(void))handler;

- (void)endRefreshing;

@end


NS_ASSUME_NONNULL_END

