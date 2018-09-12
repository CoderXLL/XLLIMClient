//
//  JAUserListModel.m
//  BirdDriverAPI
//
//  Created by Soul on 2018/6/5.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAUserListModel.h"

@implementation JAUserListModel

@end

@implementation JAUserListData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [JAUserAccount class]};
}

@end



