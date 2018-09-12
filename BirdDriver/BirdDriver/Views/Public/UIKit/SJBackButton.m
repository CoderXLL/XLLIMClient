//
//  SJBackButton.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/25.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJBackButton.h"

@interface SJBackButton ()

@property (nonatomic, weak) UIImageView *backImageView;
@property (nonatomic, weak) UILabel *backTitleLabel;

@end

@implementation SJBackButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupBase];
    }
    return self;
}

- (void)setupBase
{
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.0f];
    self.titleLabel.font = font;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)setImageStr:(NSString *)imageStr
{
    _imageStr = [imageStr copy];
    [self setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (void)setTitleStr:(NSString *)titleStr
{
    if (titleStr.length > 10) {
        titleStr = [NSString stringWithFormat:@"%@...", [titleStr substringToIndex:10]];
    }
    _titleStr = [titleStr copy];
    [self setTitle:titleStr forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    UIImage *backImage = [UIImage imageNamed:self.imageStr];
    return CGRectMake(0, 0, backImage.size.width, contentRect.size.height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    UIImage *backImage = [UIImage imageNamed:self.imageStr];
    return CGRectMake(backImage.size.width + 5, 0, contentRect.size.width - backImage.size.width - 5, contentRect.size.height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.0f];
    CGSize size = [self.titleStr boundingRectWithSize:CGSizeMake(kScreenWidth/2, 30)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:font}
                                              context:nil].size;
    UIImage *backImage = [UIImage imageNamed:@"Set_back"];
    CGFloat scale = [UIScreen mainScreen].scale;
    self.size = CGSizeMake(backImage.size.width * scale + 5 + size.width, MIN(backImage.size.height, 45));
}

@end
