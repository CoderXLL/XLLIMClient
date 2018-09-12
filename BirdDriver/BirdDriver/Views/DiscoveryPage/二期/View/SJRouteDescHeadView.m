//
//  SJRouteDescHeadView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/9/11.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJRouteDescHeadView.h"

@interface SJRouteDescHeadView ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *descLabel;

@end

@implementation SJRouteDescHeadView

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
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.image = [UIImage imageNamed:@"route_introduce"];
    [self addSubview:imageView];
    self.imageView = imageView;
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.textColor = [UIColor colorWithHexString:@"2B3248" alpha:1];
    descLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [self addSubview:descLabel];
    self.descLabel = descLabel;
}

#pragma mark - setter
- (void)setDescType:(SJRouteDescType)descType
{
    _descType = descType;
    switch (descType) {
        case SJRouteDescTypeIntroduce:
        {
            self.descLabel.text = @"路线介绍";
        }
            break;
        case SJRouteDescTypeArrange:
        {
            self.descLabel.text = @"路线安排";
        }
            break;
        case SJRouteDescTypeSepcial:
        {
            self.descLabel.text = @"鸟斯基SPECIAL";
        }
            break;
        case SJRouteDescTypeOther:
        {
            self.descLabel.text = @"其他";
        }
            break;
        case SJRouteDescTypeComment:
        {
            self.descLabel.text = @"热门评论";
        }
            break;
            
        default:
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(12, 25, 11, 18);
    self.descLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)+2, CGRectGetMinY(self.imageView.frame)-7, 200, 25);
}

@end
