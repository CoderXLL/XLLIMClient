//
//  XLLTabbarView.m
//  XLLIMChat
//
//  Created by 肖乐 on 2018/7/20.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import "XLLTabbarView.h"

@interface XLLTabbarView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) CAShapeLayer *contentLayer;

@end

@implementation XLLTabbarView

#pragma mark - lazy loading
- (UILabel *)titleLabel
{
    if (_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = self.titleStr;
        _titleLabel.font = XLLFont(12.0);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        //先使用这种搞法
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIView *)contentView
{
    if (_contentView == nil)
    {
        _contentView = [[UIView alloc] init];
        [self addSubview:_contentView];
    }
    return _contentView;
}

#pragma mark - setter
- (void)setTabOrientation:(XLLTabbarViewOrientation)tabOrientation
{
    _tabOrientation = tabOrientation;
    if (tabOrientation == XLLTabbarViewOrientationMiddle)
    {
        self.titleLabel.textColor = [UIColor blueColor];
    } else {
        self.titleLabel.textColor = [UIColor lightGrayColor];
    }
}

@end
