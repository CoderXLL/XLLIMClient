//
//  SJUpDownButton.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/27.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJUpDownButton.h"

@implementation SJUpDownButton

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
    self.imageView.clipsToBounds = YES;
    self.titleLabel.font = SPFont(15.0);
    self.titleLabel.textColor = [UIColor colorWithHexString:@"2B3248" alpha:1];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.backgroundColor = [UIColor blueColor];
//    self.titleLabel.backgroundColor = [UIColor yellowColor];
//    self.imageView.backgroundColor = [UIColor redColor];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width-3, contentRect.size.width-3);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, contentRect.size.width+5, contentRect.size.width, contentRect.size.height-contentRect.size.width-5);
}

@end
