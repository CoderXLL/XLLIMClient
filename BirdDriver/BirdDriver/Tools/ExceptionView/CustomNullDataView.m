//
//  CustomNullDataView.m
//  CherryFinancial
//
//  Created by zhangyong liu on 2017/7/18.
//  Copyright © 2017年 Brooks. All rights reserved.
//

#import "CustomNullDataView.h"




@interface CustomNullDataView()

@property (nonatomic,retain) UIImageView *imgV;
@property (nonatomic,retain) UILabel *titleLb;
@property (nonatomic,retain) UIView *replaceView;                    //将被替换的视图


@end

@implementation CustomNullDataView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self subViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self subViews];
    }
    return self;
}


- (UIImageView *)imgV {
    if (!_imgV) {
        _imgV = [UIImageView new];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgV;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.textColor = [UIColor blackColor];
        _titleLb.font = [UIFont systemFontOfSize:13.0];
        _titleLb.minimumScaleFactor = 0.6;
        _titleLb.text = @"目前没有相关数据";
    }
    return _titleLb;
}


- (void)subViews {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imgV];
    if (!_image) {
       self.image = [UIImage imageNamed:@"public_null_bg"];
    }
    float imgV_W = _image.size.width < self.frame.size.width ? _image.size.width : self.frame.size.width;
    float imgV_H = _image.size.height < self.frame.size.height ? _image.size.height : self.frame.size.height;
    float height = imgV_W < imgV_H ? imgV_W : imgV_H;
    float width = height;
    float titleLb_H = self.frame.size.height == 0 ? 15 : self.frame.size.height * 0.15;
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(width,height));
    }];
    
    [self addSubview:self.titleLb];
    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self->_imgV.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width,titleLb_H));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self.imgV setImage:image];
}

- (void)setMessage:(NSString *)message {
    
    self.titleLb.text = message;
}

- (void)tapAction {
    [self removeFromSuperview];
    //[self setHidden:YES];
    [self.replaceView setHidden:NO];
    if (self.clickBlock) {
        self.clickBlock();
    }
}


- (void)showViewAddTo:(UIView * _Nonnull)view replaceView:(UIView *)replaceView clickBlock:(CustomNullDataViewClickBlock)clickBlock {
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.centerY.equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, self.frame.size.height));
    }];
    _replaceView = replaceView;
    _clickBlock = clickBlock;
    [self show];
}


- (void)show {
    [self setHidden:NO];
    [_replaceView setHidden:YES];
}

- (void)dismiss {
    [self removeFromSuperview];
    //[self setHidden:YES];
    [_replaceView setHidden:NO];
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
