//
//  JADiscRecLabelModel.m
//  BirdDriverAPI
//
//  Created by Soul on 2018/6/5.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JADiscRecLabelModel.h"

@implementation JADiscRecLabelModel

+ (NSDictionary *)objectClassInArray{
    return @{@"labelList" : [JABbsLabelModel class]};
}

@end



