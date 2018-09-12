//
//  JAUserAccount.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/28.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

typedef NS_ENUM(NSInteger, JAUserType) {
    JAUserTypeNormal        = 0,    // 0，正常用户
    JAUserTypeRecommand     = 1,    // 1，推荐用户
};


typedef NS_ENUM(NSInteger, JAAttentionType) {
    AttentionTypeNotConcern         = 0,    // 未关注
    AttentionTypeConcern            = 1,    // 已关注
    AttentionTypeEachOtherConcern   = 2,    // 互相关注
};


@interface JAUserAccount : JAResponseModel

/**
 渠道id、默认1000（本平台）
 */
@property (nonatomic, copy) NSString *channelId;

/**
 创建组数
 */
@property (nonatomic, assign) NSInteger activityNum;
/**
 帖子数
 */
@property (nonatomic, assign) NSInteger postsNum;


/**
 粉丝数量
 */
@property (nonatomic, assign) NSInteger fansNumber;
/**
 粉丝数量
 */
@property (nonatomic, assign) NSInteger fansNum;

/**
 关注数量
 */
@property (nonatomic, assign) NSInteger attentionNumber;
/**
 关注数量
 */
@property (nonatomic, assign) NSInteger attentionNum;

/**
 是否关注,0：未关注、1：已关注、2：互相关注
 */
@property (nonatomic, assign) NSInteger attentionType;

/**
 昵称
 */
@property (nonatomic, copy) NSString *nickName;

/**
 是否删除
 */
@property (nonatomic, assign) BOOL isDeleted;

/**
 爱好，以英文逗号分隔
 */
@property (nonatomic, copy) NSString *hobbies;

/**
 身份证号码
 */
@property (nonatomic, copy) NSString *identityCard;

/**
 性别，0是女，1是男
 */
@property (nonatomic, copy) NSString *sex;

/**
 真实姓名
 */
@property (nonatomic, copy) NSString *realName;

/**
 个性签名
 */
@property (nonatomic, copy) NSString *personalSign;

/**
 头像地址链接
 */
@property (nonatomic, copy) NSString *avatarUrl;

/**
 头像地址链接
 */
@property (nonatomic, copy) NSString *imageAddress;


/**
 手机号
 */
@property (nonatomic, copy) NSString *mobilePhone;

/**
 是否已经实名认证
 */
@property (nonatomic, assign) BOOL isIdentityVerified;

/**
 最后更新时间
 */
@property (nonatomic, assign) long long lastUpdateTime;

/**
 微信号码
 */
@property (nonatomic, copy) NSString *weiXin;

/**
 用户ID
 */
@property (nonatomic, assign) NSInteger Id;

/**
 用户ID
 */
@property (nonatomic, assign) NSInteger uid;

/**
 用户类型
 */
@property (nonatomic, assign) JAUserType useType;

/**
 电子邮箱地址
 */
@property (nonatomic, copy) NSString *email;

/**
 推荐人手机号码
 */
@property (nonatomic, copy) NSString *relatedMobilePhone;

/**
 是否已经手机验证
 */
@property (nonatomic, assign) BOOL isPhoneVerified;

/**
 是否已绑定微信
 */
@property (nonatomic, assign) BOOL whetherToBindWeiXin;

/**
 创建时间，等同注册时间
 */
@property (nonatomic, assign) long long createTime;

/**
 QQ号码
 */
@property (nonatomic, copy) NSString *qq;

/**
 备注说明
 */
@property (nonatomic, copy) NSString *remark;

/**
 地址
 */
@property (nonatomic, copy) NSString *address;

/**
 鸟蛋总数量
 */
@property (nonatomic, assign) NSInteger totalEggs;

/**
 是否关注 (他人页面)
 */
@property (nonatomic, assign) BOOL attentioned;

//显示的nickName
- (NSString *)getShowNickName;

@end
