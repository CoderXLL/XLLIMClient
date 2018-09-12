//
//  SJAlertView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJAlertView.h"
#import "SJGradientButton.h"
 

@implementation SJAlertModel

- (instancetype)initWithTitle:(NSString *)title handler:(void (^)(id))handler
{
    if (self = [super init])
    {
        self.title = title;
        self.handler = handler;
    }
    return self;
}

@end

@interface SJAlertView ()

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *messageStr;
@property (nonatomic, strong) NSArray <SJAlertModel *>*alertModels;
@property (nonatomic, assign) SJAlertShowType showType;

//拦截视图
@property (nonatomic, strong) UIButton *coverBtn;
//主要面板
@property (nonatomic, strong) UIView *alertView;
//标题label
@property (nonatomic, strong) UILabel *titleLabel;
//副标题label
@property (nonatomic, strong) UILabel *messageLabel;
//输入textField
@property (nonatomic, strong) UITextField *textField;

@end

@implementation SJAlertView
static CGFloat totalHeight_ = 0;

#pragma mark - setter
- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = [titleStr copy];
    self.titleLabel.text = titleStr;
}

- (void)setAlertModels:(NSArray<SJAlertModel *> *)alertModels
{
    _alertModels = alertModels;
    CGFloat btnW = kScreenWidth / 375.0 * 100;
    CGFloat btnH = btnW*35/100.0;
    CGFloat btnMargin = ((kScreenWidth - 55 * 2.0) - btnW * alertModels.count - 15 * (self.alertModels.count - 1)) / 2.0;
    for (NSInteger i = 0; i < alertModels.count; i++)
    {
        SJAlertModel *alertModel = alertModels[i];
        if (i == 0)
        {
            SJGradientButton *handleBtn = [SJGradientButton gradientButton];
            handleBtn.titleStr = alertModel.title;
            [handleBtn setTitleColor:[UIColor colorWithHexString:@"FFBB04" alpha:1.0] forState:UIControlStateNormal];
            handleBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
            handleBtn.tag = i;
            [handleBtn addTarget:self action:@selector(handleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:handleBtn];
            [handleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.left.mas_equalTo(btnMargin+i*(btnW+15));
                make.bottom.mas_equalTo(-25);
                make.width.mas_equalTo(btnW);
                make.height.mas_equalTo(btnH);
            }];
        } else {
            UIButton *handleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [handleBtn setTitle:alertModel.title forState:UIControlStateNormal];
            [handleBtn setTitleColor:[UIColor colorWithHexString:@"2B3248" alpha:1.0] forState:UIControlStateNormal];
            handleBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
            handleBtn.layer.cornerRadius = btnH*0.5;
            handleBtn.clipsToBounds = YES;
            handleBtn.tag = i;
            [handleBtn addTarget:self action:@selector(handleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            handleBtn.layer.borderColor = [UIColor colorWithHexString:@"2B3248" alpha:1.0].CGColor;
            handleBtn.clipsToBounds = YES;
            handleBtn.layer.borderWidth = 0.5;
            handleBtn.layer.cornerRadius = btnH * 0.5;
            [self.alertView addSubview:handleBtn];
            [handleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.left.mas_equalTo(btnMargin+i*(btnW+15));
                make.bottom.mas_equalTo(-25);
                make.width.mas_equalTo(btnW);
                make.height.mas_equalTo(btnH);
            }];
        }
            
    }
}

- (void)setShowType:(SJAlertShowType)showType
{
    _showType = showType;
    CGFloat titleHeight = [self.titleStr boundingRectWithSize:CGSizeMake(self.titleLabel.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SPFont(15.0)} context:nil].size.height;
    CGFloat btnW = kScreenWidth / 375.0 * 100;
    CGFloat btnH = btnW*35/100.0;
    totalHeight_+=titleHeight+ 20 + btnH + 25 + 35;
    [self setAlertHeight:totalHeight_];
    
    switch (showType) {
        case SJAlertShowTypeInput:
        {
            self.textField = [[UITextField alloc] init];
            self.textField.borderStyle = UITextBorderStyleNone;
            self.textField.tintColor = [UIColor colorWithHexString:@"FFBB04" alpha:1.0];
            self.textField.font = SPFont(15.0);
            self.textField.textAlignment = NSTextAlignmentLeft;
            self.textField.placeholder = self.messageStr;
            [self.alertView addSubview:self.textField];
            [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.left.mas_equalTo(21);
                make.centerX.mas_equalTo(0);
                make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(20);
                make.height.mas_equalTo(25);
            }];
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = [UIColor colorWithHexString:@"ECECEC" alpha:1.0];
            [self.alertView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.height.mas_equalTo(1);
                make.left.mas_equalTo(21);
                make.centerX.mas_equalTo(0);
                make.top.mas_equalTo(self.textField.mas_bottom).offset(0);
            }];
            totalHeight_ += 1+25+10;
            [self setAlertHeight:totalHeight_];
        }
            break;
        case SJAlertShowTypeSubTitle:
        {
            self.messageLabel = [[UILabel alloc] init];
            self.messageLabel.numberOfLines = 0;
            self.messageLabel.textAlignment = NSTextAlignmentCenter;
            self.messageLabel.textColor = [UIColor colorWithHexString:@"BDBDBD" alpha:1.0];
            self.messageLabel.font = [UIFont systemFontOfSize:12.0];
            self.messageLabel.text = self.messageStr;
            [self.alertView addSubview:self.messageLabel];
            [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(15);
            }];
            CGFloat messageHeight = [self.messageStr boundingRectWithSize:CGSizeMake(self.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SPFont(15.0)} context:nil].size.height;

            totalHeight_+= messageHeight + 10+20;
            [self setAlertHeight:totalHeight_];
        }
            break;
        case SJAlertShowTypeNormal:
            break;            
        default:
            break;
    }
}

- (void)setAlertHeight:(CGFloat)height
{
    self.alertView.frame = CGRectMake(55, (kScreenHeight - height*1.5)*0.5, kScreenWidth - 55 * 2, height);
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message type:(SJAlertShowType)type alertModels:(NSArray<SJAlertModel *> *)alertModels
{
    SJAlertView *alertView = [[SJAlertView alloc] init];
    alertView.titleStr = title;
    alertView.messageStr = message;
    alertView.alertModels = alertModels;
    alertView.showType = type;
    return alertView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addKeyBoradNoti];
        [self setupBase];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self addKeyBoradNoti];
        [self setupBase];
    }
    return self;
}

- (void)addKeyBoradNoti
{
    [SPNotificationCenter addObserver:self selector:@selector(keyBoardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - UIKeyboardDidChangeFrameNotification
- (void)keyBoardChanged:(NSNotification *)notification
{
    //键盘弹出动画
    CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //键盘最后frame
    CGRect endKeyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat resultY = endKeyboardRect.origin.y - self.alertView.height;
    CGFloat targetY = MIN(resultY, self.centerY - self.alertView.height*0.5);
    
    void(^animations)(void) = ^{
        
        self.alertView.y = targetY;
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
}

- (void)setupBase
{
    self.coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.coverBtn.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:1.0];
    self.coverBtn.alpha = 0.6;
    [self.coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.coverBtn];
    [self.coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.left.right.mas_equalTo(0);
    }];
    
    self.alertView = [[UIView alloc] init];
    self.alertView.backgroundColor = [UIColor colorWithHexString:@"FFFFFF" alpha:1.0];
    self.alertView.layer.cornerRadius = 10;
    self.alertView.clipsToBounds = YES;
    [self addSubview:self.alertView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"2B3248" alpha:1.0];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.alertView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(28);
    }];
}

#pragma mark - event
- (void)handleBtnClick:(UIButton *)handleBtn
{
    [self dismissAlertView];
    SJAlertModel *alertModel = [self.alertModels objectAtIndex:handleBtn.tag];
    if (alertModel.handler)
    {
        if (self.showType == SJAlertShowTypeInput)
        {
            alertModel.handler(self.textField.text);
        } else {
            alertModel.handler(nil);
        }
    }
}

- (void)coverBtnClick
{
    [self dismissAlertView];
}

- (void)showAlertView
{
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.coverBtn.alpha = 0;
    self.alertView.transform = CGAffineTransformTranslate(self.alertView.transform, 0, 5);
    [UIView animateWithDuration:.25f animations:^{
        self.coverBtn.alpha = 0.6;
        self.alertView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismissAlertView
{
    totalHeight_ = 0;
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [UIView animateWithDuration:.25f animations:^{
        self.coverBtn.alpha = 0;
        self.alertView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dealloc
{
    LogD(@"我走了")
    [SPNotificationCenter removeObserver:self];
}
    

@end
