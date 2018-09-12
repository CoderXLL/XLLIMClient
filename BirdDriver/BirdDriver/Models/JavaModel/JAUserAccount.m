//
//  JAUserAccount.m
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/28.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAUserAccount.h"

@implementation JAUserAccount

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"Id" : @"id",
             };
}

// 注掉了，因为通过昵称是否为空决定是否进入新手引导的
//- (NSString *)nickName {
//    return kStringIsEmpty(_nickName)?[NSString stringWithFormat:@"用户%zd", self.Id]:_nickName;
//}

- (NSString *)getShowNickName
{
    return kStringIsEmpty(_nickName)?[NSString stringWithFormat:@"用户%zd", self.Id]:_nickName;
}

@end
