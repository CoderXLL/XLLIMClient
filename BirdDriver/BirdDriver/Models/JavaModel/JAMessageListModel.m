//
//  JAMessageListModel.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/6/7.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAMessageListModel.h"

@implementation JAMessageListModel

@end

@implementation JAMessageData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [JAMessageModel class]};
}

@end
