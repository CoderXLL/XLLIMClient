//
//  SJWXLoginInfoModel.h
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/25.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"
#import "JAUserAccount.h"

@class JAUserAuthModel;
@interface JAWXLoginInfoModel : JAResponseModel


/**
 是否可以登录 YES 可以  NO 不可以
 */
@property (nonatomic, assign) BOOL canYouLogin;

/**
 用户信息
 */
@property (nonatomic, strong) JAUserAccount *userAccount;

/**
 用户第三方信息
 */
@property (nonatomic, strong) JAUserAuthModel *userAuth;

/**
 authKey
 */
@property (nonatomic, copy) NSString *authkey;

/**
 是否授权过
 */
@property (nonatomic, assign) BOOL authorization;



@end

@interface JAUserAuthModel : SPBaseModel

@property (nonatomic, assign) NSInteger ID;

/**
 登录凭证
 */
@property (nonatomic, copy) NSString *loginToken;

/**
 用户唯一标识
 */
@property (nonatomic, copy) NSString *unionId;

/**
 用户唯一标识
 */
@property (nonatomic, copy) NSString *openId;

/**
 登录类型
 */
@property (nonatomic, assign) NSInteger loginType;

/**
 系统用户ID
 */
@property (nonatomic, assign) NSInteger userId;

@end

