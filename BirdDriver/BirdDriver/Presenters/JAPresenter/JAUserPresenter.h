//
//  JAUserPresenter.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/22.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAPresenter.h"

#import "JAUserModel.h"
#import "JALoginModel.h"
#import "JAFansListModel.h"
#import "JAAttentionsListModel.h"
#import "JAUserListModel.h"
#import "JAIsBlockModel.h"
#import "JAWXLoginInfoModel.h"
#import "JAAttentionUserModel.h"

@interface JAUserPresenter : JAPresenter

#pragma mark - 登录注册相关

/**
 登录接口

 @param mobilePhone 手机号
 @param verifycode 验证码
 @param retBlock 登录成功返回success以及userInfo
 */
+ (void)postLoginAccount:(NSString *_Nonnull)mobilePhone
             WithSmsCode:(NSString *_Nonnull)verifycode
                  Result:(void (^_Nonnull)(JALoginModel * _Nullable model))retBlock;

/**
 自动登录接口

 @param retBlock 通过authKey登录成功返回用户信息，失败则说明异端登录/或其他原因导致登录失败
 */
+ (void)postAutoLogin:(void (^_Nonnull)(JAUserModel * _Nullable model))retBlock;


/**
 获取微信信息登录以及登录

 @param code 授权码
 @param retBlock 回执
 */
+ (void)postGetWXLoginInfoWithCode:(NSString *)code
                            Result:(void(^_Nonnull)(JAWXLoginInfoModel *_Nullable model))retBlock;

/**
 微信登录修改手机相关

 @param authId openId
 @param smsVerificationCode 短信验证码
 @param userAccount 用户信息
 @param retBlock 回执
 */
+ (void)postWXModifyUserInfo:(NSInteger)authId
                 smsVerificationCode:(NSString *)smsVerificationCode
                              userAccount:(NSDictionary *)userAccount
                                        Result:(void (^_Nonnull)(JALoginModel * _Nullable model))retBlock;

/**
 绑定微信

 @param code 授权码
 @param retBlock 回执
 */
+ (void)postBindWeChat:(NSString *)code
                Result:(void(^_Nonnull)(JAResponseModel * _Nullable model))retBlock;


/**
 解除绑定微信

 @param retBlock 回执
 */
+ (void)postunBindWeChatResult:(void(^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

/**
 微信登录，换绑手机号

 @param authId openId
 @param smsVerificationCode 短信验证码
 @param userAccount 用户信息
 @param retBlock 回执
 */
+ (void)postWeiXinChangeTiePhone:(NSInteger)authId
             smsVerificationCode:(NSString *)smsVerificationCode
                     userAccount:(NSDictionary *)userAccount
                          Result:(void(^_Nonnull)(JALoginModel * _Nullable model))retBlock;

/**
 登出接口

 @param mobilePhone 已登录的手机号
 @param retBlock 登出返回结果
 */
+ (void)postLogOut:(NSString *_Nonnull)mobilePhone
            Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

#pragma mark - 用户信息相关
/**
 获取热门用户列表
 
 @param userType 用户类型 1：推荐用户， 0：普通用户
 @param isPaging 是否分页
 @param currentPage 当前页数
 @param limit 每页条数
 @param retBlock 查询结果(判断success,取list属性)
 */
+ (void)postQueryHotUserList:(NSInteger)userType
                    IsPaging:(BOOL)isPaging
             WithCurrentPage:(NSInteger)currentPage
                   WithLimit:(NSInteger)limit
                      Result:(void (^_Nonnull)(JAUserListModel * _Nullable model))retBlock;

/**
 查询完整的用户信息

 @param retBlock 查询结果回调
 */
+ (void)postQueryUserInfo:(void (^_Nonnull)(JAUserModel * _Nullable model))retBlock;

/**
 获取其他用户的主页信息

 @param watchUid 其他用户的id
 @param retBlock 查询结果回调
 */
+ (void)postQueryOtherUserInfo:(NSInteger)watchUid
                        Result:(void (^_Nonnull)(JAUserAccount * _Nullable model))retBlock;

/**
 实名认证
 
 @param realName 实名（身份证姓名）
 @param idCardNum 身份证号
 @param retBlock 实名认证结果
 */
+ (void)postAuthRealName:(NSString *_Nonnull)realName
               IdCardNum:(NSString *_Nonnull)idCardNum
                  Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

/**
 换绑手机号
 
 @param newMobilePhone 新手机号
 @param verifyCode 验证码
 @param retBlock 绑定手机号结果
 */
+ (void)postChangePhone:(NSString *_Nonnull)newMobilePhone
             VerifyCode:(NSString *_Nonnull)verifyCode
                 Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

/**
 修改手机号之前校验输入的旧号码是否正确
 
 @param oldMobilePhone 旧手机号
 @param retBlock 校验输入的旧号码结果
 */
+ (void)postOldPhoneCheck:(NSString *)oldMobilePhone
                   Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

/**
 修改用户头像
 
 @param imageUrl 新的头像地址
 @param retBlock 修改结果回调
 */
+ (void)postUpdateUserHeadImg:(NSString *_Nonnull)imageUrl
                       Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

/**
 修改用户爱好
 
 @param hobbies 爱好--多个爱好使用英文逗号分隔
 @param retBlock 修改结果回调
 */
+ (void)postUpdateUserHobby:(NSString *_Nonnull)hobbies
                     Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

/**
 提交修改的用户信息(未测试)
 
 @param uid 用户id
 @param avatarUrl 头像地址
 @param nickName 昵称
 @param address 地址
 @param email 邮箱地址
 @param sex 性别，男1，女0
 @param personalSign 个性签名
 @param qq QQ号
 @param weiXin 微信
 @param hobbies 爱好
 @param retBlock 修改结果回调
 */
+ (void)postUpdateUserInfo:(NSInteger)uid
             WithAvatarUrl:(NSString *_Nullable)avatarUrl
              WithNickname:(NSString *_Nullable)nickName
               WithAddress:(NSString *_Nullable)address
                 WithEmail:(NSString *_Nullable)email
                   WithSex:(NSString *_Nullable)sex
          WithPersonalSign:(NSString *_Nullable)personalSign
                    WithQq:(NSString *_Nullable)qq
                WithWechat:(NSString *_Nullable)weiXin
               WithHobbies:(NSString *_Nullable)hobbies
                    Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

/**
 提交修改的用户信息(用户引导设置Step2)
 
 @param uid 用户id
 @param birthday 生日(时间戳)
 @param nickName 昵称
 @param sex 性别，男1，女0
 @param personalSign 个性签名
 @param retBlock 修改结果回调
 */
+ (void)postUpdateUserInfo:(NSInteger)uid
              WithNickname:(NSString *_Nullable)nickName
              WithBirthDay:(NSTimeInterval)birthday
                   WithSex:(NSString *_Nullable)sex
          WithPersonalSign:(NSString *_Nullable)personalSign
                    Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

#pragma mark - 粉丝关注相关

/**
 查询用户粉丝列表

 @param retBlock 查询结果回调
 */
+ (void)postQueryFansList:(void(^_Nonnull)(JAFansListModel * _Nullable model))retBlock;

/**
 查询用户粉丝列表(分页)

 @param currentPage 当前页面
 @param limit 每页条数
 @param targetUserId 查看目标用户的粉丝或者关注列表, 若为空则默认为当前登录用户
 @param retBlock 查询结果回调
 */
+ (void)postQueryFansListWithTargetUserId:(NSInteger)targetUserId
                        WithPage:(NSInteger)currentPage
                        WithLimit:(NSInteger)limit
                           Result:(void(^_Nonnull)(JAFansListModel * _Nullable model))retBlock;

/**
 查询用户关注列表

 @param retBlock 查询结果回调
 */
+ (void)postQueryAttenionsList:(void (^_Nonnull)(JAAttentionsListModel * _Nullable))retBlock;

/**
 查询用户关注列表(分页)

 @param targetUserId 查看目标用户的粉丝或者关注列表, 若为空则默认为当前登录用户
 @param currentPage 当前页面
 @param limit 每页条数
 @param retBlock 查询结果回调
 */
+ (void)postQueryAttenionListWithTargetUserId:(NSInteger)targetUserId
                            WithPage:(NSInteger)currentPage
                           WithLimit:(NSInteger)limit
                              Result:(void(^_Nonnull)(JAAttentionsListModel * _Nullable model))retBlock;

/**
 关注用户

 @param followedUid 被关注用户Id
 @param retBlock 关注结果回调
 */
+ (void)postAttentionUser:(NSInteger)followedUid
                   Result:(void (^_Nonnull)(JAAttentionUserModel * _Nullable model))retBlock;

/**
 取消关注

 @param followedUid 被关注用户Id
 @param retBlock 取消关注结果回调
 */
+ (void)postCancelAttentionUser:(NSInteger)followedUid
                         Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

/**
 用户反馈
 
 @param content 内容
 @param retBlock 用户反馈结果回调
 */
+ (void)postAddFeedBack:(NSString *)content
                 Result:(void (^)(JAResponseModel * _Nullable))retBlock;

//POST /userAccount/userInteraction/defriend

/**
 拉黑操作

 @param blackedUserId 被拉黑人ID
 @param retBlock 回执
 */
+ (void)postUserInteraction:(NSInteger)blackedUserId
                     Result:(void (^)(JAResponseModel * _Nullable))retBlock;

/**
 判断是否拉黑

 @param blackedUserId 被拉黑人Id
 @param retBlock 回执
 */
+ (void)postIsBlackList:(NSInteger)blackedUserId
                 Result:(void (^)(JAIsBlockModel * _Nullable))retBlock;

/**
 取消拉黑

 @param blackedUserId 被拉黑人Id
 @param retBlock 回执
 */
+ (void)postCancelDefriend:(NSInteger)blackedUserId
                    Result:(void (^)(JAResponseModel * _Nullable))retBlock;



@end
