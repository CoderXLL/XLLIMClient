//
//  SJSuffingView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/20.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  轮播视图

#import <UIKit/UIKit.h>

@class SJSuffingView;
@protocol SJSuffingViewDelegate <NSObject>

@optional
- (void)suffingView:(SJSuffingView *)suffingView scrollToIndex:(NSInteger)index;
- (void)suffingView:(SJSuffingView *)suffingView didSelectedIndex:(NSInteger)selectedIndex;

@end

@interface SJSuffingView : UIView

//是否有圆角
@property (nonatomic, assign) BOOL isRadius;
@property (nonatomic, strong) NSArray *bannerList;
@property (nonatomic, weak) id <SJSuffingViewDelegate> delegate;

@end
