//
//  SJUserTagsView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJUserTagsView.h"

@implementation SJUserTagsView

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
    self.backgroundColor = [UIColor clearColor];
}

- (void)setTagList:(NSArray *)tagList
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _tagList = tagList;
    for (NSString *tagStr in tagList) {
        
        NSInteger index = [tagList indexOfObject:tagStr];
        CGFloat tagWidth = 60.0;
        CGFloat margin = (kScreenWidth-tagWidth*tagList.count-10*(tagList.count-1))*0.5;
        UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin+index*(tagWidth+10), 0, tagWidth, 21)];
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.textColor = [UIColor colorWithHexString:@"C9CFDE" alpha:1];
        tagLabel.layer.cornerRadius = 4.0;
        tagLabel.backgroundColor = [UIColor clearColor];
        tagLabel.layer.borderColor = [UIColor colorWithHexString:@"C9CFDE" alpha:1].CGColor;
        tagLabel.layer.borderWidth = 1.0;
        tagLabel.font = SPFont(11.0);
        NSString *realTagStr = [tagStr stringByReplacingOccurrencesOfString:@"#" withString:@""];
        tagLabel.text = realTagStr;
        [self addSubview:tagLabel];
    }
}

@end
