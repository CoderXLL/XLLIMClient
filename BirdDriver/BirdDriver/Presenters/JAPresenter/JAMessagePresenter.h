//
//  JAMessagePresenter.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/6/7.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAPresenter.h"
#import "JAMessageListModel.h"
#import "SJDataModel.h"
#import "SJSystemMessageListModel.h"
#import "JAReadAllMsgModel.h"

@interface JAMessagePresenter : JAPresenter


/**
 用户消息已读
 
 @param messageIds 消息id集合
 @param retBlock 绑消息已读结果
 */
+ (void)postReadMessage:(NSArray *)messageIds
                  Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;


/**
 一键已读用户消息
 
 @param messageType 评论传2    点赞传3  关注4
 @param retBlock 一键已读用户消息结果
 */
+ (void)postreadAllMessage:(NSInteger)messageType
                 messageId:(NSInteger)messageId
                    Result:(void (^_Nonnull)(JAReadAllMsgModel * _Nullable model))retBlock;

/**
 查询用户未读消息数量
 
 @param messageType 消息类型
 @param retBlock 查询用户未读消息数量结果
 */
+ (void)postNotReadMessageCount:(JAMessageType)messageType
                         Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

/**
 查询用户消息
 
 @param messageType 消息类型
 @param currentPage 消息类型
 @param limit 消息类型
 @param retBlock 查询用户消息结果
 */
+ (void)postQueryMessage:(JAMessageType)messageType
                    Page:(NSInteger)currentPage
                   Limit:(NSInteger)limit
                  Result:(void (^_Nonnull)(JAMessageListModel * _Nullable model))retBlock;

+ (void)postDataDictionary:(NSString *)type
                    Result:(void (^)(NSMutableArray * _Nullable array))retBlock;

/**
 判断当前用户是否有可领取任务
  */
+ (void)postHasRewardingResult:(void (^)(JATaskModel * _Nullable model))retBlock;

/**
 查询系统消息
 */
+ (void)postQuerySystemMessage:(NSInteger)messageId
                          Page:(NSInteger)currentPage
                         Limit:(NSInteger)limit
                        Result:(void (^)(SJSystemMessageListModel * _Nullable model))retBlock;
//获取关注。点赞。评论消息
+(void)postMessageList:(JAMessageType)messageType
                  page:(NSInteger)page
                 Limit:(NSInteger)limit
                Result:(void (^)(JAMessageListModel * _Nullable model))retBlock;


@end
