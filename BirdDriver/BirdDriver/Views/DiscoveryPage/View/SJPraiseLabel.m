//
//  SJPraiseLabel.m
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJPraiseLabel.h"

@interface SJPraiseLabel ()
{
    BOOL _has_centerPoint_detect;
}

//自定义颜色
@property (nonatomic, strong) UIColor *customeColor;
//数组
@property (nonatomic, strong) NSArray <NSString *>*sepStrArr;
@property (nonatomic, strong) NSArray <UILabel *>*sepLabelArr;

@end

@implementation SJPraiseLabel

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
    self.customeColor = self.textColor;
    self.textColor = [UIColor clearColor];
}

#pragma mark - private method
- (UILabel *)createLabelWithString:(NSString *)numberStr
{
    UILabel *label = [[UILabel alloc] init];
    label.font = self.font;
    label.textColor = self.customeColor?self.customeColor:self.textColor;
    label.textAlignment = NSTextAlignmentLeft;
    label.text = numberStr;
    [label sizeToFit];
    return label;
}

- (void)operateWithTargetString:(NSString *)string
{
    __weak typeof(self)weakSelf = self;
    [self seprateStringToSingleWithTarget:string operateHandler:^(NSMutableArray<NSString *>*sepStrArr, NSMutableArray<UILabel *>*sepLabelArr) {
        [weakSelf showScrollAnimiationWithSepStrArr:sepStrArr sepLableArr:sepLabelArr];
    }];
}

- (void)showScrollAnimiationWithSepStrArr:(NSArray <NSString *>*)sepStrArr sepLableArr:(NSArray <UILabel *> *)sepLabelArr{
    NSInteger targetLength = sepLabelArr.count;
    //原本的长度
    NSInteger oldLength = self.sepLabelArr.count;
    //再遍历
    for (NSInteger i = 0; i < targetLength; i++)
    {
        NSInteger targetIndex = targetLength-i-1;
        NSInteger oldTargetIndex = oldLength-i-1;
        //还没达到最大
        if (i < oldLength) {
            //中间有个数改变了
            if (![sepStrArr[targetIndex] isEqualToString:self.sepStrArr[oldTargetIndex]]) {
                //判断是增加了还是减少了
                BOOL isIncrease = sepStrArr[targetIndex].integerValue > self.sepStrArr[oldTargetIndex].integerValue;
                //找到对应的那个label
                UILabel *oldLabel = self.sepLabelArr[oldTargetIndex];
                CGRect oldTargetFrame = CGRectOffset(oldLabel.frame, 0, (isIncrease?-1:1)*oldLabel.height);
                UILabel *currentLabel = sepLabelArr[targetIndex];
                CGRect labelFrame = currentLabel.frame;
                CGRect currentFrame = CGRectOffset(labelFrame, 0, (isIncrease?1:-1)*currentLabel.height);
                currentLabel.frame = currentFrame;
                currentLabel.alpha = 0;
                [UIView animateWithDuration:.25f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    
                    oldLabel.frame = oldTargetFrame;
                    currentLabel.frame = labelFrame;
                    oldLabel.alpha = 0;
                    currentLabel.alpha = 1.0;
                } completion:^(BOOL finished) {
                    [oldLabel removeFromSuperview];
                }];
            } else {
                //如果相等，移除老label即可
                [self.sepLabelArr[oldTargetIndex] removeFromSuperview];
            }
        } else {
            //新的已经超越了原有位数
            //独一无二新label
            UILabel *currentLabel = sepLabelArr[targetIndex];
            CGRect labelFrame = currentLabel.frame;
            currentLabel.frame = CGRectOffset(labelFrame, 0, -labelFrame.size.height);
            currentLabel.alpha = 0;
            [UIView animateWithDuration:.25f animations:^{
                
                currentLabel.frame = labelFrame;
                currentLabel.alpha = 1.0;
            } completion:nil];
        }
    }
    
    //如果新的遍历之后，老的还有的话。也就是新位数较于老位数有所下降
    if (oldLength > targetLength)
    {
        for (NSInteger i = 0; i < oldLength-targetLength; i++)
        {
            UILabel *oldLabel = self.sepLabelArr[i];
            CGRect oldTargetFrame = CGRectOffset(oldLabel.frame, 0, -1*oldLabel.height);
            [UIView animateWithDuration:.25f animations:^{
                oldLabel.frame = oldTargetFrame;
                oldLabel.alpha = 0;
            } completion:^(BOOL finished) {
                [oldLabel removeFromSuperview];
            }];
        }
    }
    self.sepStrArr = sepStrArr;
    self.sepLabelArr = sepLabelArr;
}

- (void)seprateStringToSingleWithTarget:(NSString *)target operateHandler:(void (^) (NSMutableArray<NSString *> *sepStrArr,NSMutableArray<UILabel *> *sepLabelArr)) handler
{
    //装载每个字符的数组
    NSMutableArray <NSString *>*sepStrArr = [[NSMutableArray alloc] initWithCapacity:target.length];
    //装载UIlabel数组
    NSMutableArray <UILabel *>*sepLabelArr = [[NSMutableArray alloc] initWithCapacity:sepStrArr.count];
    //遍历每个字符
    for (NSInteger i = 0; i < target.length; i++)
    {
        //每个字符
        NSString *subStr = [target substringWithRange:NSMakeRange(i, 1)];
        [sepStrArr addObject:subStr];
        //label
        UILabel *label = [self createLabelWithString:subStr];
        CGFloat labelHeight = label.height;
        CGPoint labelPoint = CGPointMake(sepLabelArr.count?CGRectGetMaxX(sepLabelArr.lastObject.frame):0, ABS(self.height-labelHeight)*0.5);
        label.origin = labelPoint;
        [sepLabelArr addObject:label];
        [self addSubview:label];
    }
    //调整self.frame
    CGFloat labelHeight = sepLabelArr.lastObject.height;
    CGSize changedSize = CGSizeMake(CGRectGetMaxX(sepLabelArr.lastObject.frame), MAX(self.height, labelHeight));
    CGRect changedFrame = CGRectMake(self.x, self.y, changedSize.width, changedSize.height);
    if (self.centerPointPriority && changedSize.width != self.width && _has_centerPoint_detect ) {
        changedFrame = CGRectOffset(changedFrame, (self.width-changedSize.width)*0.5, 0);
    }
    if (self.centerPointPriority && !_has_centerPoint_detect) {
        changedFrame = CGRectOffset(changedFrame, -changedFrame.size.width*0.5, -changedFrame.size.height*0.5);
        _has_centerPoint_detect = YES;
    }
    self.frame = changedFrame;
    handler([sepStrArr copy],[sepLabelArr copy]);
}

#pragma mark - setter方法
- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:[UIColor clearColor]];
}

- (void)setTargetNum:(NSInteger)targetNum
{
    _targetNum = targetNum;
    [self setText:[NSString stringWithFormat:@"%ld", targetNum]];
}

//正则表达式判断是否符合相关规则
- (BOOL)isValidWithOriginText:(NSString *)originText
{
    NSString *format = @"^-?\\d*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", format];
    return [predicate evaluateWithObject:format];
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    if (!_targetNum)
    {
        self.targetNum = 0;
    }
}

@end
