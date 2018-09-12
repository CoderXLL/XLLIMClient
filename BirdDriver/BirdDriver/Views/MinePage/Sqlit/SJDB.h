//
//  SJDB.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/8/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SJDB : NSObject

+ (sqlite3 *)openDB;
+ (void)closeDB;


@end
