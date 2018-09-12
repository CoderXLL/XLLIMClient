//
//  JAMessageModel.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/6/7.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAMessageModel.h"

@implementation JAMessageModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"Id" : @"id",
             };
}

- (NSString *)nickName {
    return kStringIsEmpty(_nickName)?[NSString stringWithFormat:@"用户%zd", self.sendUserId]:_nickName;
}

@end


@implementation JATaskModel

@end
