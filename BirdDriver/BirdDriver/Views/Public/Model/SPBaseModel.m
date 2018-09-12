//
//  SPBaseModel.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseModel.h"

@implementation SPBaseModel

//快速创建模型
+ (instancetype)model
{
    return [[[self class] alloc] init];
}

//使基类模型拥有归解档能力
#pragma mark - NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        [self mj_decode:aDecoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mj_encode:aCoder];
}

//替换模型属性里不合法属性,约定好后期慢慢增加
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}

@end
