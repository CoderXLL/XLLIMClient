//
//  JASharePresenter.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/28.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JASharePresenter.h"

@implementation JASharePresenter

+ (void)postShareActivity:(NSInteger)shareType
                detailsId:(NSInteger)detailsId
                   Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock
{
    [JAHTTPManager postRequest:kURL_share_shareActivity
                    Parameters:@{
                                 @"shareType":@(shareType),
                                 @"detailsId":@(detailsId)
                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"分享任务请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"分享任务请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

@end
