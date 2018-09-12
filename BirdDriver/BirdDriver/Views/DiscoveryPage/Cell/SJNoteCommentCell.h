//
//  SJNoteCommentCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/16.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseCell.h"
#import "SJNoteReplyProtocol.h"
@class JAPostCommentItemModel;

@interface SJNoteCommentCell : SPBaseCell

@property (nonatomic, strong) JAPostCommentItemModel *commentModel;
@property (nonatomic, assign) NSInteger floorCount;
@property (nonatomic, weak) id <SJNoteReplyProtocol>delegate;

@end
