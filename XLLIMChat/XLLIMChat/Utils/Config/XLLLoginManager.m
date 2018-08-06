//
//  XLLLoginManager.m
//  XLLIMChat
//
//  Created by 肖乐 on 2018/7/20.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import "XLLLoginManager.h"

@implementation XLLLoginManager
static XLLLoginManager *instance_ = nil;

+ (instancetype)shareLoginManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[[self class] alloc] init];
    });
    return instance_;
}

//注册
- (void)registerWithUserName:(NSString *)userName password:(NSString *)password successBlock:(void(^)(void))successBlock
{
    EMError *error = [[EMClient sharedClient] registerWithUsername:userName password:password];
    if (error) {
        [self didShowFailedWithError:error];
    } else {
        
        [self loginWithUserName:userName password:password successBlock:successBlock];
    }
}

- (void)didShowFailedWithError:(EMError *)error
{
    switch (error.code)
    {
        case EMErrorServerNotReachable:
            [Public globalTipsVC:nil tips:@"连接服务器失败"];
            break;
        case EMErrorUserAlreadyExist:
            [Public globalTipsVC:nil tips:@"用户名已存在"];
            break;
        case EMErrorNetworkUnavailable:
            [Public globalTipsVC:nil tips:@"网络连接失败"];
            break;
        case EMErrorServerTimeout:
            [Public globalTipsVC:nil tips:@"连接超时"];
            break;
        default:
            [Public globalTipsVC:nil tips:@"无法注册"];
            break;
    }
}

//登录
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password successBlock:(void(^)(void))successBlock
{
    dispatch_async(dispatch_queue_create(XLLLoginQueue, DISPATCH_QUEUE_SERIAL), ^{
        
        EMError *error = [[EMClient sharedClient] loginWithUsername:userName password:password];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self didShowFailedWithError:error];
            });
        } else {
            
            //获取联系人
            //消息等
            dispatch_async(dispatch_get_main_queue(), ^{
                if (successBlock) {
                    successBlock();
                }
            });
        }
    });
}

@end
