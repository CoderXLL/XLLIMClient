//
//  SJBuildActivityController.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/25.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  新建活动

#import "SPListViewController.h"

@interface SJBuildActivityController : SPListViewController

@property (nonatomic, copy) void(^buildSuccessBlock)(void);

@end
