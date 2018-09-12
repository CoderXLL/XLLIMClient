//
//  SPShowHandler.h
//  BirdDriver
//
//  Created by Soul on 2017/9/30.
//  Copyright © 2017年 Soul&Polo. All rights reserved.
//
//  由于项目需求对展示的金额和利率展示形式不同，封装工具类

#import <Foundation/Foundation.h>

@interface SPShowHandler : NSObject

/**
 将分为单位的int转化为元为单位的123,456,78.90NSString
 
 @param fen 分为单位的NSInteger
 @return 元
 */
+ (NSString *)fen2Yuan:(NSInteger)fen;

//返回给后台User-Agent，
//e.g. Dot -> iPhone 9.2
//e.g. Device -> iPhone 7 Plus
+ (NSString *)dotDeviceName;
+ (NSString *)currentDeviceName;

//格式化输出银行卡（加空格）
+ (NSString *)formatCardNumber:(NSString *)cardNum;
+ (NSString *)encryptCardNumber:(NSString *)cardNum;

@end

