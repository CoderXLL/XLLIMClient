//
//  JARouterPresenter.m
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/28.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JARouterPresenter.h"

@implementation JARouterPresenter

+ (void)postQueryConfigResult:(void (^)(JAConfigModel *))retBlock{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [JAHTTPManager postRequest:kURL_common_appConfig
                    Parameters:@{
                                 @"type": @2,           //iOS写死为2
                                 @"version": version,
                                 @"targetId":JA_SERVER_VER?JA_SERVER_VER:@""
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAConfigModel *model = [JAConfigModel mj_objectWithKeyValues:data];
                           LogD(@"获取APP配置请求成功：%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"获取APP配置请求失败:%@",errModel);
                           JAConfigModel *model = [JAConfigModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)updateLocalH5{
    [JARouterPresenter postQueryConfigResult:^(JAConfigModel *model) {
        if (model.success) {
            NSString *urlStrs = model.appConfig.config;
            JAConfigUrlModel *urlModel = [JAConfigUrlModel mj_objectWithKeyValues:[urlStrs dataUsingEncoding:NSUTF8StringEncoding]];
            NSError *err = [NSError mj_error];
            if (err) {
                LogD(@"服务器H5配置转换json失败：%@",err);
                return ;
            }
            
            LogD(@"获取H5地址集合:%@",urlModel);
//            //            ----------------------------------------------------
//            //首页关于我们
//            if (!kStringIsEmpty(urlModel.AboutUs)) {
//                kAPI_h5_HomeAboutUs = model.AboutUs;
//            }
//            //首页安全保障
//            if (!kStringIsEmpty(urlModel.HomeSecurityUrl)) {
//                kAPI_h5_HomeSecurity = model.HomeSecurityUrl;
//            }
//            //首页新手福利
//            if (!kStringIsEmpty(urlModel.NewGift)) {
//                kAPI_h5_HomeNewerGift = model.NewGift;
//            }
//            //----------------------------------------------------
//            //项目介绍
//            if (!kStringIsEmpty(urlModel.ProjectInfo)) {
//                kAPI_h5_BidProjectIntro = model.ProjectInfo;
//            }
//            //项目安全保障
//            if (!kStringIsEmpty(urlModel.BidSecurityUrl)) {
//                kAPI_h5_BidProjectSafety = model.BidSecurityUrl;
//            }
//            //项目图片链接
//            if (!kStringIsEmpty(urlModel.ProjectImg)) {
//                kAPI_h5_BidProjectImg = model.ProjectImg;
//            }
//            //----------------------------------------------------
//            //邀请好友
//            if (!kStringIsEmpty(urlModel.InvitUrl)) {
//                kAPI_h5_HomeInvite = model.InvitUrl;
//            }
//            //----------------------------------------------------
//            //注册协议
//            if (!kStringIsEmpty(urlModel.Protocols)) {
//                kAPI_h5_Protocols = model.Protocols;
//            }
//            //合同页面
//            if (!kStringIsEmpty(urlModel.Contract)) {
//                kAPI_h5_Contract = model.Contract;
//            }
//            //            ----------------------------------------------------
        }else{
            LogE(@"通过后台配置H5链接失败，%@",model.responseStatus.message);
        }
    }];
}

@end
