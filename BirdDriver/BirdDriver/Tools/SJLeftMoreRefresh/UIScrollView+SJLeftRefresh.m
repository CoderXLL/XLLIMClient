//
//  UIScrollView+SJLeftRefresh.m
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/30.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "UIScrollView+SJLeftRefresh.h"
#import <objc/runtime.h>

@implementation UIScrollView (SJLeftRefresh)

static const char *SJLeftRefreshViewKey = "SJLeftRefreshView";

- (void)setLeftRefreshView:(SJLeftRefreshView *)leftRefreshView
{
    if (leftRefreshView != self.leftRefreshView)
    {
        [self.leftRefreshView removeFromSuperview];
        [self insertSubview:leftRefreshView atIndex:0];
        // 存储新的
        objc_setAssociatedObject(self, &SJLeftRefreshViewKey, leftRefreshView, OBJC_ASSOCIATION_RETAIN);
    }
}

- (SJLeftRefreshView *)leftRefreshView
{
    return objc_getAssociatedObject(self, &SJLeftRefreshViewKey);
}

@end

