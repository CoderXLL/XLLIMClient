//
//  SJNoteSubReplyController.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/9.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  帖子子回复控制器

#import "SPListViewController.h"
@class JAPostCommentItemModel;

@interface SJNoteSubReplyController : SPListViewController

//父级评论信息
@property (nonatomic, strong) JAPostCommentItemModel *superCommentModel;

/**
 投诉或删除楼主评论的回调
 */
@property (nonatomic, copy)void(^deleteBlock)(NSInteger);

@end
