//
//  SJHomeSectionHeader.m
//  BirdDriver
//
//  Created by Soul on 2018/5/17.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SJHomeSectionHeader.h"
#import "SJRightAngleView.h"

@interface SJHomeSectionHeader()

@property (strong, nonatomic) UIImageView *img_left;
@property (strong, nonatomic) UILabel *lbl_title;

@property (strong, nonatomic) UIView *v_right;
@property (strong, nonatomic) UIButton *btn_right;
@property (strong, nonatomic) UIImageView *img_right;
@property (strong, nonatomic) SJRightAngleView *angleView;

@property (copy, nonatomic) HomeHeaderSectionBlock tapBlock;

@end

@implementation SJHomeSectionHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubViews];
        [self reLayoutSubviews];
    }
    return self;
}

- (void)addSubViews {
    [self addSubview:self.img_left];
    [self addSubview:self.lbl_title];
    [self addSubview:self.v_right];
    
    //img_right
    [self.v_right addSubview:self.angleView];
    [self.v_right addSubview:self.btn_right];
}

- (void)reLayoutSubviews{
    [self.img_left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self.lbl_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.img_left.mas_right).offset(5);
        make.centerY.equalTo(self.img_left);
    }];
    
    [self.v_right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.left.equalTo(self.lbl_title.mas_right);
    }];
    
    //img_right
    [self.angleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.v_right).offset(-15);
        make.centerY.equalTo(self.v_right);
        make.centerY.mas_equalTo(self.v_right.centerY).offset(-3);
        make.width.height.mas_equalTo(10);
    }];
    
    [self.btn_right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.angleView.mas_left).offset(0);
        make.centerY.equalTo(self.v_right);
    }];
}

- (void)factorySetViewWithTitle:(NSString *)title
                   WithBtnTitle:(NSString *)btnTitle
                   WithTapBlock:(HomeHeaderSectionBlock)block{
    
    if (!kStringIsEmpty(title)) {
        self.lbl_title.text = title;
    }
    
    if (kStringIsEmpty(btnTitle)) {
            [self.v_right setHidden:YES];
        }else{
            [self.v_right setHidden:NO];
            [self.btn_right setTitle:btnTitle
                            forState:UIControlStateNormal];
        }
    
    self.backgroundColor = SP_CLEAR_COLOR;
}



- (instancetype)initWithTitle:(NSString *)title
                 WithBtnTitle:(NSString *)btnTitle
                 WithTapBlock:(HomeHeaderSectionBlock)block{
    if(self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)]){
        [self addSubViews];
        [self reLayoutSubviews];
        
        self.backgroundColor = SP_WHITE_COLOR;
    }
    return self;
}

- (UIImageView *)img_left{
    if (!_img_left) {
        _img_left = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_title_icon"]];
    }
    return _img_left;
}

- (SJRightAngleView *)angleView
{
    if (!_angleView) {
        _angleView = [[SJRightAngleView alloc] init];
    }
    return _angleView;
}

- (UILabel *)lbl_title{
    if (!_lbl_title) {
        _lbl_title = [UILabel new];
        _lbl_title.text = @"lbl_title";
//        _lbl_title.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _lbl_title.font = [UIFont boldSystemFontOfSize:15.0];
        _lbl_title.textColor = [UIColor colorWithHexString:@"2B3248" alpha:1.0];
    }
    return _lbl_title;
}

- (UIView *)v_right{
    if(!_v_right){
        _v_right = [UIView new];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAction)];
        [_v_right addGestureRecognizer:tapGesture];
    }
    return _v_right;
}

- (UIButton *)btn_right{
    if (!_btn_right) {
        _btn_right = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btn_right setTitleColor:[UIColor colorWithHexString:@"BDBDBD" alpha:1.0] forState:UIControlStateNormal];
        [_btn_right setTitleColor:[UIColor colorWithHexString:@"BDBDBD" alpha:1.0] forState:UIControlStateDisabled];
        [_btn_right.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12]];
        _btn_right.enabled = NO;
//        [_btn_right addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_right;
}

- (UIImageView *)img_right{
    if (_img_right) {
        _img_right = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner_title_icon"]];
    }
    return _img_right;
}

- (void)changeAction {
    self.block();
}

@end
