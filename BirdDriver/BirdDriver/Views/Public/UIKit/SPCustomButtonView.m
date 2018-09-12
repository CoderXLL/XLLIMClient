//
//  CustomButtonView.m
//  CherryFinancial
//
//  Created by polo on 2017/7/5.
//  Copyright © 2017年 Brooks. All rights reserved.
//

#import "SPCustomButtonView.h"
#import "UIImage+ColorsImage.h"

@interface SPCustomButtonView ()

@end

@implementation SPCustomButtonView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _customBtnBackgroudColor = [UIColor grayColor];
        _customBtnGradientColors = @[[UIColor lightGrayColor],[UIColor grayColor]];
        [self subViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _customBtnBackgroudColor = [UIColor grayColor];
        _customBtnGradientColors = @[[UIColor lightGrayColor],[UIColor grayColor]];
        [self subViews];
    }
    return self;
}

- (void)subViews {
    [self addSubview:self.customBtn];
    [_customBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.centerY.equalTo(self);
        make.height.equalTo(self).offset(-16);
    }];
}

- (UIButton *)customBtn {
    if (!_customBtn) {
        _customBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_customBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _customBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_customBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return  _customBtn;
}

- (void)setCustomBtnTitle:(NSString *)customBtnTitle {
    _customBtnTitle= customBtnTitle;
    [self.customBtn setTitle:customBtnTitle forState:UIControlStateNormal];
}

- (void)setCustomBtnTitleColor:(UIColor *)customBtnTitleColor {
    _customBtnTitleColor = customBtnTitleColor;
    [self.customBtn setTitleColor:customBtnTitleColor forState:UIControlStateNormal];
}

- (void)setCustomBtnGradientColors:(NSArray *)customBtnGradientColors{
    _customBtnGradientColors = customBtnGradientColors;
    if (_customBtn.enabled) {
        UIImage *gradientImage = [UIImage horizontallyImageWithColors:customBtnGradientColors size:CGSizeMake(self.frame.size.width - 50,self.frame.size.height - 16)];
        [self.customBtn setBackgroundImage:gradientImage forState:UIControlStateNormal];
    }
}

- (void)setCustomBtnBackgroudColor:(UIColor *)customBtnBackgroudColor {
    _customBtnBackgroudColor = customBtnBackgroudColor;
    [self.customBtn setBackgroundColor:customBtnBackgroudColor];
}

- (void)setCustomBtnBackgroudImage:(UIImage *)customBtnBackgroudImage {
    _customBtnBackgroudImage = customBtnBackgroudImage;
    [self.customBtn setBackgroundImage:customBtnBackgroudImage forState:UIControlStateNormal];
}

- (void)setCornerRadius:(float)cornerRadius {
    _cornerRadius = cornerRadius;
    _customBtn.layer.cornerRadius = cornerRadius;
    _customBtn.layer.masksToBounds = YES;
}

- (void)setCustomBtnEnable:(BOOL)customBtnEnable {
    _customBtnEnable = customBtnEnable;
    [self.customBtn setEnabled:_customBtnEnable];
    if (_customBtnEnable) {
        [self.customBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (_customBtnBackgroudColor) {
            [self.customBtn setBackgroundColor:_customBtnBackgroudColor];
        }
        if (_customBtnGradientColors) {
            [self.customBtn setBackgroundColor:[UIColor clearColor]];
            [self setCustomBtnGradientColors:_customBtnGradientColors];
        }
    }else{
        [self.customBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [self.customBtn setBackgroundColor:HEXCOLOR(@"CCCCCC")];
        [self.customBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

- (void)buttonAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if(_customButtonClickBlock){
        _customButtonClickBlock(btn);
    }
}

- (void)customButtonClick:(customButtonClickBlock)customButtonClickBlock {
    _customButtonClickBlock = customButtonClickBlock;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self subViews];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
