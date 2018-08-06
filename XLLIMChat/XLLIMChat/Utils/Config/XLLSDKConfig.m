//
//  XLLSDKConfig.m
//  XLLIMChat
//
//  Created by 肖乐 on 2018/4/16.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import "XLLSDKConfig.h"

#define APP_KEY @"b593771943#xllimchat"

@implementation XLLSDKConfig

+ (void)initializeSDK
{
    NSString *apnsCertName = nil;
#if DEVELOPMENT
    apnsCertName = @"chatdemoui_dev";
#else
    apnsCertName = @"chatdemoui";
#endif
    NSString *appKey = [XLLUserDefaults valueForKey:XLLIdentifyAppKey];
    if (IsEmptyValue(appKey))
    {
        appKey = APP_KEY;
        [XLLUserDefaults setValue:appKey forKey:XLLIdentifyAppKey];
    }
    EMOptions *options = [EMOptions optionsWithAppkey:appKey];
    options.apnsCertName = apnsCertName;
    options.isAutoLogin = YES;
    options.enableConsoleLog = YES;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
}

@end
