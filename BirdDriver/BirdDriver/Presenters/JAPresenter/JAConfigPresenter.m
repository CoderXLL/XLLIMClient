//
//  JAConfigPresenter.m
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/6.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAConfigPresenter.h"

@implementation JAConfigPresenter

+ (void)postWXKeyWithResult:(void (^)(JAWXKeyModel * _Nullable))retBlock
{
    [JAHTTPManager postRequest:kURL_appConfig_getKey Success:^(NSData * _Nullable data) {
        
        JAWXKeyModel *model = [JAWXKeyModel mj_objectWithKeyValues:data];
        LogD(@"获取小程序原始id成功:%@", model);
        retBlock(model);
    } Failure:^(JAResponseModel * _Nullable errModel) {
        
        LogD(@"获取小程序原始id失败:%@",errModel);
        JAWXKeyModel *model= [JAWXKeyModel new];
        model.responseStatus = errModel.responseStatus;
        model.success = errModel.success;
        model.exception = errModel.exception;
        retBlock(model);
    }];
}

@end
