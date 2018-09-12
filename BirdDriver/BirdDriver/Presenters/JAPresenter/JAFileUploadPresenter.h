//
//  JAFileUploadPresenter.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/4.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JAFileUploadPresenter : NSObject

/**
 上传文件 （form-data post接口）

 @param params 请求参数
 @param fileData 文件二进制流
 @param fileDataKey fileDataKey
 @param progress 上传进度回执
 @param success 成功回执
 @param failure 失败回执
 @return 上传任务
 */
+ (NSURLSessionDataTask *)uploadFile:(NSDictionary *)params
       fileData:(NSData *)fileData
    fileDataKey:(NSString *)fileDataKey
       progress:(void(^)(NSProgress *uploadProgress))progress
        success:(void(^)(id dataObject))success
        failure:(void(^)(NSError *error))failure;

@end
