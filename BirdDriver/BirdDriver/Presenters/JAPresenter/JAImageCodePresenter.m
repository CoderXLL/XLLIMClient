//
//  JAImageCodePresenter.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/7.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAImageCodePresenter.h"
#import "HttpManager.h"

@implementation JAImageCodePresenter

+ (void)postGetTokenSuccess:(void (^)(id))success Failure:(void (^)(NSError *))failure
{
    [[HttpManager sharedHttpManager] POST:[NSString stringWithFormat:@"%@%@", JA_SERVER_HOST_V2, kURL_user_getToken] params:nil progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        //这里我就简单处理下成功回调数据吧，没必要考虑太多
        NSDictionary *dataObject;
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            dataObject = responseObject;
        } else {
            dataObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        }
        if (!dataObject) {
            if (failure) {
                failure([NSError errorWithDomain:@"com.Wesili"
                                           code :1001
                                        userInfo:@{NSLocalizedDescriptionKey:@"网络数据结构错误!"}]);
            };
            return;
        }
        if (dataObject[@"Token"])
        {
            if (success) {
                success(dataObject);
            }
        } else {
            if (failure) {
                JAResponseModel *responseModel = [JAResponseModel mj_objectWithKeyValues:dataObject];
                NSError *error = [NSError errorWithDomain:@"com.Wesili"
                                                    code :1001 userInfo:@{NSLocalizedDescriptionKey:responseModel.responseStatus.message}];
                failure(error);
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getImagesCode:(NSString *)token
              Success:(void (^)(id))success
              Failure:(void (^)(NSError *))failure
{
    [[HttpManager sharedHttpManager] GET:[NSString stringWithFormat:@"%@%@Token=%@", JA_SERVER_HOST_V2, @"/imagescode/getimage?", token] params:nil progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        //这里我就简单处理下成功回调数据吧，没必要考虑太多
        UIImage *image = [UIImage imageWithData:responseObject];
        if (success) {
            success (image);
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

@end
