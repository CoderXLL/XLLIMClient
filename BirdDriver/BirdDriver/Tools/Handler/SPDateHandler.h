//
//  SPDateHandler.h
//  BirdDriver
//
//  Created by polo on 2017/7/18.
//  Copyright © 2017年 uyufax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPDateHandler : NSObject

/**
 * 时间戳 转 时间
 *
 @param timeStamp 时间戳
 @return 时间
 *
 */
+ (NSDate *) getDateFromTimestamp:(long)timeStamp;


/**
 * 时间 转 时间戳
 *
 @param date 时间
 @return 时间戳
 *
 */
+ (NSString *) getTimestampFromDate:(NSDate *)date;


/**
 * 时间 转 时间字符串
 *
 @param date 时间
 @return 时间字符串
 *
 */
+ (NSString *) getTimeStringFromDate:(NSDate *)date;



/**
 时间戳转当前时间

 @param timeStamp 时间戳
 @return 时间字符串 YYYY.MM.dd
 */
+ (NSString *)getTimeStringFromTimestamp:(long)timeStamp;


/**
 时间戳转时间字符串

 @param timeStamp 时间戳
 @return YYYY-MM-dd HH:MM:ss
 */
+ (NSString *)getTimeLongStringFromTimestamp:(long)timeStamp;

#pragma mark -- 时间戳 转 时间字符串 月.日 时:分
+ (NSString *) getTimeStringFromTime:(long)timeStamp;

@end
