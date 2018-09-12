//
//  JASendSMSPresenter.m
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/24.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JASendSMSPresenter.h"

@implementation JASendSMSPresenter

+ (void)postSendSMS:(NSString *)mobilePhone
    WithSmsCodeType:(JASmsCodeType)smsCodeType
          WithToken:(NSString *)token
           WithCode:(NSString *)code
             Result:(void (^)(JAResponseModel * _Nullable))retBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"mobilePhone":mobilePhone,
                                                                                @"smsCodeType":@(smsCodeType)                        }];
    if (!kStringIsEmpty(token)) {
        [dict setValue:token forKey:@"token"];
    }
    if (!kStringIsEmpty(code)) {
        [dict setValue:code forKey:@"code"];
    }
    [JAHTTPManager postRequest:kURL_sms_sendCode
                    Parameters:dict
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"短信验证码请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"短信验证码请求失败:%@",errModel);
                           JAResponseModel *model = [JAResponseModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

@end
