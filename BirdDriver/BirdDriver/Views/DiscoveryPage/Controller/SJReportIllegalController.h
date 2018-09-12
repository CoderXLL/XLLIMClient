//
//  SJReportIllegalController.h
//  BirdDriver
//
//  Created by Soul on 2018/7/17.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//
//  举报页面

#import "SPViewController.h"
#import "JABBSModel.h"

@protocol SJReportIllegalDelegate <NSObject>

- (void)didReportSuccessful;

@end

@interface SJReportIllegalController : SPViewController

/**
 获取到的活动详情
 */
@property (strong, nonatomic) JABBSModel *activityModel;

@property (nonatomic, weak) id<SJReportIllegalDelegate> delegate;

@end
