//
//  JABBSModel.m
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/28.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JABBSModel.h"

@implementation JABBSModel

+ (NSDictionary *)objectClassInArray{
    return @{@"userAccountPOsList" : [JAUserAccountPosList class]};
}

- (NSString *)nickName
{
    return kStringIsEmpty(_nickName)?[NSString stringWithFormat:@"用户%zd", self.detail.detailsUserId]:_nickName;
}

@end

@implementation JABbsDetailModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"Id" : @"id",
             };
}

- (CGFloat)titleCellHeight
{
    CGFloat titleHeight = [self.detailsName boundingRectWithSize:CGSizeMake(kScreenWidth-kSJMargin*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SPFont(16.0)} context:nil].size.height;
    titleHeight = MAX(titleHeight, 20.0);
    return titleHeight+21+13+15+20+52+15+20+15;
}

@end


@implementation JAUserAccountPosList

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"Id" : @"id",
             };
}

@end


