//
//  JABannerListModel.m
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/30.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JABannerListModel.h"

@implementation JABannerListModel

@end

@implementation JABannerData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [JABannerModel class]};
}

@end


@implementation JABannerModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"Id" : @"id",
             };
}

@end




