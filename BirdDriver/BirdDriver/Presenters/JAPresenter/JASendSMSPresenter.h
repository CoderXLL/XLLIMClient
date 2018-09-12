//
//  JASendSMSPresenter.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/24.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAPresenter.h"

typedef NS_ENUM(NSInteger, JASmsCodeType) {
    SmsCodeTypeRegister     = 0,    // 注册请求验证码（未启用）
    SmsCodeTypeLogin        = 1,    // 登录请求验证码（已启用）
    SmsCodeTypeForgetPwd    = 2,    // 更改绑定手机号码（已启用）
};

@interface JASendSMSPresenter : JAPresenter


+ (void)postSendSMS:(NSString *)mobilePhone
    WithSmsCodeType:(JASmsCodeType)smsCodeType
          WithToken:(NSString *)token
           WithCode:(NSString *)code
             Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;
@end
