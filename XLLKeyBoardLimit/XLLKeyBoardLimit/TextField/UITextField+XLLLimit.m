//
//  UITextField+XLLLimit.m
//  XLLKeyBoardInputLimit
//
//  Created by 肖乐 on 2018/4/13.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import "UITextField+XLLLimit.h"
#import "NSString+XLLLimit.h"
#import <objc/runtime.h>

@interface XLLTempDelegate : NSObject <UITextFieldDelegate>

//内部代理
@property (nonatomic, weak) id myDelegate;
//外部代理
@property (nonatomic, weak) id customDelegate;
//协议
@property (nonatomic, strong) Protocol *protocol;

@end

@implementation XLLTempDelegate

#pragma mark - lazy loading
- (Protocol *)protocol
{
    if (_protocol == nil)
    {
        _protocol = objc_getProtocol("UITextFieldDelegate");
    }
    return _protocol;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    struct objc_method_description desc = protocol_getMethodDescription(self.protocol, aSelector, NO, YES);
    if (desc.types == NULL)
    {
        return [super respondsToSelector:aSelector];
    }
    if ([self.myDelegate respondsToSelector:aSelector] || [self.customDelegate respondsToSelector:aSelector]) {
        
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

// 下面采用消息转发思想，让内部与外部都执行代理方法
// 返回方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *mySign = [self.myDelegate methodSignatureForSelector:aSelector];
    NSMethodSignature *customSign = [self.customDelegate methodSignatureForSelector:aSelector];
    return mySign?:customSign?:nil;
}

//sel执行target
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL sel = anInvocation.selector;
    BOOL isResponse = NO;
    if ([self.myDelegate respondsToSelector:sel])
    {
        isResponse = YES;
        [anInvocation invokeWithTarget:self.myDelegate];
    }
    if ([self.customDelegate respondsToSelector:sel])
    {
        isResponse = YES;
        [anInvocation invokeWithTarget:self.customDelegate];
    }
    if (!isResponse) {
        [anInvocation doesNotRecognizeSelector:sel];
    }
}

@end

@interface UITextField ()

@property (nonatomic, copy) NSString *tempFieldText;

@end

@implementation UITextField (XLLLimit)
static char XLLFieldConfigKey, XLLTempDelegateKey;

+ (void)load
{
    Method originM = class_getInstanceMethod(self, @selector(setDelegate:));
    Method customM = class_getInstanceMethod(self, @selector(setXLLDelegate:));
    method_exchangeImplementations(originM, customM);
}

#pragma mark - setter, getter
- (void)setXLLDelegate:(id<UITextFieldDelegate>)delegate
{
    if (objc_getAssociatedObject(self, &XLLFieldConfigKey))
    {
        XLLTempDelegate *tempDelegate = [[XLLTempDelegate alloc] init];
        tempDelegate.customDelegate = delegate;
        tempDelegate.myDelegate = self;
        [self setXLLDelegate:tempDelegate];
        // 要setter一下tempDelegate,否则runloop之后会被释放
        objc_setAssociatedObject(self, &XLLTempDelegateKey, tempDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    } else {
        [self setXLLDelegate:delegate];
    }
}

- (NSString *)tempFieldText
{
    return objc_getAssociatedObject(self, @selector(tempFieldText));
}

- (void)setTempFieldText:(NSString *)tempFieldText
{
    objc_setAssociatedObject(self, @selector(tempFieldText), tempFieldText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)isGetMaxLimit
{
    return [objc_getAssociatedObject(self, @selector(isGetMaxLimit)) integerValue];
}

- (void)setIsGetMaxLimit:(BOOL)isGetMaxLimit
{
    objc_setAssociatedObject(self, @selector(isGetMaxLimit), @(isGetMaxLimit), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XLLTextConfig *)fieldConfig
{
    return objc_getAssociatedObject(self, &XLLFieldConfigKey);
}

- (void)setFieldConfig:(XLLTextConfig *)fieldConfig
{
    objc_setAssociatedObject(self, &XLLFieldConfigKey, fieldConfig, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.fieldConfig.leftMargin, self.frame.size.height)];
    leftView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    leftView.backgroundColor = [UIColor redColor];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = leftView;
}

#pragma mark - UITextFieldDelegate
//未渲染，扼杀在摇篮里
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITextRange *markRange = textField.markedTextRange;
    UITextPosition *pos = [textField positionFromPosition:markRange.start offset:0];
    if (markRange && pos)
    {
        //如果是高亮状态，尽管输
        return YES;
    }
    //禁止输入表情
    if ([string stringContainsEmoji])
    {
        return NO;
    }
//    //禁止输入标点符号
//    if ([string stringContainsSymbol])
//    {
//        return NO;
//    }
    //限制字符输入
    if ([self currentCharCount:textField.text] + [self currentCharCount:string] > self.fieldConfig.maxLimitCount)
    {
        return NO;
    }
    return YES;
}


//已经渲染
- (void)textFieldDidChange:(UITextField *)textField
{
    //输入汉字时的高亮范围
    UITextRange *markRange = textField.markedTextRange;
    UITextPosition *pos = [textField positionFromPosition:markRange.start offset:0];
    //如果真的处于高亮状态
    if (markRange && pos) return;
    self.isGetMaxLimit = [self currentCharCount:textField.text] >= self.fieldConfig.maxLimitCount;
    if ([self currentCharCount:textField.text] > self.fieldConfig.maxLimitCount) {
        
        //强制挽回遗憾
        // 保留光标的位置信息
        NSRange selectedRange = [self selectedRange];
        // 保留当前文本的内容
        NSString *tmpSTR = textField.text;
        // 设置了文本,光标到了最后
        textField.text = self.tempFieldText;
        // 重新设置光标的位置
        selectedRange.location -= (tmpSTR.length - self.tempFieldText.length);
        [self updateSelectedTextRange:selectedRange];
    } else {
        self.tempFieldText = textField.text;
    }
}

- (NSInteger)currentCharCount:(NSString *)string
{
    switch (self.fieldConfig.charStyle) {
        case XLLTextFieldCharStyleNormal:
            return string.length;
        case XLLTextFieldCharStyleDouble:
            return [string xllDoubleLength];
        case XLLTextFieldCharStyleHalf:
            return [string xllHalfLength];
        default:
            break;
    }
}

//获取textField的当前光标range
- (NSRange)selectedRange
{
    //获取一开始的position
    UITextPosition *beginning = self.beginningOfDocument;
    //获取光标选中的textRange
    UITextRange *selectedRange = self.selectedTextRange;
    UITextPosition *selectedStart = selectedRange.start;
    UITextPosition *selectedEnd = selectedRange.end;
    //获取文本起始点与光标起始点的偏移量（光标location）
    NSInteger location = [self offsetFromPosition:beginning toPosition:selectedStart];
    NSInteger length = [self offsetFromPosition:selectedStart toPosition:selectedEnd];
    return NSMakeRange(location, length);
}

- (void)updateSelectedTextRange:(NSRange)selectedRange
{
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:selectedRange.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:selectedRange.location + selectedRange.length];
    UITextRange *selectTextRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectTextRange];
}

@end
