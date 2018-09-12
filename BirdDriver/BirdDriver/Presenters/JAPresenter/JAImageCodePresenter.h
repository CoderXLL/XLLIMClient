//
//  JAImageCodePresenter.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/7.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  获取图形验证码，token。接口v2

#import <Foundation/Foundation.h>

@interface JAImageCodePresenter : NSObject

/**
 获取图形验证码token

 @param success 成功回执
 @param failure 失败回执
 */
+ (void)postGetTokenSuccess:(void(^)(id dataObject))success
                    Failure:(void(^)(NSError *error))failure;


/**
 获取验证图片

 @param success 成功回执
 @param failure 失败回执
 */
+ (void)getImagesCode:(NSString *)token
              Success:(void(^)(id dataObject))success
              Failure:(void(^)(NSError *error))failure;

@end
