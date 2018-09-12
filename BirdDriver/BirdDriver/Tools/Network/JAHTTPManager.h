//
//  JAHTTPManager.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/21.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JARequestPath.h"
#import "JAResponseModel.h"

@interface JAHTTPManager : NSObject

/**
 使用Java后台时，通用POST模版(不带参数)

 @param relativeURL API接口，相对路径
 @param successfulBlock 成功，返回响应体中的Body
 @param failureBlock 失败，返回基本响应Model，包含Success/Expection/Code/Message
 */
+ (void)postRequest:(NSString * _Nonnull)relativeURL
            Success:(void (^ _Nonnull)(NSData * _Nullable data))successfulBlock
            Failure:(void (^ _Nonnull)(JAResponseModel * _Nullable errModel))failureBlock;

/**
 使用Java后台时，通用POST模版(含参)

 @param relativeURL API接口，相对路径
 @param parameters 字典类型请求Body参数
 @param successfulBlock 成功，返回响应体中的Body
 @param failureBlock 失败，返回基本响应Model，包含Success/Expection/Code/Message
 */
+ (void)postRequest:(NSString * _Nonnull)relativeURL
         Parameters:(NSDictionary *_Nullable)parameters
            Success:(void (^ _Nonnull)(NSData * _Nullable data))successfulBlock
            Failure:(void (^ _Nonnull)(JAResponseModel * _Nullable errModel))failureBlock;

@end
