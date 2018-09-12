//
//  SJNoteTitleCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/16.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  帖子详情标题cell

#import "SPBaseCell.h"
@class JABBSModel;

@interface SJNoteTitleCell : SPBaseCell

@property (nonatomic, strong) JABBSModel *detailModel;
@property (nonatomic, copy) void(^userDetailBlock)(JABBSModel *);

@end
