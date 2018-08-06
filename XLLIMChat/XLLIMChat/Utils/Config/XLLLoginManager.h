//
//  XLLLoginManager.h
//  XLLIMChat
//
//  Created by 肖乐 on 2018/7/20.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//  登录注册逻辑实例

#import <Foundation/Foundation.h>

@interface XLLLoginManager : NSObject

/**
 初始化登录注册实例

 @return 单例对象
 */
+ (instancetype)shareLoginManager;

/**
 登录

 @param userName 登录名
 @param password 登录密码
 @param successBlock 成功回执
 */
- (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
             successBlock:(void(^)(void))successBlock;

/**
 注册

 @param userName 注册名
 @param password 注册密码
 @param successBlock 成功回执
 */
- (void)registerWithUserName:(NSString *)userName
                    password:(NSString *)password
                successBlock:(void(^)(void))successBlock;

@end
