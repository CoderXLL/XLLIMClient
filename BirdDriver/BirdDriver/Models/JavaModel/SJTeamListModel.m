//
//  SJTeamListModel.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJTeamListModel.h"

@implementation SJTeamListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"userAccountPOsList" : [JAUserData class]};
}

@end


@implementation JAUserData

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"Id" : @"id",
             };
}

@end

