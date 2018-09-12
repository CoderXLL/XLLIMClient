//
//  SJNoteCommentController.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/9.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  帖子评论详情

#import "SPListViewController.h"

@interface SJNoteCommentController : SPListViewController

@property (nonatomic, assign) NSInteger noteId;

@property (nonatomic, copy) void(^deleteBlock)(NSInteger);

@end
