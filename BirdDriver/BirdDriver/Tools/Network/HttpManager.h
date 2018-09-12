//
//  HttpManager.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/4.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpManager : NSObject

+ (instancetype)sharedHttpManager;


/**
 muti-form post请求

 @param url 请求名
 @param params 参数
 @param fileData 二进制流
 @param fileDataKey fileDataKey
 @param progress 进度回执
 @param success 成功回执
 @param failure 失败回执
 @return 上传任务
 */
- (NSURLSessionDataTask*)filePOST:(NSString *)url
        params:(NSDictionary *)params
      fileData:(id)fileData
   fileDataKey:(NSString *)fileDataKey
      progress:(void(^)(NSProgress *  uploadProgress))progress
       success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
       failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;


/**
 普通post请求

 @param url 请求路径
 @param params 参数
 @param progress 进度回执
 @param success 成功回执
 @param failure 失败回执
 */
- (void)POST:(NSString *)url
      params:(NSDictionary *)params
    progress:(void(^)(NSProgress *  uploadProgress))progress
     success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;

/**
 Get请求

 @param url 请求路径
 @param params 请求参数
 @param progress 进度回执
 @param success 成功回执
 @param failure 失败回执
 */
- (void)GET:(NSString *)url
     params:(NSDictionary *)params
   progress:(void(^)(NSProgress *  uploadProgress))progress
    success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;

//后续添加其他请求方式 PUT DELETE GET..

@end
