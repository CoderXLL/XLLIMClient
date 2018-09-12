//
//  SJActivityCommentListViewController.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/8/9.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPListViewController.h"
#import "JABBSModel.h"

@interface SJActivityCommentListViewController : SPListViewController

/**
 活动id，用来查询详情
 */
@property (assign, nonatomic) NSInteger activityId;

/**
 活动详情
 */
@property (strong, nonatomic) JABBSModel *activityModel;

/**
 发帖人Id，用来判断是否拉黑
 */
@property (assign, nonatomic) NSInteger authorId;

@end
