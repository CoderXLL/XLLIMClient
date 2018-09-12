//
//  SPArchiverManager.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/29.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPArchiverManager.h"

@implementation SPArchiverManager
static SPArchiverManager *instance_ = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[[self class] alloc] init];
    });
    return instance_;
}

//获取归档路径
- (NSString *)getCachePathWithKeyStr:(NSString *)keyStr
{
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *Userdirectory = [NSString stringWithFormat:@"%@/SJUser", pathDocuments];
    if (![[NSFileManager defaultManager] fileExistsAtPath:Userdirectory])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:Userdirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 缓存文件
    NSString *filePath = [Userdirectory stringByAppendingPathComponent:keyStr];
    if (![[NSFileManager defaultManager] fileExistsAtPath:keyStr])
    {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil  attributes:nil];
    }
    // 检查文件权限
    NSDictionary *attribute = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    if ([[attribute objectForKey:NSFileProtectionKey] isEqualToString:NSFileProtectionComplete])
    {
        NSDictionary *newAttr = [NSDictionary dictionaryWithObject:NSFileProtectionCompleteUntilFirstUserAuthentication forKey:NSFileProtectionKey];
        [[NSFileManager defaultManager] setAttributes:newAttr ofItemAtPath:filePath error:nil];
    }
    return filePath;
}

//归档
- (BOOL)saveCacheObject:(id)object key:(NSString *)keyStr
{
    BOOL isSuccess = [NSKeyedArchiver archiveRootObject:object toFile:[self getCachePathWithKeyStr:keyStr]];
    LogD(@"%@", isSuccess?@"成功成功":@"归档失败")
    return isSuccess;
}

//解档
- (id)getCacheWithKey:(NSString *)keyStr
{
    id object = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getCachePathWithKeyStr:keyStr]];
    return object;
}

//移除所有缓存文件
- (BOOL)removeAllCacheFile
{
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSUserDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *Userdirectory = [NSString stringWithFormat:@"%@/SJUser", pathDocuments];
    BOOL isSuccess = [[NSFileManager defaultManager] removeItemAtPath:Userdirectory error:nil];
    LogD(@"%@", isSuccess?@"移除成功":@"移除失败")
    return isSuccess;
}

@end
