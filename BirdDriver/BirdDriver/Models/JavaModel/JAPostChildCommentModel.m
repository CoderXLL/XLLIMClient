//
//  JAPostChildCommentModel.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/9/3.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAPostChildCommentModel.h"

@implementation JAPostChildCommentModel

@end

@implementation SJPostChildCommentDataModel

- (instancetype)init
{
    if (self = [super init])
    {
        self.list = [NSMutableArray array];
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"list":@"JACommentVOModel"
             };
}

@end
