//
//  SJOverlayHeadView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/20.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJOverlayHeadView.h"
#import "JABBSModel.h"

@implementation SJOverlayHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupBase];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setupBase];
    }
    return self;
}

- (void)setupBase
{
    for (NSInteger i = 0; i < 5; i++)
    {
        UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake((25+5)*i, 2.5, 25, 25)];
        headView.contentMode = UIViewContentModeScaleAspectFill;
        headView.clipsToBounds = YES;
        headView.layer.zPosition = 10-i;
        headView.layer.cornerRadius = 12.5;
        headView.backgroundColor = [UIColor randomColor];
        headView.hidden = YES;
        headView.userInteractionEnabled = YES;
        [self addSubview:headView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [headView addGestureRecognizer:tapGesture];
    }
}

#pragma mark - event
- (void)tapGesture:(UITapGestureRecognizer *)tapGesture
{
    UIImageView *headView = (UIImageView *)tapGesture.view;
    NSMutableArray *imageViewArr = [NSMutableArray array];
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)subView;
            [imageViewArr addObject:imageView];
        }
    }
    NSInteger index = [imageViewArr indexOfObject:headView];
    JAUserAccountPosList *posModel = [self.accountList objectAtIndex:index];
    if (self.clickBlock) {
        self.clickBlock(posModel);
    }
}


- (void)setAccountList:(NSArray<JAUserAccountPosList *> *)accountList
{
    _accountList = accountList;    
    NSInteger i = 0;
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIImageView class]])
        {
            UIImageView *imageView = (UIImageView *)subView;
            imageView.hidden = YES;
            if (i < accountList.count)
            {
                imageView.hidden = NO;
                JAUserAccountPosList *posModel = accountList[i];
                imageView.layer.borderWidth = 1.5;
                if (posModel.sex == 0) { //女
                    
                    imageView.layer.borderColor = [UIColor colorWithHexString:@"F9739B" alpha:1].CGColor;
                } else { //男
                    imageView.layer.borderColor = [UIColor colorWithHexString:@"6EEBEE" alpha:1].CGColor;
                }
                [imageView sd_setImageWithURL:posModel.photoSrc.mj_url placeholderImage:[UIImage imageNamed:@"default_portrait"]];
            }
            i++;
        }
    }
}

@end
