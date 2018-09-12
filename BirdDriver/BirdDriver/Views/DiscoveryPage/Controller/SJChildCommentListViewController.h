//
//  SJChildCommentListViewController.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/8/10.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPListViewController.h"

@interface SJChildCommentListViewController : SPListViewController

/**
 主评论ID
 */
@property (assign, nonatomic) NSInteger commentId;

/**
 足迹ID
 */
@property (assign, nonatomic) NSInteger activityId;
/**
 帖子主体userId
 */
@property (assign, nonatomic) NSInteger commentUserId;

/**
 发帖人Id，用来判断是否拉黑
 */
@property (assign, nonatomic) NSInteger authorId;


@end
