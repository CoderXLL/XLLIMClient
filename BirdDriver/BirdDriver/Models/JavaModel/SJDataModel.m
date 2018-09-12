//
//  SJDataModel.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/6/14.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJDataModel.h"

@implementation SJDataModel

@end


@implementation JAData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [JADataM class]};
}

@end


@implementation JADataM

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"Id" : @"id",
             };
}

@end
