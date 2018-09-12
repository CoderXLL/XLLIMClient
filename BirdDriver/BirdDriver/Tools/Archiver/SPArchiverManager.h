//
//  SPArchiverManager.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/29.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  归解档类

#import <Foundation/Foundation.h>

@interface SPArchiverManager : NSObject

/**
 单例初始化

 @return 单例对象
 */
+ (instancetype)sharedInstance;


/**
 归档

 @param object 要归档的object
 @param keyStr 标识
 */
- (BOOL)saveCacheObject:(id)object key:(NSString *)keyStr;

/**
 解档

 @param keyStr 标识
 @return object
 */
- (id)getCacheWithKey:(NSString *)keyStr;

/**
 移除所有本地操作

 @return 操作结果
 */
- (BOOL)removeAllCacheFile;

@end
