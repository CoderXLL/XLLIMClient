                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        //
//  JAMessagePresenter.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/6/7.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAMessagePresenter.h"

@implementation JAMessagePresenter


+ (void)postReadMessage:(NSArray *)messageIds
                 Result:(void (^)(JAResponseModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_message_readMessaget
                    Parameters:@{
                                 @"mesIds":messageIds,
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"消息已读请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"消息已读请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

    


+ (void)postreadAllMessage:(NSInteger)messageType
                 messageId:(NSInteger)messageId
                    Result:(void (^)(JAReadAllMsgModel * _Nullable))retBlock{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (messageType != 0) {
        [dic setObject:@(messageType) forKey:@"messageType"];
    }
    if (messageId != 0) {
        [dic setObject:@(messageId) forKey:@"nsjMessageId"];
    }
    [JAHTTPManager postRequest:kURL_message_readAllMessage
                    Parameters:dic
                       Success:^(NSData * _Nullable data) {
                           JAReadAllMsgModel *model = [JAReadAllMsgModel mj_objectWithKeyValues:data];
                           LogD(@"一键已读消息请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"一键已读消息请求失败:%@",errModel);
                           JAReadAllMsgModel *model = [JAReadAllMsgModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}



+ (void)postNotReadMessageCount:(JAMessageType)messageType
                         Result:(void (^)(JAResponseModel * _Nullable))retBlock{
    NSString *messageID = [[NSUserDefaults standardUserDefaults] objectForKey:@"systemMessageIdB"];
    if ([messageID isKindOfClass:[NSString class]]) {
        if (kStringIsEmpty(messageID)) {
            messageID = @"";
        }
    } else {
        if (kObjectIsEmpty(messageID)) {
           messageID = @"";
        }
    }
    [JAHTTPManager postRequest:kURL_message_notReadMessageCount
                    Parameters:@{@"nsjMessageId":messageID}
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"查询用户未读消息数量请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"查询用户未读消息数量请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}


+ (void)postQueryMessage:(JAMessageType)messageType
                    Page:(NSInteger)currentPage
                   Limit:(NSInteger)limit
                  Result:(void (^)(JAMessageListModel * _Nullable))retBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"currentPage":@(currentPage),
                                                                                @"limit":@(limit)
                                                                                }];
    if (messageType == MessageTypeAll) {
        [dict setObject:@[@2,@3,@4,@5,@6] forKey:@"messageTypes"];
    } else if (messageType == MessageTypeLike){
        [dict setObject:@[@3,@5] forKey:@"messageTypes"];
    }  else if (messageType == MessageTypeComment){
        [dict setObject:@[@2,@6] forKey:@"messageTypes"];
    }  else {
        [dict setObject:@(messageType) forKey:@"messageType"];
    }
    [JAHTTPManager postRequest:kURL_message_queryMessage
                    Parameters:dict
                       Success:^(NSData * _Nullable data) {
                           JAMessageListModel *model = [JAMessageListModel mj_objectWithKeyValues:data];
                           LogD(@"查询用户消息请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"查询用户消息请求失败:%@",errModel);
                           JAMessageListModel *model = [JAMessageListModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+(void)postMessageList:(JAMessageType)messageType
                  page:(NSInteger)page
                 Limit:(NSInteger)limit
                Result:(void (^)(JAMessageListModel * _Nullable))retBlock{
    NSString *stringUrl = @"";
    if (messageType == MessageTypeAttention){
        stringUrl = kURL_userMessage_queryAttentionMessage;
    }  else if (messageType == MessageTypeLike){
        stringUrl = kURL_userMessage_queryLikeMessage;
    }  else  if (messageType == MessageTypeComment){
        stringUrl = kURL_userMessage_queryCommentOnMeMessage;
    }
    [JAHTTPManager postRequest:stringUrl
                    Parameters:@{
                                 @"currentPage":@(page),
                                 @"limit":@(limit)
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAMessageListModel *model = [JAMessageListModel mj_objectWithKeyValues:data];
                           LogD(@"查询用户消息请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"查询用户消息请求失败:%@",errModel);
                           JAMessageListModel *model = [JAMessageListModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}


+ (void)postDataDictionary:(NSString *)type
                  Result:(void (^)(NSMutableArray * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_dataDictionary_queryByType
                    Parameters:@{
                                 @"type":type
                                 }
                       Success:^(NSData * _Nullable data) {
                           NSMutableArray *hobbysArray = [NSMutableArray array];
                           SJDataModel *model = [SJDataModel mj_objectWithKeyValues:data];
                           if (model.success) {
                               for (JADataM *m in model.data.list) {
                                   [hobbysArray addObject:m.remark];
                               }
                           } else {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   
                                   [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                                   [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                               });
                           }
                        LogD(@"查询数据字典请求成功:%@",model);
                           retBlock(hobbysArray);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"查询数据字典请求失败:%@",errModel);
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                               [SVProgressHUD showErrorWithStatus:errModel.responseStatus.message];
                               [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                           });
                       }];
}

+ (void)postHasRewardingResult:(void (^)(JATaskModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_activityTask_hasRewarding
                    Parameters:nil
                       Success:^(NSData * _Nullable data) {
                           JATaskModel *model = [JATaskModel mj_objectWithKeyValues:data];
                           LogD(@"查询当前用户是否有可领取任务请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           JATaskModel *model = [JATaskModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           LogD(@"查询当前用户是否有可领取任务请求失败:%@",errModel);
                           retBlock(model);
                       }];
}


+ (void)postQuerySystemMessage:(NSInteger)messageId
                    Page:(NSInteger)currentPage
                   Limit:(NSInteger)limit
                  Result:(void (^)(SJSystemMessageListModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_systemMessage_querySystemMessage
                    Parameters:@{
                                 @"id": @(messageId),
                                 @"currentPage":@(currentPage),
                                 @"limit":@(limit)
                                 }
                       Success:^(NSData * _Nullable data) {
                           SJSystemMessageListModel *model = [SJSystemMessageListModel mj_objectWithKeyValues:data];
                           LogD(@"查询系统消息请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"查询系统消息请求失败:%@",errModel);
                           SJSystemMessageListModel *model = [SJSystemMessageListModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}






@end
