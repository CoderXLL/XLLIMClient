//
//  SJNoteDetailController.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/16.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  帖子详情

#import "SPListViewController.h"

@interface SJNoteDetailController : SPListViewController

/**
 帖子ID
 */
@property (nonatomic, assign) NSInteger noteId;

/**
 删贴回调
 */
@property (nonatomic, copy) void(^deleteBlock)(void);

@end
