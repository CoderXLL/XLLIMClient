//
//  JAHTTPManager.m
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/21.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAHTTPManager.h"
#import "GVUserDefaults+SPExtension.h"
 

#import <AdSupport/AdSupport.h>
#import <UIKit/UIDevice.h>

@implementation JAHTTPManager

#pragma mark - POST
+ (void)postRequest:(NSString *)relativeURL
            Success:(void (^)(NSData * _Nullable))successfulBlock
            Failure:(void (^)(JAResponseModel * _Nullable))failureBlock{
    [JAHTTPManager postRequest:relativeURL
                    Parameters:nil
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *responseModel = [JAResponseModel mj_objectWithKeyValues:data];
                           if ([responseModel.responseStatus.code isEqualToString:@"9995"]) {
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   //发送退出登录通知
                                   SPLocalInfo.hasBeenLogin = NO;
                                   [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_logoutSuccess object:nil];
                               });
                           }
                           successfulBlock(data);
                       } Failure:failureBlock];
}

+ (void)postRequest:(NSString *)relativeURL
         Parameters:(NSDictionary *)parameters
            Success:(void (^)(NSData * _Nullable))successfulBlock
            Failure:(void (^)(JAResponseModel * _Nullable))failureBlock
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
#pragma mark 检查数据
        //检查参数
        if(kStringIsEmpty(relativeURL)){
            //错误路径
            NSDictionary *errDict = @{
                                      @"exception": @(true),
                                      @"responseStatus": @{
                                              @"code": @"329001",
                                              @"message": @"请求路径不能为空"
                                              },
                                      @"success": @(false)
                                      };
            failureBlock([JAResponseModel mj_objectWithKeyValues:errDict]);
            return;
        }
        
        if(!successfulBlock){
            //错误成功回调
            NSDictionary *errDict = @{
                                      @"exception": @(true),
                                      @"responseStatus": @{
                                              @"code": @"329002",
                                              @"message": @"成功回调参数不能为空"
                                              },
                                      @"success": @(false)
                                      };
            failureBlock([JAResponseModel mj_objectWithKeyValues:errDict]);
            return;
        }
        
        if(!failureBlock){
            //错误失败回调
            NSDictionary *errDict = @{
                                      @"exception": @(true),
                                      @"responseStatus": @{
                                              @"code": @"329003",
                                              @"message": @"失败回调参数不能为空"
                                              },
                                      @"success": @(false)
                                      };
            failureBlock([JAResponseModel mj_objectWithKeyValues:errDict]);
            return;
        }
        
#pragma mark 添加参数
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        //添加私有参数
        if (!kDictIsEmpty(parameters)) {
            [dict addEntriesFromDictionary:parameters];
        }
        //添加公共参数
        //deviceId      设备编号
        NSString *uuid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        [dict setObject:uuid forKey:kHttp_Request_deviceId];
        //deviceType    设备类型 iOS->2
        [dict setObject:@"2" forKey:kHttp_Request_deviceType];
        //app 渠道标识
        [dict setObject:kJPush_channel forKey:kHttp_Request_appChannel];
        //deviceName    设备名称（设备版本号）
        NSString *dotName = [SPShowHandler dotDeviceName];          //iPhone 10,2
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];  //10.3.3
        NSString *systemName = [[UIDevice currentDevice] systemName];       //iOS
        NSString *deviceName = [NSString stringWithFormat:@"%@(%@%@)",dotName,systemName,systemVersion];
        [dict setObject:deviceName forKey:kHttp_Request_deviceName];
        //appVersion    软件版本号
        NSString *appCurVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [dict setObject:appCurVersion forKey:kHttp_Request_appVersion];
        
#pragma mark 构造请求
        //构造请求
        LogD(@"%@", [NSString stringWithFormat:@"%@%@",JA_SERVER_HOST,relativeURL]);
        NSURL *url = [NSString stringWithFormat:@"%@%@",JA_SERVER_HOST,relativeURL].mj_url;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setTimeoutInterval:JA_TIME_OUT];
        [request setHTTPMethod:@"POST"];
#pragma mark 添加请求头
        //存储登录成功返回的authKey，用于请求Header
        if (!kStringIsEmpty(SPUserDefault.kLastLoginAuthKey)) {
            [request setValue:SPUserDefault.kLastLoginAuthKey forHTTPHeaderField:@"authKey"];
        }
        [request setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
        NSError *err = nil;
        NSData *json = [NSJSONSerialization dataWithJSONObject:dict?dict:@""
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&err];
        if(err&&err!=nil){
            LogD(@"请求转换JSON异常：%@",err);
            NSDictionary *errDict = @{
                                      @"exception": @(true),
                                      @"responseStatus": @{
                                              @"code": @"329004",
                                              @"message": @"请求转换Json异常"
                                              },
                                      @"success": @(false)
                                      };
            failureBlock([JAResponseModel mj_objectWithKeyValues:errDict]);
            return;
        }
        
        request.HTTPBody = json;
#pragma mark 发起请求
        // 由于要先对request先行处理,我们通过request初始化task
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                LogD(@"\n!!通用POST-Response:\n%@\n!!通用POST-Error:\n%@",response,error);
                                                if (error) {
                                                    NSString *errCode = [NSString stringWithFormat:@"%ld",(long)error.code];
                                                    NSString *errDescription = [error.localizedDescription substringToIndex:error.localizedDescription.length-1];
                                                    NSDictionary *errDict = @{
                                                                              @"exception": @(true),
                                                                              @"responseStatus": @{
                                                                                      @"code" : errCode,
                                                                                      @"message": errDescription
                                                                                      },
                                                                              @"success": @(false)
                                                                              };
                                                    failureBlock([JAResponseModel mj_objectWithKeyValues:errDict]);
                                                    return ;
                                                }
                                                
                                                if (response && response!=nil) {
                                                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                                                    if (data && data!=nil &&httpResponse.statusCode == 200) {
#pragma mark 正常返回Successful
                                                        successfulBlock(data);
                                                        return;
                                                    }else if (httpResponse.statusCode){
                                                        //底层返回的错误
                                                        NSString *errStatusCode = [NSString stringWithFormat:@"%ld",(long)httpResponse.statusCode];
                                                        NSString *errDescription = @"errDescription";
                                                        if (error.localizedDescription) {
                                                            errDescription = error.localizedDescription;
                                                        }else{
                                                            errDescription = [NSString stringWithFormat:@"错误代码:%ld",(long)httpResponse.statusCode];
                                                        }
                                                        NSDictionary *errDict = @{
                                                                                  @"exception": @(true),
                                                                                  @"responseStatus": @{
                                                                                          @"code" : errStatusCode,
                                                                                          @"message": errDescription
                                                                                          },
                                                                                  @"success": @(false)
                                                                                  };
#pragma mark 底层错误返回
                                                        failureBlock([JAResponseModel mj_objectWithKeyValues:errDict]);
                                                        return ;
                                                    }else{
                                                        NSDictionary *errDict = @{
                                                                                  @"exception": @(true),
                                                                                  @"responseStatus": @{
                                                                                          @"code" : @"329005",
                                                                                          @"message": @"200数据为空"
                                                                                          },
                                                                                  @"success": @(false)
                                                                                  };
#pragma mark 数据为空返回Fail
                                                        failureBlock([JAResponseModel mj_objectWithKeyValues:errDict]);
                                                        return ;
                                                    }
                                                }else{
                                                    NSDictionary *errDict = @{
                                                                              @"exception": @(true),
                                                                              @"responseStatus": @{
                                                                                      @"code" : @"329999",
                                                                                      @"message": @"出现异常未响应"
                                                                                      },
                                                                              @"success": @(false)
                                                                              };
                                                    failureBlock([JAResponseModel mj_objectWithKeyValues:errDict]);
                                                    return ;
                                                }
                                            }];
        LogD(@"\n!!通用POST-Task:\n%@",task);
        [task resume];
    });
}

@end

