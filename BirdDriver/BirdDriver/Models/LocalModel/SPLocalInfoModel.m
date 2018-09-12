//
//  SPLocalInfoModel.m
//  BirdDriver
//
//  Created by Soul on 2017/10/10.
//  Copyright © 2017年 Soul&Polo. All rights reserved.
//

#import "SPLocalInfoModel.h"

static SPLocalInfoModel *localInfo;

@implementation SPLocalInfoModel

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!localInfo) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            localInfo = [super allocWithZone:zone];
        });
    }
    return localInfo;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localInfo = [super init];
    });
    return localInfo;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return localInfo;
}

+ (instancetype)shareInstance {
    return [[self alloc]init];;
}

@end
