//
//  JAPhotoListModel.m
//  BirdDriverAPI
//
//  Created by Soul on 2018/6/4.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAPhotoListModel.h"

@implementation JAPhotoListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"pictureList" : [JAPhotoModel class]};
}

@end

@implementation JAPhotoModel

@end


