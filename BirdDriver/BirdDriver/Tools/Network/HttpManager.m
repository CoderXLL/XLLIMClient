//
//  HttpManager.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/4.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "HttpManager.h"
#import <AFNetworking/AFNetworking.h>

@interface HttpManager ()

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;

@end

@implementation HttpManager
static HttpManager *_instance = nil;

+ (instancetype)sharedHttpManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.httpManager = [AFHTTPSessionManager manager];
        //设置响应相关
        [self setupResponseSerializer];
        //设置请求相关
        [self setupRequestSerializer];
        //设置验证相关
        self.httpManager.securityPolicy = [self customSecurityPolicy];
    }
    return self;
}

//单向验证
- (AFSecurityPolicy *)customSecurityPolicy
{
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setValidatesDomainName:NO];
    [securityPolicy setAllowInvalidCertificates:YES];
    return securityPolicy;
}

//请求相关
- (void)setupRequestSerializer
{
    self.httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.httpManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    self.httpManager.requestSerializer.timeoutInterval = JA_TIME_OUT;
}

//响应相关
- (void)setupResponseSerializer
{
    self.httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"application/x-www-form-urlencoded", @"multipart/form-data", @"text/plain", @"image/jpeg", @"image/png", @"application/octet-stream",  nil];
}

- (NSURLSessionDataTask*)filePOST:(NSString *)url
            params:(NSDictionary *)params
          fileData:(id)fileData
       fileDataKey:(NSString *)fileDataKey
          progress:(void(^)(NSProgress *  uploadProgress))progress
           success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
           failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure
{
    //公共请求头
    [self setupPublicHeaders];
    
    LogD(@"%@", [NSString stringWithFormat:@"%@/%@", JA_SERVER_HOST, url])
    //网络请求
    NSURLSessionDataTask *dataTask = [self.httpManager POST:[NSString stringWithFormat:@"%@/%@", JA_SERVER_HOST, url] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // mimeType还需处理
        [formData appendPartWithFileData:fileData name:fileDataKey fileName:@"123.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];
    return dataTask;
}

- (void)POST:(NSString *)url
      params:(NSDictionary *)params
    progress:(void (^)(NSProgress *))progress
     success:(void (^)(NSURLSessionDataTask *, id))success
     failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSString *realUrl = [self domainTransfer:url];
    // 公共请求头
    [self setupPublicHeaders];
    // POST
    [self.httpManager POST:realUrl parameters:params progress:^(NSProgress *  uploadProgress) {
        
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask *  task, id  _Nullable responseObject) {
        
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *  error) {
        
        if (failure) {
            failure(task, error);
        }
    }];
}

- (void)GET:(NSString *)url
     params:(NSDictionary *)params
   progress:(void (^)(NSProgress *))progress
    success:(void (^)(NSURLSessionDataTask *, id))success
    failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSString *realUrl = [self domainTransfer:url];
    // 公共请求头
    [self setupPublicHeaders];
    // GET
    [self.httpManager GET:realUrl parameters:params progress:^(NSProgress *  uploadProgress) {
        
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask *  task, id  _Nullable responseObject) {
        
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *  error) {
        
        if (failure) {
            failure(task, error);
        }
    }];
}


- (NSString *)domainTransfer:(NSString *)url
{
    return url;
}

- (void)setupPublicHeaders
{
    //现在这里要多加个宽高了
    AFHTTPRequestSerializer *requestSerializer = self.httpManager.requestSerializer;
    if (!kStringIsEmpty(SPUserDefault.kLastLoginAuthKey))
    {
        LogD(@"authKey-%@", SPUserDefault.kLastLoginAuthKey)
        [requestSerializer setValue:SPUserDefault.kLastLoginAuthKey forHTTPHeaderField:@"authKey"];
    }
}

@end
