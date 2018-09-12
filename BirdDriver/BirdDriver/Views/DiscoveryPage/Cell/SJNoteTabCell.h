//
//  SJNoteTabCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  帖子标签cell

#import "SPBaseCell.h"

@class JABbsLabelModel;
@protocol SJNoteTabCellDelegate <NSObject>

- (void)didChoosedTag:(JABbsLabelModel *)tagModel;

@end

@interface SJNoteTabCell : SPBaseCell

@property (nonatomic, strong) NSMutableArray *tabs;
@property (nonatomic, weak) id <SJNoteTabCellDelegate>delegate;

@end
