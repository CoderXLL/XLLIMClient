//
//  SPDateHandler.m
//  BirdDriver
//
//  Created by polo on 2017/7/18.
//  Copyright © 2017年 uyufax. All rights reserved.
//

#import "SPDateHandler.h"

@implementation SPDateHandler

#pragma mark --时间戳 转 时间
+ (NSDate *) getDateFromTimestamp:(long)timeStamp {
    
    NSString *timeStampString = [NSString stringWithFormat:@"%ld",timeStamp];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    return [formatter dateFromString:timeStampString];
}

#pragma mark --时间 转 时间戳
+ (NSString *) getTimestampFromDate:(NSDate *)date {
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}

#pragma mark --时间 转 时间字符串
+ (NSString *) getTimeStringFromDate:(NSDate *)date {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}

#pragma mark -- 时间戳 转 时间字符串 年.月.日
+ (NSString *) getTimeStringFromTimestamp:(long)timeStamp {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    //[formatter setTimeZone:[NSTimeZone systemTimeZone]];
    //[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//指定时区-东8区
    //IOS 时间戳为10位数，服务器端为13位数(精确到了毫秒)
    NSTimeInterval interval    = timeStamp/1000.0f;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

#pragma mark -- 时间戳 转 时间字符串 年-月-日 时:分:秒
+ (NSString *)getTimeLongStringFromTimestamp:(long)timeStamp {
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    = timeStamp / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}

#pragma mark -- 时间戳 转 时间字符串 月.日 时:分
+ (NSString *) getTimeStringFromTime:(long)timeStamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM.dd HH:MM"];
    //IOS 时间戳为10位数，服务器端为13位数(精确到了毫秒)
    NSTimeInterval interval    = timeStamp/1000.0f;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}


@end
