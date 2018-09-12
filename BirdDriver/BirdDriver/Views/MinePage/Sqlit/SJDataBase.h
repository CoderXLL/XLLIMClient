//
//  SJDataBase.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/8/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJSystemMessageListModel.h"

@interface SJDataBase : NSObject

+ (void)insertWithModel:(JASystemModel *)model;//插入消息体
+ (void)deleteWithTable:(NSInteger)messageId;//根据ID删除消息体
+ (void)updateWithModel:(JASystemModel *)model messageId:(NSInteger)messageId;//根据ID更新消息是否已读状态
+ (NSArray *)searchSystemMessage;//获取全部消息
+ (JASystemModel *)searchWithId:(NSInteger)searchMessageId;//根据ID获取消息体
+(NSInteger)getNotReadNum;//获取未读数量
+(void)readAllMessage;//全部已读


@end
