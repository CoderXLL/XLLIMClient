//
//  SJShareView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/26.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJShareView.h"
#import "SJUpDownButton.h"

@interface SJShareView ()

@property (weak, nonatomic) IBOutlet SJUpDownButton *circleBtn;
@property (weak, nonatomic) IBOutlet SJUpDownButton *friendBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *actionView;

@end

@implementation SJShareView

+ (instancetype)createCellWithXib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SJShareView" owner:nil options:nil] objectAtIndex:0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.bgView addGestureRecognizer:tapGesture];
}

- (IBAction)circleBtnClick:(id)sender {
    
    [self dismiss];
    if (self.clickBlock) {
        self.clickBlock(SJShareViewActionTypeCircle);
    }
}

- (IBAction)friendBtnClick:(id)sender {
    
    [self dismiss];
    if (self.clickBlock) {
        self.clickBlock(SJShareViewActionTypeFriend);
    }
}


- (IBAction)cancelBtnClick:(id)sender {
    
    [self dismiss];
}

- (void)dismiss
{
    [UIView animateWithDuration:.25f animations:^{
        
        self.bgView.alpha = 0;
        self.actionView.transform = CGAffineTransformTranslate(self.actionView.transform, 0, CGRectGetMaxY(self.actionView.frame));
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)show
{
    self.frame = [UIScreen mainScreen].bounds;
    self.y += iPhoneX?24:0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.bgView.alpha = 0;
    self.actionView.transform = CGAffineTransformTranslate(self.actionView.transform, 0, CGRectGetMaxY(self.actionView.frame));
    [UIView animateWithDuration:.3f animations:^{
        
        self.bgView.alpha = 0.55;
        self.actionView.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        
        self.bgView.alpha = 0.6;
    }];
}

@end
