//
//  CustomSelectView.m
//  GoldChildren
//
//  Created by 宋明月 on 2017/9/27.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import "CustomSelectView.h"
@interface CustomSelectView ()




@end

@implementation CustomSelectView

- (instancetype) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self subViews];
    }
    return self;
}

- (void) subViews {
    
    [self addSubview:self.titleLb];
    [self addSubview:self.imgV];

    [_titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    [_imgV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_titleLb.mas_centerX);
        make.bottom.equalTo(self.mas_bottom);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,20)];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.font = [UIFont systemFontOfSize:14];
        _titleLb.textColor = SJ_TITLE_COLOR;
    }
    return _titleLb;
}

- (UIImageView *)imgV {
    if (!_imgV) {
        _imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message"]];
        _imgV.backgroundColor = [UIColor clearColor];
        _imgV.hidden = YES;
    }
    return _imgV;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.titleLb setText:title];
}

- (void) setSelected:(BOOL)selected {
    if (selected) {
        self.imgV.hidden = NO;
    }else {
        self.imgV.hidden = YES;
    }
}

- (void) tapAction{
    if (_customSelectViewClickBlock) {
        _customSelectViewClickBlock(self.tag);
    }
}

- (void) customSelectViewClick:(customSelectViewClickBlock)block {
    _customSelectViewClickBlock =block;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
