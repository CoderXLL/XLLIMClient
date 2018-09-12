//
//  SJReportController.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  举报

#import "SPListViewController.h"
@class JABBSModel, JACommentModel;

typedef NS_ENUM(NSInteger, SJReportStyle) {
    
    SJReportStyleReply = 1000,  //举报回复
    SJReportStyleNote           //举报帖子
};

@interface SJReportCommentModel: SPBaseModel

@property (nonatomic, copy) NSString *replyContent;
@property (nonatomic, copy) NSString *replyUserName;
@property (nonatomic, assign) NSInteger replyUserId;
@property (nonatomic, assign) NSInteger replyId;

@end

@interface SJReportController : SPListViewController

@property (nonatomic, assign) SJReportStyle reportStyle;
@property (nonatomic, strong) JABBSModel *detailModel;
@property (nonatomic, strong) SJReportCommentModel *commentModel;

@property (nonatomic, copy) void(^reportSuccess)(void);

@end
