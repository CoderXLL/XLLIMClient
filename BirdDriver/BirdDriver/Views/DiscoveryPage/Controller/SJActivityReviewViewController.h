//
//  SJActivityReviewViewController.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPViewController.h"
#import "JACommentListModel.h"

@interface SJActivityReviewViewController : SPViewController

/**
 活动id，用来查询详情
 */
@property (assign, nonatomic) NSInteger activityId;

/**
 发帖人Id，用来判断是否拉黑
 */
@property (assign, nonatomic) NSInteger authorId;

//回复model
@property (nonatomic, retain)JACommentModel *returnCommentModel;

//回复主题ID
@property (nonatomic, assign) NSInteger parentCommentId;

@end
