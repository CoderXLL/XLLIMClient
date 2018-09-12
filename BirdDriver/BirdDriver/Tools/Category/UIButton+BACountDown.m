//
//  UIButton+BACountDown.m
//  BAButton
//
//  Created by 任子丰 on 16/6/17.
//  Copyright © 2016年 任子丰. All rights reserved.
//

#import "UIButton+BACountDown.h"
//#import "BAKit_ConfigurationDefine.h"
#import <objc/runtime.h>
/*! runtime set */
#define BAKit_Objc_setObj(key, value) objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC)

/*! runtime setCopy */
#define BAKit_Objc_setObjCOPY(key, value) objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY)

/*! runtime get */
#define BAKit_Objc_getObj objc_getAssociatedObject(self, _cmd)

/*! runtime exchangeMethod */
#define BAKit_Objc_exchangeMethodAToB(originalSelector,swizzledSelector) { \
Method originalMethod = class_getInstanceMethod(self, originalSelector); \
Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector); \
if (class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) { \
class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod)); \
} else { \
method_exchangeImplementations(originalMethod, swizzledMethod); \
} \
}


@interface UIButton ()

@property (nonatomic, assign) NSTimeInterval leaveTime;
@property (nonatomic, copy) NSString *normalTitle;
@property (nonatomic, copy) NSString *countDownFormat;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation UIButton (BACountDown)

- (void)setTimer:(dispatch_source_t)timer {
    BAKit_Objc_setObj(@selector(timer), timer);
}

- (dispatch_source_t)timer {
    return BAKit_Objc_getObj;
}

- (void)setLeaveTime:(NSTimeInterval)leaveTime {
    BAKit_Objc_setObj(@selector(leaveTime), @(leaveTime));
}

- (NSTimeInterval)leaveTime {
     return  [BAKit_Objc_getObj doubleValue];
}

- (void)setCountDownFormat:(NSString *)countDownFormat {
    BAKit_Objc_setObjCOPY(@selector(countDownFormat), countDownFormat);
}

- (NSString *)countDownFormat {
    return BAKit_Objc_getObj;
}

- (void)setTimeStoppedCallback:(void (^)(void))timeStoppedCallback {
    BAKit_Objc_setObjCOPY(@selector(timeStoppedCallback), timeStoppedCallback);
}

- (void (^)(void))timeStoppedCallback {
    return BAKit_Objc_getObj;
}

- (void)setNormalTitle:(NSString *)normalTitle {
    BAKit_Objc_setObjCOPY(@selector(normalTitle), normalTitle);
}

- (NSString *)normalTitle {
    return BAKit_Objc_getObj;
}

#pragma mark - public
/**
 倒计时: 带 title，返回时间，title，具体使用看 demo

 @param duration 倒计时时间
 @param format 可选，传nil默认为 @"%zd秒"
 */
- (void)ba_countDownWithTimeInterval:(NSTimeInterval)duration
                     countDownFormat:(NSString *)format
{
    if (!format)
    {
        self.countDownFormat = @"%zds";
    }
    else
    {
        self.countDownFormat = format;
    }
    self.normalTitle = self.titleLabel.text;
    __block NSInteger timeOut = duration; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    WEAKSELF
    dispatch_source_set_event_handler(self.timer, ^{
       STRONGSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            if (timeOut <= 0) { // 倒计时结束，关闭
                [strongSelf ba_cancelTimer];
            } else {
                NSString *title = [NSString stringWithFormat:self.countDownFormat, timeOut];
                [strongSelf setEnabled:NO];
                [strongSelf setTitleColor:JMY_GRAY_COLOR forState:UIControlStateDisabled];
                [strongSelf setTitle:title forState:UIControlStateDisabled];
                timeOut--;
            }
        });
    });
    dispatch_resume(self.timer);
}

/**
 倒计时: 返回当前时间，可以自定义 title 和 image，具体使用看 demo

 @param duration 倒计时时间
 @param block 返回当前时间
 */
- (void)ba_countDownCustomWithTimeInterval:(NSTimeInterval)duration
                                     block:(BAKit_BAButtonCountDownBlock)block
{
    __block NSInteger timeOut = duration; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    WEAKSELF
    dispatch_source_set_event_handler(self.timer, ^{
        STRONGSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block)
            {
                block(timeOut);
            }
            if (timeOut <= 0)
            {
                // 倒计时结束，关闭
                [strongSelf ba_cancelTimer];
            }
            else
            {
                timeOut--;
            }
        });
        
    });
    dispatch_resume(self.timer);
}

/**
 * 倒计时: 结束，取消倒计时
 */
- (void)ba_cancelTimer
{
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        STRONGSELF
        dispatch_source_cancel(self.timer);
        strongSelf.timer = nil;

        // 设置界面的按钮显示 根据自己需求设置
        [strongSelf setEnabled:YES];
        [strongSelf setTitle:self.normalTitle forState:UIControlStateNormal];
        strongSelf.userInteractionEnabled = YES;
        if (self.timeStoppedCallback) { self.timeStoppedCallback(); }
    });
}



- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color {
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backgroundColor = [UIColor clearColor];
                [self setTitleColor:mColor forState:UIControlStateNormal];
                [self setTitle:title forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        } else {
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backgroundColor = [UIColor clearColor];
                [self setTitleColor:color forState:UIControlStateNormal];
                [self setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

@end
