//
//  SJMyNoteCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseCell.h"

@class SJMyNoteCell, JAPostsModel;
@protocol SJMyNoteCellDelegate <NSObject>

- (void)didLongPressed:(SJMyNoteCell *)noteCell;

@end

@interface SJMyNoteCell : SPBaseCell

@property (nonatomic, weak) id <SJMyNoteCellDelegate> delegate;
//帖子
@property (nonatomic, strong) JAPostsModel *postsModel;
//是否为我的帖子
@property (nonatomic, assign) BOOL isMineNote;

@end
