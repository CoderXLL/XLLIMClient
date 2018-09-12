//
//  JABannerPresenter.m
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/30.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JABannerPresenter.h"

@implementation JABannerPresenter

+ (void)postQueryBanner:(JABannerPlatform)platform
                 Result:(void (^)(JABannerListModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_banner_queryByPlatform
                    Parameters:@{
                                 @"platform":@(platform)
                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JABannerListModel *model = [JABannerListModel mj_objectWithKeyValues:data];
                           LogD(@"轮播图请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"轮播图请求失败:%@",errModel);
                           JABannerListModel *model = [JABannerListModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

@end
