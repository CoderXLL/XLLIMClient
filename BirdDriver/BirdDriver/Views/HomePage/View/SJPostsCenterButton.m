//
//  SJPostsCenterButton.m
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/26.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJPostsCenterButton.h"

@implementation SJPostsCenterButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupBase];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setupBase];
    }
    return self;
}

- (void)setupBase
{
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.cornerRadius = 10.0;
    self.imageView.clipsToBounds = YES;
    self.enabled = NO;
    self.titleLabel.font = SPFont(12.0);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self setTitleColor:[UIColor colorWithHexString:@"2B3248" alpha:1] forState:UIControlStateDisabled];
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = [titleStr copy];
    [self setTitle:titleStr forState:UIControlStateDisabled];
    [self setNeedsLayout];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    if (kStringIsEmpty(self.titleStr))
        return CGRectZero;
    CGFloat titleWidth = [self.titleStr boundingRectWithSize:CGSizeMake(MAXFLOAT, contentRect.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SPFont(12.0)} context:nil].size.width;
    //    CGFloat titleWidth = [self.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, contentRect.size.height)].width;
    if (titleWidth > contentRect.size.width-25) {
        return CGRectMake(0, 0, 20, contentRect.size.height);
    }
    return CGRectMake((contentRect.size.width-titleWidth-25)*0.5, 0, 20, contentRect.size.height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    if (kStringIsEmpty(self.titleStr))
        return CGRectZero;
    //    CGFloat titleWidth = [self.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, contentRect.size.height)].width;
    CGFloat titleWidth = [self.titleStr boundingRectWithSize:CGSizeMake(MAXFLOAT, contentRect.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SPFont(12.0)} context:nil].size.width;
    if (titleWidth > contentRect.size.width-25) {
        return CGRectMake(25, 0, contentRect.size.width-25, contentRect.size.height);
    }
    CGFloat marginX = (contentRect.size.width-titleWidth-25)*0.5;
    return CGRectMake(marginX+20+5, 0, contentRect.size.width-2*marginX-25, contentRect.size.height);
}

//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    return CGRectMake(0, 0, 20, contentRect.size.height);
//}
//
//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    return CGRectMake(25, 0, contentRect.size.width-25, contentRect.size.height);
//}

@end
