//
//  UIScrollView+SJFooter.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/19.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "UIScrollView+SJFooter.h"
#import "SJFooterView.h"
#import <objc/runtime.h>

@interface UIScrollView ()

@property (weak, nonatomic) SJFooterView *customeFooterView;

@end

@implementation UIScrollView (SJFooter)
static char SJFooterViewKey;

#pragma mark - setter, getter
- (void)setCustomeFooterView:(SJFooterView *)customeFooterView
{
    [self willChangeValueForKey:@"SJFooterViewKey"];
    objc_setAssociatedObject(self, &SJFooterViewKey, customeFooterView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"SJFooterViewKey"];
}

- (SJFooterView *)customeFooterView
{
    return objc_getAssociatedObject(self, &SJFooterViewKey);
}


- (void)addCustomeFooterViewWithCallback:(void (^)(void))callback
{
    if (!self.customeFooterView)
    {
        SJFooterView *footer = [SJFooterView footer];
        footer.backgroundColor = [UIColor redColor];
        [self addSubview:footer];
        self.customeFooterView = footer;
    }
    self.customeFooterView.refreshCallback = callback;
}

- (void)footerBeginRefreshing
{
    [self.customeFooterView beginRefreshing];
}

- (void)footerEndRefreshing
{
    [self.customeFooterView endRefreshing];
}

@end

