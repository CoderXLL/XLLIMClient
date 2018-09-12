//
//  SJReplyView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/10.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJReplyView.h"
#import "SPTextView.h"

@interface SJReplyView () <UITextViewDelegate>

//背景蒙层
@property (nonatomic, weak) UIButton *coverView;
//操作区
@property (nonatomic, weak) UIView *actionView;
//uitextView
@property (nonatomic, weak) UITextView *textView;
//发送
@property (nonatomic, weak) UIButton *sendBtn;
@property (nonatomic, copy) void(^sendBlock)(NSString *);
@property (nonatomic, copy) NSString *placeHolderStr;

@end

@implementation SJReplyView
static CGFloat SJKeyboardHeight = 0;
static CGFloat SJTextViewHeight = 34;

+ (instancetype)replyViewWithPlaceHolder:(NSString *)placeHolder SendBlock:(void(^)(NSString *))sendBlock
{
    SJReplyView *replyView = [[SJReplyView alloc] init];
    replyView.sendBlock = sendBlock;
    replyView.placeHolderStr = placeHolder;
    return replyView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupBase];
        [self addNotification];
    }
    return self;
}

- (void)setupBase
{
    UIButton *coverView = [UIButton buttonWithType:UIButtonTypeCustom];
    coverView.backgroundColor = [UIColor clearColor];
    [coverView addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:coverView];
    self.coverView = coverView;
    
    UIView *actionView = [[UIView alloc] init];
    actionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:actionView];
    self.actionView = actionView;
    
    SPTextView *textView = [[SPTextView alloc] init];
    textView.keyboardType = UIKeyboardTypeDefault;
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.spellCheckingType = UITextSpellCheckingTypeNo;
    textView.alwaysBounceVertical = YES;
    textView.contentMode = UIViewContentModeScaleAspectFill;
    textView.clipsToBounds = YES;
    textView.delegate = self;
    textView.backgroundColor = [UIColor colorWithHexString:@"F4F4F4" alpha:1];
    textView.layer.cornerRadius = 5.0;
    textView.font = SPFont(15.0);
    textView.clipsToBounds = YES;
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectZero];
    textView.inputAccessoryView = blankView;
    [self.actionView addSubview:textView];
    self.textView = textView;
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.backgroundColor = [UIColor whiteColor];
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitleColor:[UIColor colorWithHexString:@"2B3248" alpha:1] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = SPFont(14.0);
    [self.actionView addSubview:sendBtn];
    self.sendBtn = sendBtn;
}

- (void)setPlaceHolderStr:(NSString *)placeHolderStr
{
    _placeHolderStr = [placeHolderStr copy];
    self.textView.placeholder = placeHolderStr;
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - notification
- (void)keyBoardWillChangeFrame:(NSNotification *)notification
{
    CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endKeyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    SJKeyboardHeight = endKeyboardRect.size.height;
    UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat targetY = endKeyboardRect.origin.y - self.actionView.height;
    __weak typeof(self) weakSelf = self;
    void(^animations)(void) = ^{
        weakSelf.actionView.y = targetY;
    };
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat maxHeight = 70;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height < 34) return;
    if (size.height>frame.size.height) {
        
        if (size.height >= maxHeight)
        {
            size.height = maxHeight;
            textView.scrollEnabled = YES;  // 允许滚动
        } else {
            textView.scrollEnabled = NO;    // 不允许滚动
        }
    }
    if (size.height != self.frame.size.height) {
        
        SJTextViewHeight = size.height;
        [self setNeedsLayout];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}



- (void)coverBtnClick
{
    [self dismiss];
}

- (void)sendBtnClick
{
    if (kStringIsEmpty(self.textView.text)) {
        [SVProgressHUD showInfoWithStatus:@"评论不能为空"];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        return;
    }
    if (self.sendBlock)
    {
        [self dismiss];
        self.sendBlock(self.textView.text);
    }
}

- (void)dismiss
{
    [IQKeyboardManager sharedManager].enable = YES;
    [self.textView resignFirstResponder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (void)show
{
    [IQKeyboardManager sharedManager].enable = NO;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.frame = keyWindow.bounds;
    self.actionView.y = self.height-SJTextViewHeight-10-SJKeyboardHeight;
    [keyWindow addSubview:self];
    [self.textView becomeFirstResponder];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.coverView.frame = self.bounds;
    self.actionView.frame = CGRectMake(0, self.height-SJTextViewHeight-10-SJKeyboardHeight, self.width, SJTextViewHeight+10);
    self.textView.frame = CGRectMake(15, 5, self.actionView.width-15-70, SJTextViewHeight);
    self.sendBtn.frame = CGRectMake(self.actionView.width-70, self.textView.y, 70, 35);
}

- (void)dealloc
{
    SJKeyboardHeight = 0;
    SJTextViewHeight = 34;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
