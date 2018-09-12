//
//  JAResponseModel.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/21.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPBaseModel.h"

typedef NS_ENUM(NSInteger, JAPostsRunStatus) {
    JAPostsRunStatusDraft       = 1,    //草稿
    JAPostsRunStatusAuditing    = 2,    //审核中
    JAPostsRunStatusAuditFailed = 3,    //审核未通过
    JAPostsRunStatusAuditSucceed= 4     //审核通过
};

@class JAResponseStatus;

@interface JAResponseModel : SPBaseModel

@property (nonatomic, assign) BOOL success;

@property (nonatomic, assign) BOOL exception;

@property (nonatomic, strong) JAResponseStatus *responseStatus;

@property(nonatomic, assign) NSInteger notReadMsgCount; //未读消息总数

@property(nonatomic, assign) NSInteger commentNotReadMsgCount; //评论未读消息总数

@property(nonatomic, assign) NSInteger concernedUnreadMsgCount; //关注未读消息总数

@property(nonatomic, assign) NSInteger likeToReadMsgCount; //点赞未读消息总数

@property(nonatomic, assign) NSInteger nsjMessageCount; //小秘书未读消息总数

//@property(nonatomic, assign) NSInteger collectionId; //坑爹东西

@end

@interface JAResponseStatus : NSObject

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *code;

@end

