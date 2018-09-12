//
//  SJWXSDKManager.h
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WechatOpenSDK/WXApi.h>

@class JAWXLoginInfoModel;
@interface SJWXSDKManager : NSObject <WXApiDelegate>

/**
 微信SDK相关

 @return 实例
 */
+ (instancetype)shareWXSDKManager;

/**
 微信授权

 @param vc vc
 @param WxCallBack 授权回调
 */
- (void)WXAuthorizationRequestWithVC:(UIViewController *)vc WxCallBack:(void(^)(NSString *))WxCallBack;

@end
