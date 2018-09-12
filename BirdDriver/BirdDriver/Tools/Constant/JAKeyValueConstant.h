//
//  JAKeyValueConstant.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/21.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#ifndef JAKeyValueConstant_h
#define JAKeyValueConstant_h

#import <Foundation/Foundation.h>

#pragma mark - Request Json Key
#pragma mark 公共参数
static NSString * const kHttp_Request_deviceId      = @"deviceId";      // 设备编号 IDFA
static NSString * const kHttp_Request_deviceType    = @"deviceType";    // 设备类型 Android 1|iOS 2
static NSString * const kHttp_Request_deviceName    = @"deviceName";    // 设备名称 iPhone10.2(iOS9)
static NSString * const kHttp_Request_appVersion    = @"appVersion";    // 版本信息 APP shortVersion

#endif /* JAKeyValueConstant_h */
