//
//  JAResponseModel.m
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/21.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

@implementation JAResponseModel

- (NSString *)description{

    NSString *className = NSStringFromClass([self class]);
    className = [self class].self;
    
    NSString *code          = self.responseStatus.code?self.responseStatus.code:@"codeDefault";
    NSString *message       = self.responseStatus.message?self.responseStatus.message:@"messageDefault";
    NSString *success       = self.success?@"成功":@"失败";
//    NSString *exception     = self.exception?@"预期之中":@"意料之外";

    NSString * string = [NSString stringWithFormat:@"\n!!ResponseModel-\n ClassName = %@\n Code = %@\n Message = %@\n Success = %@\n",className,code,message,success];

    return string;
}

@end


@implementation JAResponseStatus

@end


