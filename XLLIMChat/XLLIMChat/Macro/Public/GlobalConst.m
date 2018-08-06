//
//  GlobalConst.m
//  XLLIMChat
//
//  Created by 肖乐 on 2018/4/4.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import "GlobalConst.h"

#if DEVELOPMENT

NSString *const kNetWorkServiceAddress = @"https://xiaolele/api";

#else

NSString *const kNetWorkServiceAddress = @"https://t-xiaolele/api";

#endif

/** appKey存储关键字 */
NSString *const XLLIdentifyAppKey = @"XLLIdentifyAppKey";
/** 登录任务队列标识 */
char *const XLLLoginQueue = "XLLLoginQueue";

@implementation GlobalConst

@end
