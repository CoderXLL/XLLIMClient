//
//  JARouteListModel.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/27.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JARouteListModel.h"

@implementation JARouteListModel

@end

@implementation JARouteListDataModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"list":@"JARouteListItemModel"
             };
}

@end

@implementation JARouteListItemModel

- (instancetype)init
{
    if (self = [super init])
    {
        self.collectionUserList = [NSMutableArray array];
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"collectionUserList":@"JAUserAccountPosList"
             };
}

@end
