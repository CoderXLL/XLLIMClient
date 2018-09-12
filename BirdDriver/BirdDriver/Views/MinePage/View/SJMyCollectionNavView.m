//
//  SJMyCollectionNavView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJMyCollectionNavView.h"

@interface SJMyCollectionNavView ()



@end

@implementation SJMyCollectionNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIButton *noteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [noteBtn setTitle:@"帖子" forState:UIControlStateNormal];
        [noteBtn setTitleColor:[UIColor colorWithHexString:@"2B3248" alpha:1.0] forState:UIControlStateNormal];
        [noteBtn setTitle:@"帖子" forState:UIControlStateSelected];
        [noteBtn setTitleColor:[UIColor colorWithHexString:@"FFBB04" alpha:1.0] forState:UIControlStateSelected];
        noteBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:noteBtn];
        self.noteBtn = noteBtn;
        
        UIButton *activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [activityBtn setTitle:@"路线" forState:UIControlStateNormal];
        [activityBtn setTitleColor:[UIColor colorWithHexString:@"2B3248" alpha:1.0] forState:UIControlStateNormal];
        [activityBtn setTitle:@"路线" forState:UIControlStateSelected];
        [activityBtn setTitleColor:[UIColor colorWithHexString:@"FFBB04" alpha:1.0] forState:UIControlStateSelected];
        activityBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:activityBtn];
        self.activityBtn = activityBtn;
        
        UIView *sepratorView = [[UIView alloc] init];
        sepratorView.backgroundColor = [UIColor colorWithHexString:@"ECECEC" alpha:1.0];
        [self addSubview:sepratorView];
        self.sepratorView = sepratorView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.noteBtn.frame = CGRectMake(0, 0, (self.frame.size.width-1)*0.5, self.frame.size.height);
    self.sepratorView.frame = CGRectMake(CGRectGetMaxX(self.noteBtn.frame), 2.5, 1, self.frame.size.height - 5);
    self.activityBtn.frame = CGRectMake(CGRectGetMaxX(self.sepratorView.frame), 0, (self.frame.size.width-1)*0.5, self.frame.size.height);
}

@end
