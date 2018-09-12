//
//  SJBuildNoteTitleCell.h
//  BirdDriverBuildNoteDemo
//
//  Created by Soul on 2018/7/4.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseCell.h"
@class SJBuildNoteModel;

@interface SJBuildNoteTitleCell : SPBaseCell

@property (strong, nonatomic) SJBuildNoteModel *noteModel;
@property (copy, nonatomic) void(^reloadBlock)(void);

@end
