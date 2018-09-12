//
//  SJDB.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/8/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJDB.h"

static sqlite3 *dbPoint = nil; // 只对数据库指针初始化一次

@implementation SJDB

+ (sqlite3 *)openDB
{
    if (dbPoint) {
        return dbPoint;
    }
    
    // 第一步: 把数据库文件从bundle存储到document文件夹中
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Message" ofType:@"rdb"];
    
    NSFileManager *fileManage = [[NSFileManager alloc] init];
    
    NSString *bondel = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    bondel = [NSString stringWithFormat:@"%@/%@", bondel, @"Message.rdb"];
    NSLog(@"%@", bondel);
    if (![fileManage fileExistsAtPath:bondel]) {
        [fileManage copyItemAtPath:path toPath:bondel error:nil];
    }
    else {
        NSLog(@"数据库文件在document文件夹已经存在");
    }
    
    // 第二步:获得数据库指针
    sqlite3_open([bondel UTF8String], &dbPoint); // 相当于我们向dbPoint赋值( 让dbpoint指向这个数据库)
    
    return dbPoint;
}

+ (void)closeDB
{
    sqlite3_close(dbPoint); // 关闭数据库
}

@end

