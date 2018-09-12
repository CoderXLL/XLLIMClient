//
//  SJNoteReplyCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/9.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseCell.h"
#import "SJNoteReplyProtocol.h"

@class JAPostCommentItemModel, JACommentVOModel;
@interface SJNoteReplyCell : SPBaseCell

@property (nonatomic, strong) id model;

@property (nonatomic, weak) id <SJNoteReplyProtocol> delegate;
@property (nonatomic, assign) BOOL isChildComment;

@end
