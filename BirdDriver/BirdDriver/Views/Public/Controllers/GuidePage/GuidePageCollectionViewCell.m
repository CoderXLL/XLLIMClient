//
//  GuidePageCollectionViewCell.m
//  GuidePage
//
//  Created by 宋明月 on 2018/1/5.
//  Copyright © 2018年 宋明月. All rights reserved.
//

#import "GuidePageCollectionViewCell.h"


static CGFloat  kButtonheight = 40;
static CGFloat  kButtonBottom = 40;
static CGFloat  kButtonwidth = 200;


@implementation GuidePageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.button];
    }
    return self;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _imageView;
}

/**
 *  初始化button
 *
 *  @return button
 */
- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] init];
        _button.frame = CGRectMake(0, 0, kButtonwidth, kButtonheight);
        _button.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height - kButtonBottom - kButtonheight/2);
        _button.backgroundColor = [UIColor clearColor];
        _button.userInteractionEnabled = NO;
        [_button setHidden:YES];
    }
    return _button;
}

-(void)setButtonSizeWith:(CGSize)size bottom:(CGFloat)bottom{
    if (size.height > 0) {
        kButtonheight = size.height;
    }
    if (size.width > 0) {
        kButtonwidth = size.width;
    }
    if (bottom > 0) {
        kButtonBottom = bottom;
    }
    _button.frame = CGRectMake(0, 0, kButtonwidth, kButtonheight);
    _button.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height - kButtonBottom - kButtonheight/2);
}


@end
