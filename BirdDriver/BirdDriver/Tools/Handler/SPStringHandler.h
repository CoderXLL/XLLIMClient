//
//  SPStringHandler.h
//  YTJF
//
//  Created by polo on 2017/6/13.
//  Copyright © 2017年 polo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface SPStringHandler : NSObject

/**
 email是否有效
 
 @param email 邮箱账号
 @return 是否符合规则
 */
+ (BOOL) isAvailableEmail:(NSString *)email;


/**
 手机号是否有效
 
 @param phonenum 手机号
 @return 是否符合规则
 */
+ (BOOL) isAvailablePhoneNum:(NSString *)phonenum;


/**
 金额是否有效
 
 @param money 金额
 @return 是否符合规则
 */
+ (BOOL) isAvailableMoney:(NSString *)money;

/**
 
 
 @param cardid 身份证
 @return 是否符合规则
 */
+ (BOOL) isAvailableCardId:(NSString *)cardid;


/**
 是否是数字
 
 @param number 数字
 @return 是否符合规则
 */
+ (BOOL) isAvailableNumber:(NSString *)number;


/**
 账号是否有效
 
 @param account 账号
 @return 是否符合规则
 */
+ (BOOL) isAvailableUserAccount:(NSString *)account;


/**
 姓名是否有效
 
 @param name 姓名
 @return 是否符合规则
 */
+ (BOOL) isAvailableRealName:(NSString *)name;


/**
 密码是否有效
 
 @param password 密码
 @return 是否符合规则
 */
+ (BOOL) isAvailablePassword:(NSString *)password;


/**
 交易密码是否有效
 
 @param password 交易密码
 @return 是否符合规则
 */
+ (BOOL) isAvailablePayPassword:(NSString *)password;


/**
 验证码是否有效
 
 @param code 验证码
 @return 是否符合规则
 */
+ (BOOL) isAvailableVerificationCode:(NSString *)code;


/**
 银行卡正则
 
 @param code 银行卡号
 @return 是否符合正则
 */
+ (BOOL) isAvailableBankCard:(NSString *)code;


/**
 DES加密
 
 @param str 待加密字符串
 @return 加密后字符串
 */
+ (NSString *)encryptStr:(NSString *)str;


/**
 DES解密
 
 @param str 待解密字符串
 @return 解密后字符串
 */
+ (NSString *)decryptStr:(NSString *)str;


/**
 字符串大小
 
 @param string 字符串
 @param size 字符串字体大小
 @return 字符串大小
 */
+ (CGSize)calculateRowSize:(NSString *)string FontSize:(float)size;

/**
 替换手机号为 xxx****xxxx
 
 @param phoneNum 手机号
 @return 替换后手机号
 */
+ (NSString *)replacingPhoneNumCharacters:(NSString *)phoneNum;


/**
 替换姓名号为 x**
 
 @param userName 姓名字符串
 @return 替换后的姓名字符串
 */
+ (NSString *)replacingUserNameCharacters:(NSString *)userName;



/**
 替换银行卡号为 xxx**********xxxx 前四后四
 
 @param cardCode 卡号
 @return 替换后的卡号
 */
+ (NSString *)replacingBankCardCodeCharacters:(NSString *)cardCode;


+(NSString *)base64DecodeString:(NSString *)string;

+(NSString *)base64EncodeString:(NSString *)string;

/**
 比较两个版本号的大小
 
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2;
@end
