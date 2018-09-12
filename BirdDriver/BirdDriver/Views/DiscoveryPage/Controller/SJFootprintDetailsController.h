//
//  SJFootprintDetailsController.h
//  BirdDriver
//
//  Created by Soul on 2018/7/17.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//
//  足迹👣详情页面

#import "SPListViewController.h"
#import "JABbsPresenter.h"

@interface SJFootprintDetailsController : SPListViewController

/**
 活动id，用来查询详情
 */
@property (assign, nonatomic) NSInteger activityId;

/**
 H5版本的足迹详情地址，用于分享
 */
@property (copy, nonatomic) NSString *detailStr;

/**
 获取到的活动详情
 */
@property (strong, nonatomic) JABBSModel *activityModel;

/**
 获取到的评论集合
 */
@property (strong, nonatomic) JACommentListModel *commentListModel;

@property (nonatomic, copy) void(^deleteBlock)(void);

@end
