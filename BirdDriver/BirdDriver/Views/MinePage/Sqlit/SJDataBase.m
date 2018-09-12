//
//  SJDataBase.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/8/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJDataBase.h"
#import "SJDB.h"
@implementation SJDataBase

+ (void)insertWithModel:(JASystemModel *)model
{
    NSString *isDeleteString = model.isDeleted?@"YES":@"NO";
    NSString *isReadString = model.isRead?@"YES":@"NO";
    // 第一步:编写Sql语句
    NSString *sql = [NSString stringWithFormat:@"insert into messages values('%ld', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%ld', '%@')",  model.ID, model.createTime, model.h5Link, model.imagesAddress, isDeleteString, isReadString,  model.lastUpdateTime, model.messageContent, model.messageTitle, (long)model.messageType, model.messageValidTime];
//     第二步:获得数据库指针
    sqlite3 *getConnection = [SJDB openDB];
    // 第三步:执行Sql语句
    int result = sqlite3_exec(getConnection, [sql UTF8String], nil, nil, nil); // 返回一个整形 看看是否执行成功 (往某个数据库执行sql字符串语句
    if (result == SQLITE_OK) {
        NSLog(@"执行成功");
    }
    else {
        NSLog(@"执行失败");
        [SJDB closeDB]; 
    }
    
    
}

+ (void)deleteWithTable:(NSInteger)messageId
{
    NSString *sql = [NSString stringWithFormat:@"delete from messages where messageID = %ld", messageId];
    sqlite3 *get = [SJDB openDB];

    int result = sqlite3_exec(get, [sql UTF8String], nil, nil, nil);
    if (result == SQLITE_OK) {
        NSLog(@"执行成功");
    }else
    {
        NSLog(@"执行失败");
        [SJDB closeDB];
    }
}

+ (void)updateWithModel:(JASystemModel *)model messageId:(NSInteger)messageId
{
    NSString *sql = @"update messages set ";
    
    NSString *isReadString = model.isRead?@"YES":@"NO";
    if (isReadString != nil) {
        sql = [NSString stringWithFormat:@"%@ isRead = '%@' ", sql, isReadString];
    }

    sql = [NSString stringWithFormat:@"%@ where messageID = %ld", sql, messageId];

    sqlite3 *get = [SJDB openDB];
    int result = sqlite3_exec(get, [sql UTF8String], nil, nil, nil);
    NSLog(@"%d", result);
    if (result == SQLITE_OK) {
        NSLog(@"执行成功");
    } else {
        NSLog(@"执行失败");
        [SJDB closeDB];
//        [SJDataBase updateWithModel:model messageId:messageId];
    }
}


+ (NSArray *)searchSystemMessage
{

    NSString *str = [NSString stringWithFormat:@"select messageID, createTime, h5Link,imagesAddress,isDeleted,isRead,lastUpdateTime,messageContent,messageTitle,messageType,messageValidTime  from messages"];
    sqlite3 *get = [SJDB openDB];
    // 定义数据库查询结果
    sqlite3_stmt *stmt;
    // 执行sql语句,并把查询到得结果赋值到stmt中
    int result = sqlite3_prepare_v2(get, [str UTF8String], -1, &stmt, nil);// 第三个参数是sql语句的长度, -1代表无限制长, 第四个参数是放到什么地方
    NSMutableArray *array = [NSMutableArray array];
    if (result == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) { // 一行一行查找, 是否有下一行(执行一遍查询一行)
            int messageId = sqlite3_column_int(stmt, 0); // 取第0个列, 也就是第一列
            const unsigned char *createTimeString = sqlite3_column_text(stmt, 1);
            const unsigned char *h5LinkString = sqlite3_column_text(stmt, 2);
            const unsigned char *imagesAddressString = sqlite3_column_text(stmt, 3);
            const unsigned char *isDeletedString = sqlite3_column_text(stmt, 4);
            const unsigned char *isReadString = sqlite3_column_text(stmt, 5);
            const unsigned char *lastUpdateTimeString = sqlite3_column_text(stmt, 6);
            const unsigned char *messageContentString = sqlite3_column_text(stmt, 7);
            const unsigned char *messageTitleString = sqlite3_column_text(stmt, 8);
            int messageType = sqlite3_column_int(stmt, 9);
            const unsigned char *messageValidTimeString = sqlite3_column_text(stmt, 10);
            
            NSString *createTime = [NSString stringWithUTF8String:(const char *)createTimeString]; // 将const unsigned char 类型的转换成字符串
            NSString *h5Link = [NSString stringWithUTF8String:(const char *)h5LinkString]; // 将const unsigned char 类型的转换成字符串
            NSString *imagesAddress = [NSString stringWithUTF8String:(const char *)imagesAddressString];
            NSString *isDeleted = [NSString stringWithUTF8String:(const char *)isDeletedString];
            NSString *isRead = [NSString stringWithUTF8String:(const char *)isReadString];
            NSString *lastUpdateTime = [NSString stringWithUTF8String:(const char *)lastUpdateTimeString];
            NSString *messageContent = [NSString stringWithUTF8String:(const char *)messageContentString];
            NSString *messageTitle = [NSString stringWithUTF8String:(const char *)messageTitleString];
            NSString *messageValidTime = [NSString stringWithUTF8String:(const char *)messageValidTimeString];


            JASystemModel *model = [[JASystemModel alloc] initWithMessageId:messageId createTime:createTime h5Link:h5Link imagesAddress:imagesAddress isDeleted:isDeleted isRead:isRead lastUpdateTime:lastUpdateTime messageContent:messageContent messageTitle:messageTitle messageType:messageType messageValidTime:messageValidTime];
            [array insertObject:model atIndex:0];
        }
    }

    sqlite3_finalize(stmt); // 将stmt释放掉
//    [SJDB closeDB];

    return array;
}


+ (JASystemModel *)searchWithId:(NSInteger)searchMessageId
{

    NSString *str = [NSString stringWithFormat:@"select * from messages where messageID = %ld", searchMessageId];
    sqlite3 *get = [SJDB openDB];

    // 定义数据库查询结果
    sqlite3_stmt *stmt;

    // 执行sql语句,并把查询到得结果赋值到stmt中
    int result = sqlite3_prepare_v2(get, [str UTF8String], -1, &stmt, nil);// 第三个参数是sql语句的长度, -1代表无限制长, 第四个参数是放到什么地方

    if (result == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) { // 一行一行查找, 是否有下一行(执行一遍查询一行)
            int messageId = sqlite3_column_int(stmt, 0); // 取第0个列, 也就是第一列
            const unsigned char *createTimeString = sqlite3_column_text(stmt, 1);
            const unsigned char *h5LinkString = sqlite3_column_text(stmt, 2);
            const unsigned char *imagesAddressString = sqlite3_column_text(stmt, 3);
            const unsigned char *isDeletedString = sqlite3_column_text(stmt, 4);
            const unsigned char *isReadString = sqlite3_column_text(stmt, 5);
            const unsigned char *lastUpdateTimeString = sqlite3_column_text(stmt, 6);
            const unsigned char *messageContentString = sqlite3_column_text(stmt, 7);
            const unsigned char *messageTitleString = sqlite3_column_text(stmt, 8);
            int messageType = sqlite3_column_int(stmt, 9);
            const unsigned char *messageValidTimeString = sqlite3_column_text(stmt, 10);
            
            NSString *createTime = [NSString stringWithUTF8String:(const char *)createTimeString]; // 将const unsigned char 类型的转换成字符串
            NSString *h5Link = [NSString stringWithUTF8String:(const char *)h5LinkString]; // 将const unsigned char 类型的转换成字符串
            NSString *imagesAddress = [NSString stringWithUTF8String:(const char *)imagesAddressString];
            NSString *isDeleted = [NSString stringWithUTF8String:(const char *)isDeletedString];
            NSString *isRead = [NSString stringWithUTF8String:(const char *)isReadString];
            NSString *lastUpdateTime = [NSString stringWithUTF8String:(const char *)lastUpdateTimeString];
            NSString *messageContent = [NSString stringWithUTF8String:(const char *)messageContentString];
            NSString *messageTitle = [NSString stringWithUTF8String:(const char *)messageTitleString];
            NSString *messageValidTime = [NSString stringWithUTF8String:(const char *)messageValidTimeString];
            
            
            JASystemModel *model = [[JASystemModel alloc] initWithMessageId:messageId createTime:createTime h5Link:h5Link imagesAddress:imagesAddress isDeleted:isDeleted isRead:isRead lastUpdateTime:lastUpdateTime messageContent:messageContent messageTitle:messageTitle messageType:messageType messageValidTime:messageValidTime];

            sqlite3_finalize(stmt); // 将stmt释放掉

            return model;
        }
    }

    sqlite3_finalize(stmt); // 将stmt释放掉
    
//    [SJDB closeDB];

    return nil;
}

+(NSInteger)getNotReadNum{
    NSArray *array = [SJDataBase searchSystemMessage];
    NSInteger number = 0;
    for (JASystemModel *model in array) {
        if (model.isRead == NO) {
            number += 1;
        }
    }
    return number;
}

+(void)readAllMessage{
    NSArray *array = [SJDataBase searchSystemMessage];
    for (JASystemModel *model in array) {
        if (model.isRead == NO) {
            model.isRead = YES;
            [SJDataBase updateWithModel:model messageId:model.ID];
        }
    }
}

@end
