//
//  SJLineView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/16.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJLineView.h"

#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

@implementation SJLineView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    CGFloat pixelAdjustOffset = 0;
    // 落在奇数位置的显示单元上
    if (((int)(1* [UIScreen mainScreen].scale) + 1) % 2 == 0)
    {
        pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
    }
    // 设置画线y值
    CGFloat yPos = 1 - pixelAdjustOffset;
    //在view的最底部画线
    while (yPos + 1 < self.bounds.size.height) {
        yPos ++;
    }
    CGContextMoveToPoint(context, 0, yPos);
    CGContextAddLineToPoint(context, self.bounds.size.width, yPos);
    
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, self.backgroundColor.CGColor);
    CGContextStrokePath(context);
}
@end
