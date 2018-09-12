//
//  JAUserPresenter.m
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/22.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAUserPresenter.h"

@implementation JAUserPresenter


+ (void)postLoginAccount:(NSString *)mobilePhone
             WithSmsCode:(NSString *)verifycode
                  Result:(void (^)(JALoginModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_users_login
                    Parameters:@{
                                 kHttp_Request_loginAccount:mobilePhone,
                                 kHttp_Request_smsCode:verifycode
                                 }
                       Success:^(NSData * _Nullable data) {
                           JALoginModel *model = [JALoginModel mj_objectWithKeyValues:data];
                           LogD(@"登录请求成功:%@",model);
                           //存储登录成功返回的authKey，用于请求Header
                           if (model.success) {
                               NSString *authKey = [model.authkey copy];
                               if (!kStringIsEmpty(authKey)) {
                                   LogD(@"登录成功保存Authkey:%@,用于之后的请求头",authKey);
                                   SPUserDefault.kLastLoginAuthKey = authKey;
                               }
                            
                                //需要更新accountModel到LocalInfo
                               if (!kStringIsEmpty(model.userAccount.nickName)) {
                               SPLocalInfo.hasBeenLogin = YES;
                               }
                               SPLocalInfo.userModel = model.userAccount;
                           }
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"登录请求失败:%@",errModel);
                           
                           //需要更新登录状态到LocalInfo
                           SPLocalInfo.hasBeenLogin = NO;
                           SPLocalInfo.userModel = [[JAUserAccount alloc] init];
                           
                           JALoginModel *model = [JALoginModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postLogOut:(NSString *)mobilePhone
            Result:(void (^)(JAResponseModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_users_logOut
                    Parameters:@{
                                 kHttp_Request_loginAccount:mobilePhone
                                 
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"退出请求成功:%@",model);
                           
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"登出请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postAutoLogin:(void (^)(JAUserModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_users_userInfo
                       Success:^(NSData * _Nullable data) {
                           JAUserModel *model = [JAUserModel mj_objectWithKeyValues:data];
                           LogD(@"自动登录请求成功:%@",model);
                           
                           //需要更新accountModel到LocalInfo
                           if (model.success) {
                               if (!kStringIsEmpty(model.data.nickName)) {
                                   SPLocalInfo.hasBeenLogin = YES;
                                   SPLocalInfo.userModel = model.data;
                               }
                           }
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"自动登录请求失败:%@",errModel);
                           JAUserModel *model = [JAUserModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           
                           //需要更新登录状态到LocalInfo
                           SPLocalInfo.hasBeenLogin = NO;
                           SPLocalInfo.userModel = [[JAUserAccount alloc] init];
                           retBlock(model);
                       }];
}

+ (void)postGetWXLoginInfoWithCode:(NSString *)code
                            Result:(void(^_Nonnull)(JAWXLoginInfoModel *_Nullable model))retBlock
{
    [JAHTTPManager postRequest:kURL_users_wxlogin
                    Parameters:@{
                                 @"code":code
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAWXLoginInfoModel *model = [JAWXLoginInfoModel mj_objectWithKeyValues:data];
                           LogD(@"微信登录成功:%@",model)
                           //存储登录成功返回的authKey，用于请求Header
                           if (model.success) {
                               NSString *authKey = [model.authkey copy];
                               if (!kStringIsEmpty(authKey)) {
                                   LogD(@"登录成功保存Authkey:%@,用于之后的请求头",authKey);
                                   SPUserDefault.kLastLoginAuthKey = authKey;
                               }
                               
                               //需要更新accountModel到LocalInfo
                               SPLocalInfo.hasBeenLogin = YES;
                               SPLocalInfo.userModel = model.userAccount;
                           }
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"微信登录失败")
                           JAWXLoginInfoModel *model = [JAWXLoginInfoModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postWXModifyUserInfo:(NSInteger)authId
         smsVerificationCode:(NSString *)smsVerificationCode
                 userAccount:(NSDictionary *)userAccount
                      Result:(void (^_Nonnull)(JALoginModel * _Nullable model))retBlock
{
    [JAHTTPManager postRequest:kURL_users_wxModifyUserInfo
                    Parameters:@{
                                 @"authId":@(authId),
                                 @"smsVerificationCode":smsVerificationCode,
                                 @"userAccount":userAccount
                                 }
                       Success:^(NSData * _Nullable data) {
                           JALoginModel *model = [JALoginModel mj_objectWithKeyValues:data];
                           LogD(@"登录请求成功:%@",model);
                           //存储登录成功返回的authKey，用于请求Header
                           if (model.success) {
                               NSString *authKey = [model.authkey copy];
                               if (!kStringIsEmpty(authKey)) {
                                   LogD(@"登录成功保存Authkey:%@,用于之后的请求头",authKey);
                                   SPUserDefault.kLastLoginAuthKey = authKey;
                               }
                               
                               //需要更新accountModel到LocalInfo
                               SPLocalInfo.hasBeenLogin = YES;
                               SPLocalInfo.userModel = model.userAccount;
                           }
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"微信登录绑定手机号失败")
                           //需要更新登录状态到LocalInfo
                           SPLocalInfo.hasBeenLogin = NO;
                           SPLocalInfo.userModel = [[JAUserAccount alloc] init];
                           
                           JALoginModel *model = [JALoginModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postQueryUserInfo:(void (^)(JAUserModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_users_userInfo
                       Success:^(NSData * _Nullable data) {
                           JAUserModel *model = [JAUserModel mj_objectWithKeyValues:data];
                           LogD(@"用户信息请求成功:%@",model);
                           if (model.success) {
                               //需要更新accountModel到LocalInfo
                               SPLocalInfo.userModel = model.data;
                           }
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"用户信息请求失败:%@",errModel);
                           
                           JAUserModel *model = [JAUserModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postQueryOtherUserInfo:(NSInteger)watchUid
                        Result:(void (^)(JAUserAccount * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_users_otherUserInfo
                    Parameters:@{
                                 @"watchUid":@(watchUid)
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAUserAccount *model = [JAUserAccount mj_objectWithKeyValues:data];
                           LogD(@"获取其他用户的主页信息请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"获取其他用户的主页信息请求失败:%@",errModel);
                           JAUserAccount *model= [JAUserAccount new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postQueryHotUserList:(NSInteger)userType
                    IsPaging:(BOOL)isPaging
             WithCurrentPage:(NSInteger)currentPage
                   WithLimit:(NSInteger)limit
                      Result:(void (^)(JAUserListModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_users_queryHotUser
                    Parameters:@{
                                 @"userType":@(userType),
                                 @"isPaging":@(isPaging),
                                 @"currentPage":@(currentPage),
                                 @"limit":@(limit)
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAUserListModel *model = [JAUserListModel mj_objectWithKeyValues:data];
                           LogD(@"获取热门用户列表请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"获取热门用户列表请求失败:%@",errModel);
                           JAUserListModel *model= [JAUserListModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postQueryFansList:(void (^)(JAFansListModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_users_queryFans
                       Success:^(NSData * _Nullable data) {
                           JAFansListModel *model = [JAFansListModel mj_objectWithKeyValues:data];
                           LogD(@"用户粉丝列表请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"用户粉丝列表请求失败:%@",errModel);
                           JAFansListModel *model = [JAFansListModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postQueryFansListWithTargetUserId:(NSInteger)targetUserId
                        WithPage:(NSInteger)currentPage
                       WithLimit:(NSInteger)limit
                          Result:(void (^)(JAFansListModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_users_queryFans
                    Parameters:@{
                                 @"targetUserId":@(targetUserId),
                                 @"currentPage":@(currentPage),
                                 @"limit":@(limit),
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAFansListModel *model = [JAFansListModel mj_objectWithKeyValues:data];
                           LogD(@"用户粉丝列表请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"用户粉丝列表请求失败:%@",errModel);
                           JAFansListModel *model = [JAFansListModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postBindWeChat:(NSString *)code
                Result:(void(^_Nonnull)(JAResponseModel * _Nullable model))retBlock
{
    [JAHTTPManager postRequest:kURL_users_bindWeChat
                    Parameters:@{
                                 @"code":code
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"绑定微信成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"绑定微信失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postunBindWeChatResult:(void(^_Nonnull)(JAResponseModel * _Nullable model))retBlock
{
    [JAHTTPManager postRequest:kURL_users_unbindWeChat Success:^(NSData * _Nullable data) {
        
        JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
        LogD(@"解除绑定微信成功:%@",model);
        retBlock(model);
    } Failure:^(JAResponseModel * _Nullable errModel) {
        LogD(@"解除绑定微信失败:%@",errModel);
        retBlock(errModel);
    }];
}

+ (void)postWeiXinChangeTiePhone:(NSInteger)authId
             smsVerificationCode:(NSString *)smsVerificationCode
                     userAccount:(NSDictionary *)userAccount
                          Result:(void(^_Nonnull)(JALoginModel * _Nullable model))retBlock
{
    [JAHTTPManager postRequest:kURL_users_weiXinChangeTiePhone
                    Parameters:@{
                                 @"authId":@(authId),
                                 @"smsVerificationCode":smsVerificationCode,
                                 @"userAccount":userAccount
                                 }
                       Success:^(NSData * _Nullable data) {
                           JALoginModel *model = [JALoginModel mj_objectWithKeyValues:data];
                           LogD(@"登录请求成功:%@",model);
                           //存储登录成功返回的authKey，用于请求Header
                           if (model.success) {
                               NSString *authKey = [model.authkey copy];
                               if (!kStringIsEmpty(authKey)) {
                                   LogD(@"登录成功保存Authkey:%@,用于之后的请求头",authKey);
                                   SPUserDefault.kLastLoginAuthKey = authKey;
                               }
                               
                               //需要更新accountModel到LocalInfo
                               SPLocalInfo.hasBeenLogin = YES;
                               SPLocalInfo.userModel = model.userAccount;
                           }
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"微信登录绑定手机号失败")
                           //需要更新登录状态到LocalInfo
                           SPLocalInfo.hasBeenLogin = NO;
                           SPLocalInfo.userModel = [[JAUserAccount alloc] init];
                           
                           JALoginModel *model = [JALoginModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postQueryAttenionsList:(void (^)(JAAttentionsListModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_users_queryAttentions
                       Success:^(NSData * _Nullable data) {
                           NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                           LogD(@"%@", json)
                           JAAttentionsListModel *model = [JAAttentionsListModel mj_objectWithKeyValues:data];
                           LogD(@"用户关注列表请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"用户关注列表请求失败:%@",errModel);
                           JAAttentionsListModel *model = [JAAttentionsListModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postQueryAttenionListWithTargetUserId:(NSInteger)targetUserId
                            WithPage:(NSInteger)currentPage
                           WithLimit:(NSInteger)limit
                              Result:(void (^)(JAAttentionsListModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_users_queryAttentions
                    Parameters:@{
                                 @"targetUserId":@(targetUserId),
                                 @"currentPage":@(currentPage),
                                 @"limit":@(limit)
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAAttentionsListModel *model = [JAAttentionsListModel mj_objectWithKeyValues:data];
                           LogD(@"用户关注列表请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"用户关注列表请求失败:%@",errModel);
                           JAAttentionsListModel *model = [JAAttentionsListModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postAttentionUser:(NSInteger)followedUid
                   Result:(void (^)(JAAttentionUserModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_users_attentionUser
                    Parameters:@{
                                 @"followedUid":@(followedUid)
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAAttentionUserModel *model = [JAAttentionUserModel mj_objectWithKeyValues:data];
                           LogD(@"关注用户请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"关注用户请求失败:%@",errModel);
                           JAAttentionUserModel *model = [JAAttentionUserModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postCancelAttentionUser:(NSInteger)followedUid
                         Result:(void (^)(JAResponseModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_users_cancelAtteninUser
                    Parameters:@{
                                 @"followedUid":@(followedUid)
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"取消关注用户请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"取消关注用户请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postAuthRealName:(NSString *)realName
               IdCardNum:(NSString *)idCardNum
                  Result:(void (^)(JAResponseModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_users_authName
                    Parameters:@{
                                 @"realName":realName,
                                 @"cardId":idCardNum
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"实名认证请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"实名认证请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postChangePhone:(NSString *)newMobilePhone
             VerifyCode:(NSString *)verifyCode
                 Result:(void (^)(JAResponseModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_users_bindPhone
                    Parameters:@{
                                 @"newMobilePhone":newMobilePhone,
                                 @"smsVerificationCode":verifyCode
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"绑定手机请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"绑定手机请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postOldPhoneCheck:(NSString *)oldMobilePhone
                   Result:(void (^)(JAResponseModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_users_oldPhoneCheck
                    Parameters:@{
                                 @"oldPhoneNum":oldMobilePhone,
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"修改手机号之前校验输入的旧号码是否正确请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"修改手机号之前校验输入的旧号码是否正确请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postUpdateUserHeadImg:(NSString *)imageUrl
                       Result:(void (^)(JAResponseModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_users_updateHeadImg
                    Parameters:@{
                                 @"imageUrl":imageUrl
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"修改头像请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"修改头像请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postUpdateUserHobby:(NSString *)hobbies
                     Result:(void (^)(JAResponseModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_users_updateHobby
                    Parameters:@{
                                 @"hobbies":hobbies
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"修改头像请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"修改头像请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postUpdateUserInfo:(NSInteger)uid
             WithAvatarUrl:(NSString *)avatarUrl
              WithNickname:(NSString *)nickName
               WithAddress:(NSString *)address
                 WithEmail:(NSString *)email
                   WithSex:(NSString *)sex
          WithPersonalSign:(NSString *)personalSign
                    WithQq:(NSString *)qq
                WithWechat:(NSString *)weiXin
               WithHobbies:(NSString *)hobbies
                    Result:(void (^)(JAResponseModel * _Nullable))retBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"uid":@(uid)
                                                                                }];
    if (!kStringIsEmpty(avatarUrl)) {
        [dict setObject:avatarUrl forKey:@"avatarUrl"];
    }
    
    if (!kStringIsEmpty(nickName)) {
        [dict setObject:nickName forKey:@"nickName"];
    }

    if (!kStringIsEmpty(address)) {
        [dict setObject:address forKey:@"address"];
    }
    
    if (!kStringIsEmpty(email)) {
        [dict setObject:email forKey:@"email"];
    }
    
    if (!kStringIsEmpty(sex)) {
        [dict setObject:sex forKey:@"sex"];
    }

    if (!kStringIsEmpty(personalSign)) {
        [dict setObject:personalSign forKey:@"personalSign"];
    }

    if (!kStringIsEmpty(qq)) {
        [dict setObject:qq forKey:@"qq"];
    }
    
    if (!kStringIsEmpty(weiXin)) {
        [dict setObject:weiXin forKey:@"weiXin"];
    }
    
    if (!kStringIsEmpty(hobbies)) {
         [dict setObject:hobbies forKey:@"hobbies"];
    }
   
    
    [JAHTTPManager postRequest:kURL_users_updateUserInfo
                    Parameters:dict
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"修改用户资料请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"修改用户资料请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postUpdateUserInfo:(NSInteger)uid
              WithNickname:(NSString *)nickName
              WithBirthDay:(NSTimeInterval)birthday
                   WithSex:(NSString *)sex
          WithPersonalSign:(NSString *)personalSign
                    Result:(void (^)(JAResponseModel * _Nullable))retBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"uid":@(uid)
                                                                                }];
    
    if (!kStringIsEmpty(nickName)) {
        [dict setObject:nickName forKey:@"nickName"];
    }
    
    if (birthday) {
        [dict setObject:[NSNumber numberWithDouble:birthday] forKey:@"birthday"];
    }

    if (!kStringIsEmpty(sex)) {
        [dict setObject:sex forKey:@"sex"];
    }
    
    if (!kStringIsEmpty(personalSign)) {
        [dict setObject:personalSign forKey:@"personalSign"];
    }

    [JAHTTPManager postRequest:kURL_users_updateUserInfo
                    Parameters:dict
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"修改用户资料请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"修改用户资料请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}


+ (void)postAddFeedBack:(NSString *)content
                    Result:(void (^)(JAResponseModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_users_feedBack
                    Parameters:@{
                                 @"content":content,
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"用户反馈请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"用户反馈请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postUserInteraction:(NSInteger)blackedUserId
                     Result:(void (^)(JAResponseModel * _Nullable))retBlock
{
    [JAHTTPManager postRequest:kURL_users_userInteraction
                    Parameters:@{
                                 @"blackedUserId":@(blackedUserId)
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"拉黑请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"拉黑请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postIsBlackList:(NSInteger)blackedUserId
                 Result:(void (^)(JAIsBlockModel * _Nullable))retBlock
{
    [JAHTTPManager postRequest:kURL_users_isBlacklist
                    Parameters:@{
                                 @"blackedUserId":@(blackedUserId)
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAIsBlockModel *model = [JAIsBlockModel mj_objectWithKeyValues:data];
                           LogD(@"是否拉黑请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"是否拉黑请求失败:%@",errModel);
                           JAIsBlockModel *model = [JAIsBlockModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postCancelDefriend:(NSInteger)blackedUserId
                    Result:(void (^)(JAResponseModel * _Nullable))retBlock
{
    [JAHTTPManager postRequest:kURL_users_cancelDefriend
                    Parameters:@{
                                 @"blackedUserId":@(blackedUserId)
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"取消拉黑请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"取消拉黑请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

@end
