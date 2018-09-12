//
//  UIScrollView+SJFooter.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/19.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (SJFooter)

//添加上拉刷新回调
- (void)addCustomeFooterViewWithCallback:(void (^)(void))callback;

//让上拉刷新控件开始刷新
- (void)footerBeginRefreshing;

//让上拉刷新控件停止刷新
- (void)footerEndRefreshing;

@end
