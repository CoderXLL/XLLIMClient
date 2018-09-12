//
//  JAActivityListModel.m
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/31.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAActivityListModel.h"

@implementation JAActivityListModel

+ (NSDictionary *)objectClassInArray{
    return @{
             @"activitysList" : [JAActivityModel class],
             @"postsList" : [JAPostsModel class]
             };
}

@end

@implementation JAActivityModel

- (NSString *)nickName
{
    return kStringIsEmpty(_nickName)?[NSString stringWithFormat:@"用户%zd", self.detailsUserId]:_nickName;
}

@end

@implementation JAPostsModel

- (NSString *)nickName
{
    return kStringIsEmpty(_nickName)?[NSString stringWithFormat:@"用户%zd", self.detailsUserId]:_nickName;
}

- (NSString *)detailsLabels
{
    return [_detailsLabels stringByReplacingOccurrencesOfString:@"#" withString:@""];
}

@end
