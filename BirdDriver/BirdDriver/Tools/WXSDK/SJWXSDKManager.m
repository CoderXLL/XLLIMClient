//
//  SJWXSDKManager.m
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJWXSDKManager.h"
#import "JASharePresenter.h"
#import "JAUserPresenter.h"
 

@interface SJWXSDKManager ()

@property (nonatomic, copy) void(^wxCallBack)(NSString *);

@end

@implementation SJWXSDKManager
static SJWXSDKManager *instance_ = nil;

+ (instancetype)shareWXSDKManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[[self class] alloc] init];
    });
    return instance_;
}

- (void)WXAuthorizationRequestWithVC:(UIViewController *)vc WxCallBack:(void(^)(NSString *))WxCallBack;
{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"123";
    self.wxCallBack = WxCallBack;
    [WXApi sendAuthReq:req viewController:vc delegate:self];
}


#pragma mark - WXApiDelegate
-(void)onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)onResp:(BaseResp *)resp
{
    /*
     WXSuccess           = 0,   成功
     WXErrCodeCommon     = -1,   普通错误类型
     WXErrCodeUserCancel = -2,   用户点击取消并返回
     WXErrCodeSentFail   = -3,    发送失败
     WXErrCodeAuthDeny   = -4,   授权失败
     WXErrCodeUnsupport  = -5,    微信不支持
     */
    NSString * strMsg = [NSString stringWithFormat:@"errorCode: %d",resp.errCode];
    LogD(@"strMsg: %@",strMsg)
    NSString *errStr = [NSString stringWithFormat:@"errStr: %@", resp.errStr];
    LogD(@"errStr: %@",errStr);
    //判断是微信消息的回调
    if ([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        // 判断errCode 进行回调处理
        if (resp.errCode == 0)
        {
            //调分享成功接口
            NSString *shareType = [[NSUserDefaults standardUserDefaults] valueForKey:kSJSharePageKey];
            NSNumber *detailsIdNum = [[NSUserDefaults standardUserDefaults] valueForKey:kSJShareDetailsIdKey];
            if (kStringIsEmpty(shareType)) return;
            [JASharePresenter postShareActivity:shareType.integerValue detailsId:detailsIdNum.integerValue Result:^(JAResponseModel * _Nullable model) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (model.success) {
                        
                        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:kSJSharePageKey];
                        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kSJShareDetailsIdKey];
                        [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                    }
                });
            }];
        }
    } else if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]]) {
        
        //小程序传值获取
        WXLaunchMiniProgramResp *miniResp = (WXLaunchMiniProgramResp *)resp;
        if ([miniResp.extMsg isEqualToString:@"success"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_purchaseSuccess object:nil];
        } else if ([miniResp.extMsg isEqualToString:@"error"]) {
            
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        
        SendAuthResp * authResp = (SendAuthResp *)resp;
        switch (authResp.errCode) {
            case WXSuccess:
            {
                //微信授权成功
                LogD(@"授权成功")
                if (self.wxCallBack) {
                    self.wxCallBack(authResp.code);
                }
            }
                break;
                
            default:
                break;
        }
    }
}


@end
