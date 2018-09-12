//
//  SJBuildNoteFooterView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJBuildNoteFooterView.h"
#import "SJGradientButton.h"

@interface SJBuildNoteFooterView ()

@property (nonatomic, weak) SJGradientButton *footerBtn;

@end

@implementation SJBuildNoteFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        [self setupBase];
    }
    return self;
}

- (void)setupBase
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    SJGradientButton *footerBtn = [SJGradientButton gradientButton];
    footerBtn.titleStr = @"提交";
    [footerBtn addTarget:self
                  action:@selector(footerBtnClick)
        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:footerBtn];
    self.footerBtn = footerBtn;
}

#pragma mark - event
- (void)footerBtnClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickFooterBtn)])
    {
        [self.delegate didClickFooterBtn];
    }
}

#pragma mark - setter
- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = [titleStr copy];
    self.footerBtn.titleStr = titleStr;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.footerBtn.frame = CGRectMake(15, (self.frame.size.height - 44)*0.5, self.frame.size.width - 30, 44);
}


@end
