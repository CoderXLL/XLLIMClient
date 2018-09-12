//
//  SJSystemMessageListModel.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/8/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJSystemMessageListModel.h"

@implementation SJSystemMessageListModel

@end

@implementation JAPageInfo

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [JASystemModel class]};
}

@end

@implementation JASystemModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"Id" : @"id",
             };
}

- (instancetype)initWithMessageId:(NSInteger)MessageId
                       createTime:(NSString *)createTime
                           h5Link:(NSString *)h5Link
                    imagesAddress:(NSString *)imagesAddress
                        isDeleted:(NSString *)isDeleted
                           isRead:(NSString *)isRead
                   lastUpdateTime:(NSString *)lastUpdateTime
                   messageContent:(NSString *)messageContent
                     messageTitle:(NSString *)messageTitle
                      messageType:(NSInteger)messageType
                 messageValidTime:(NSString *)messageValidTime
{
    self = [super init];
    
    if (self) {
        self.ID = MessageId;
        self.createTime = createTime;
        self.h5Link = h5Link;
        self.imagesAddress = imagesAddress;
        if ([isDeleted isEqualToString:@"YES"]) {
            self.isDeleted = YES;
        } else {
            self.isDeleted = NO;
        }
        if ([isRead isEqualToString:@"YES"]) {
            self.isRead = YES;
        } else {
            self.isRead = NO;
        }
        self.lastUpdateTime = lastUpdateTime;
        self.messageContent = messageContent;
        self.messageTitle = messageTitle;
        self.messageType = messageType;
        self.messageValidTime = messageValidTime;

    }
    
    return self;
}


@end
