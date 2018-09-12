//
//  JAFileUploadPresenter.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/4.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAFileUploadPresenter.h"
#import "HttpManager.h"
#import <AdSupport/AdSupport.h>

@implementation JAFileUploadPresenter

+ (NSURLSessionDataTask *)uploadFile:(NSDictionary *)params
        fileData:(NSData *)fileData
     fileDataKey:(NSString *)fileDataKey
        progress:(void (^)(NSProgress *))progress
         success:(void (^)(id))success
         failure:(void (^)(NSError *))failure
{
    NSURLSessionDataTask *dataTask = [self filePOST:@"fileupload/imageFileUpload"
                                             params:params
                                           fileData:fileData
                                        fileDataKey:fileDataKey
                                           progress:progress
                                            success:success
                                            failure:failure];
    return dataTask;
}

//特殊post请求
+ (NSURLSessionDataTask *)filePOST:(NSString *)url
        params:(NSDictionary *)params
      fileData:(id)fileData
   fileDataKey:(NSString *)fileDataKey
      progress:(void(^)(NSProgress *  uploadProgress))progress
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure
{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //添加私有参数
    if (!kDictIsEmpty(params)) {
        [dict addEntriesFromDictionary:params];
    }
    //添加公共参数
    //deviceId      设备编号
    NSString *uuid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [dict setObject:uuid forKey:kHttp_Request_deviceId];
    //deviceType    设备类型 iOS->2
    [dict setObject:@"2" forKey:kHttp_Request_deviceType];
    //deviceName    设备名称（设备版本号）
    NSString *dotName = [SPShowHandler dotDeviceName];          //iPhone 10,2
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];  //10.3.3
    NSString *systemName = [[UIDevice currentDevice] systemName];       //iOS
    NSString *deviceName = [NSString stringWithFormat:@"%@(%@%@)",dotName,systemName,systemVersion];
    [dict setObject:deviceName forKey:kHttp_Request_deviceName];
    //appVersion    软件版本号
    NSString *appCurVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [dict setObject:appCurVersion forKey:kHttp_Request_appVersion];
    
    NSURLSessionDataTask *dataTask = [[HttpManager sharedHttpManager] filePOST:url params:dict fileData:fileData fileDataKey:fileDataKey progress:progress success:^(NSURLSessionDataTask *operation, id responseObject) {
        
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
        if (dataObject[@"url"])
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
    return dataTask;
}

@end
