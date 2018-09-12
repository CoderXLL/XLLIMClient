//
//  SJRightAngleView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/25.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJRightAngleView.h"

@implementation SJRightAngleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, rect.size.width, 0);
    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height);
    [[UIColor colorWithHexString:@"CCCCCC" alpha:1.0] set];
    CGContextStrokePath(ctx);
}

@end
