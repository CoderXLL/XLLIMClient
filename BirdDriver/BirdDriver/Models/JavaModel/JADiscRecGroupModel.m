//
//  JADiscRecGroupModel.m
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/31.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JADiscRecGroupModel.h"

@implementation JADiscRecGroupModel

@end
@implementation JAActivityPostsModel

+ (NSDictionary *)objectClassInArray{
    return @{
             @"postsList" : [JAPostsModel class],
             @"activitysList" : [JAActivityModel class]
             };
}

@end



