//
//  JAAttentionsListModel.m
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/29.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAAttentionsListModel.h"

@implementation JAAttentionsListModel

+ (NSDictionary *)objectClassInArray{
    return @{
             @"userList" : [JAUserAccount class]
             };
}
@end


@implementation JAAttentionData

+ (NSDictionary *)objectClassInArray{
    return @{
             @"list" : [JAUserAccount class]
             };
}

@end


