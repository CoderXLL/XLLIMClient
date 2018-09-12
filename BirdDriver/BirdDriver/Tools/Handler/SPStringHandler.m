//
//  SPStringHandler.m
//  YTJF
//
//  Created by polo on 2017/6/13.
//  Copyright © 2017年 polo. All rights reserved.
//

#import "SPStringHandler.h"

#define kYTDesKey @"1qaz@WSX"
@implementation SPStringHandler

+ (BOOL) isAvailableEmail:(NSString *)email {
    
    NSString *regex = @"\\w+@\\w+\\.[a-z]+(\\.[a-z]+)?";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:email];
    return isValid;
}

+ (BOOL) isAvailablePhoneNum:(NSString *)phonenum {
    
    NSString *regex = @"(\\+\\d+)?1[34578]\\d{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:phonenum];
    return isValid;
}


+ (BOOL) isAvailableMoney:(NSString *)money {
    
    NSString *regex = @"([1-9]\\d{0,9}|0)([.]?|(\\.\\d{1,2})?)$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:money];
    return isValid;
}


+ (BOOL) isAvailableCardId:(NSString *)cardid {
    
    NSString *regex = @"[1-9]\\d{13,16}[a-zA-Z0-9]{1}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:cardid];
    return isValid;
}

+ (BOOL) isAvailableNumber:(NSString *)number {
    
    NSString *regex = @"^[0-9]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:number];
    return isValid;
}

+ (BOOL) isAvailableUserAccount:(NSString *)account {
    
    NSString *regex = @"^[\\u4E00-\\u9FA5]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:account];
    return isValid;
}

+ (BOOL) isAvailableRealName:(NSString *)name {
    
    if (name.length >= 2) {
        return YES;
    }
    return NO;
}


+ (BOOL) isAvailablePassword:(NSString *)password {
    
    if (password.length >= 4 && password.length <= 15) {
        return YES;
    }
    return NO;
}

+ (BOOL) isAvailablePayPassword:(NSString *)password {
    
    if ([self isAvailableNumber:password] && password.length == 6) {
        return YES;
    }
    return NO;
}

+ (BOOL) isAvailableVerificationCode:(NSString *) code {
    
    if ([self isAvailableNumber:code] && code.length == 4) {
        return YES;
    }
    return NO;
}

+ (BOOL) isAvailableBankCard:(NSString *) code {
    
    if ([self isAvailableNumber:code] && code.length <= 19) {
        return YES;
    }
    return NO;
}

+ (NSString *) encryptStr:(NSString *) str {
    return [self doCipher:str key:kYTDesKey context:kCCEncrypt];
}

+ (NSString *) decryptStr:(NSString *) str {
    return [self doCipher:str key:kYTDesKey context:kCCDecrypt];
}

+ (NSString *)doCipher:(NSString *)sTextIn key:(NSString *)sKey context:(CCOperation)encryptOrDecrypt {
    NSStringEncoding EnC = NSUTF8StringEncoding;
    
    NSMutableData * dTextIn;
    if (encryptOrDecrypt == kCCDecrypt) {
        //        dTextIn = [[sTextIn dataUsingEncoding:EnC] mutableCopy];
        dTextIn = [[self stringToHexData:sTextIn] mutableCopy];
    }
    else{
        dTextIn = [[sTextIn dataUsingEncoding: EnC] mutableCopy];
    }
    NSMutableData * dKey = [[sKey dataUsingEncoding:EnC] mutableCopy];
    [dKey setLength:kCCBlockSizeDES];
    uint8_t *bufferPtr1 = NULL;
    size_t bufferPtrSize1 = 0;
    size_t movedBytes1 = 0;
    //uint8_t iv[kCCBlockSizeDES];
    //memset((void *) iv, 0x0, (size_t) sizeof(iv));
    Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    bufferPtrSize1 = ([sTextIn length] + kCCKeySizeDES) & ~(kCCKeySizeDES -1);
    bufferPtr1 = malloc(bufferPtrSize1 * sizeof(uint8_t));
    memset((void *)bufferPtr1, 0x00, bufferPtrSize1);
    CCCrypt(encryptOrDecrypt, // CCOperation op
            kCCAlgorithmDES, // CCAlgorithm alg
            kCCOptionPKCS7Padding, // CCOptions options
            [dKey bytes], // const void *key
            [dKey length], // size_t keyLength
            iv, // const void *iv
            [dTextIn bytes], // const void *dataIn
            [dTextIn length],  // size_t dataInLength
            (void *)bufferPtr1, // void *dataOut
            bufferPtrSize1,     // size_t dataOutAvailable
            &movedBytes1);      // size_t *dataOutMoved
    
    NSString * sResult;
    if (encryptOrDecrypt == kCCDecrypt){
        
        NSData *dResult = [NSData dataWithBytes:bufferPtr1 length:movedBytes1];
        sResult = [[ NSString alloc] initWithData:dResult encoding:EnC];
    }
    else {
        NSData *dResult = [NSData dataWithBytes:bufferPtr1 length:movedBytes1];
        sResult = [self hexStringFromData:dResult];
    }
    return sResult;
}

//16进制转data
+ (NSData *) stringToHexData:(NSString *)myStr
{
    int len = (int)([myStr length] / 2);    // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [myStr length] / 2; i++) {
        byte_chars[0] = [myStr characterAtIndex:i*2];
        byte_chars[1] = [myStr characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    NSData *data = [NSData dataWithBytes:buf length:len];
    free( buf );
    return data;
}

//data转16进制
+ (NSString *)hexStringFromData:(NSData *)myD {
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}


+ (CGSize)calculateRowSize:(NSString *)string FontSize:(float)size {
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 30)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size;
}

//替换手机号为 xxx****xxxx 前三后四
+ (NSString *)replacingPhoneNumCharacters:(NSString *)phoneNum {
    NSString *string = [phoneNum stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"];
    return string;
}

//替换姓名号为 x** 前一
+ (NSString *)replacingUserNameCharacters:(NSString *)userName {
    NSString *string = userName;
    for (int i = 0; i < userName.length - 1; i++) {
        string = [string stringByReplacingCharactersInRange:NSMakeRange(1 + i,1) withString:@"*"];
    }
    return string;
}

//替换银行卡号为 xxx**********xxxx 前三后四
+ (NSString *)replacingBankCardCodeCharacters:(NSString *)cardCode {
    NSInteger starLength = cardCode.length - 4 -4;
    NSString *star = @"";
    for (int i = 0; i < starLength; i++) {
        star = [star stringByAppendingString:@"*"];
    }
    NSString *string = [cardCode stringByReplacingCharactersInRange:NSMakeRange(4,starLength) withString:star];
    return string;
}


//对一个字符串进行base64编码,并且返回
+(NSString *)base64EncodeString:(NSString *)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

//对base64编码之后的字符串解码,并且返回
+(NSString *)base64DecodeString:(NSString *)string{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}


+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }
    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }
    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }
    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    // 取字段最少的，进行循环比较
    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
    for (int i = 0; i < smallCount; i++) {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }
        // 版本相等，继续循环。
    }
    // 版本可比较字段相等，则字段多的版本高于字段少的版本。
    if (v1Array.count > v2Array.count) {
        return 1;
    } else if (v1Array.count < v2Array.count) {
        return -1;
    } else {
        return 0;
    }
    return 0;
}

@end
