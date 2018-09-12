//
//  SJStarView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJStarView.h"
#define th M_PI/180

@interface SJMyStarView : UIView

@property(nonatomic,strong) UIColor *startColor;
@property(nonatomic,strong) UIColor *boundsColor;
@property(nonatomic) CGFloat radius;
//范围 0-1
@property(nonatomic) CGFloat value;// 范围 0到1

@end

@implementation SJMyStarView

#pragma mark -
#pragma mark - 基本配置
- (void)baseInit {
    self.value = 1;
    self.startColor = [UIColor colorWithHexString:@"FFBB04" alpha:1.0];
    self.backgroundColor = [UIColor clearColor];
    self.boundsColor = [UIColor colorWithHexString:@"ECECEC" alpha:1];
}

#pragma mark -
#pragma mark - 初始化
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    // 更新radius
    [self updateRadiusWithFrame:frame];
    
    // 默认是YES.
    self.opaque = NO;
    
    // 基本配置
    [self baseInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    // 更新radius
    [self updateRadiusWithFrame:self.frame];
    
    // 基本配置
    [self baseInit];
    
    return self;
}


#pragma mark -
#pragma mark - 调整frame
- (void)setFrame:(CGRect)frame {
    // 更新radius
    [self updateRadiusWithFrame:frame];
    
    [super setFrame:frame];
    
    // 重绘
    [self setNeedsDisplay];
    
}

// 更新radius
- (void)updateRadiusWithFrame:(CGRect)frame {
    CGFloat x = frame.size.width / 2;
    CGFloat y = frame.size.height / 2;
    self.radius = x < y ? x:y;
}

#pragma mark -
#pragma mark - 设置value
- (void)setValue:(CGFloat)value {
    if (value < 0) {
        _value = 0;
    } else if(value > 1) {
        _value = 1;
    } else {
        _value = value;
    }
    
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark - 绘制
- (void)drawRect:(CGRect)rect {
    
    
    for (NSInteger i = 0; i < 2; i++)
    {
        CGFloat centerX = rect.size.width / 2;
        CGFloat centerY = rect.size.height / 2;
        
        CGFloat r0 = self.radius * sin(18 * th)/cos(36 * th); /*计算小圆半径r0 */
        CGFloat x1[5]={0},y1[5]={0},x2[5]={0},y2[5]={0};
        
        for (int i = 0; i < 5; i ++) {
            x1[i] = centerX + self.radius * cos((90 + i * 72) * th); /* 计算出大圆上的五个平均分布点的坐标*/
            y1[i]=centerY - self.radius * sin((90 + i * 72) * th);
            x2[i]=centerX + r0 * cos((54 + i * 72) * th); /* 计算出小圆上的五个平均分布点的坐标*/
            y2[i]=centerY - r0 * sin((54 + i * 72) * th);
        }
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGMutablePathRef startPath = CGPathCreateMutable();
        CGPathMoveToPoint(startPath, NULL, x1[0], y1[0]);
        
        for (int i = 1; i < 5; i ++) {
            CGPathAddLineToPoint(startPath, NULL, x2[i], y2[i]);
            CGPathAddLineToPoint(startPath, NULL, x1[i], y1[i]);
        }
        CGPathAddLineToPoint(startPath, NULL, x2[0], y2[0]);
        CGPathCloseSubpath(startPath);
        CGContextAddPath(context, startPath);
        if (i == 0)
        {
            CGContextSetFillColorWithColor(context, self.boundsColor.CGColor);
            
            CGContextSetStrokeColorWithColor(context, self.boundsColor.CGColor);
            CGContextFillPath(context);
        } else {
            CGContextSetFillColorWithColor(context, self.startColor.CGColor);
            CGContextSetStrokeColorWithColor(context, self.boundsColor.CGColor);
            CGContextStrokePath(context);
        }
        
        CGRect range = CGRectMake(x1[1], 0, (x1[4] - x1[1]) * self.value , y1[2]);
        CGContextAddPath(context, startPath);
        CGContextClip(context);
        CGContextFillRect(context, range);
        CFRelease(startPath);
    }
}

@end

@implementation SJStarView

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
    for (NSInteger i = 0; i < 5; i++)
    {
        CGFloat starWidth = (self.width-4*3)/5.0;
        SJMyStarView *myStarView = [[SJMyStarView alloc] initWithFrame:CGRectMake((starWidth+2)*i, 0, starWidth, self.height)];
        [self addSubview:myStarView];
    }
}

- (void)setValue:(CGFloat)value
{
    _value = value;
    CGFloat realValue = value*0.5;
    NSInteger intValue = floorf(realValue);
    NSInteger j = 0;
    for (NSInteger i = 0; i < self.subviews.count; i++)
    {
        UIView *subView = self.subviews[i];
        if ([subView isKindOfClass:[SJMyStarView class]])
        {
            SJMyStarView *myStarView = (SJMyStarView *)subView;
            if (intValue == 0)
            {
                if (j == 0)
                {
                    myStarView.value = realValue-intValue;
                } else {
                    myStarView.value = 0;
                }
            } else {
                if (j < intValue)
                {
                    myStarView.value = 1.0;
                } else if (j == intValue) {
                    myStarView.value = realValue-intValue;
                } else {
                    myStarView.value = 0;
                }
            }
            j++;
        }
    }
}

@end
