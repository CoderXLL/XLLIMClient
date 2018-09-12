//
//  SJBuildNoteController.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  新建帖子

#import "SPListViewController.h"

@class JABbsLabelModel, JAPostsModel;

@interface SJBuildNoteController : SPListViewController

//默认标签
@property (nonatomic, strong) JABbsLabelModel *defaultTagLabel;

//编辑草稿贴模型
@property (nonatomic, strong) JAPostsModel *postsModel;
@property (nonatomic, copy) void(^buildSuccssBlock)(void);

@end
