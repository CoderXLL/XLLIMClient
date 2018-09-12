//
//  GVUserDefaults+SPExtension.h
//  ProsperFinancial
//
//  Created by Soul on 2017/11/2.
//  Copyright © 2017年 Soul. All rights reserved.
//

#import <GVUserDefaults/GVUserDefaults.h>

@interface GVUserDefaults (SPExtension)

#pragma mark - 版本相关
@property (nonatomic,weak) NSString *kLastVersion;      //本地记录的版本号，用于展示引导页
@property (nonatomic,weak) NSString *kAppStoreVersion;  //商店记录的版本号，用于提示更新
@property (nonatomic,assign) NSInteger kAppUpdateTips;    //沙盒记录的提示更新次数，用于提示更新

#pragma mark - 登录相关
@property (nonatomic,weak) NSString *kLastLoginAuthKey; //登录成功之后缓存AuthKey
@property (nonatomic,weak) NSString *kLastLoginAccount; //登录成功之后缓存手机号
@property (nonatomic,weak) NSString *kLastLoginPwd;     //登录成功之后缓存密码

#pragma mark - 指纹相关
@property (nonatomic,assign) BOOL kTipsTouchID;         //是否已经提示过设置指纹，+kLastLoginAccount
@property (nonatomic,assign) BOOL kHaveSetTouchID;      //是否已经设置指纹，+kLastLoginAccount

@end
