//
//  SPLocalInfoModel.h
//  BirdDriver
//
//  Created by Soul on 2017/10/10.
//  Copyright © 2017年 Soul&Polo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JAUserAccount.h"

#define SPLocalInfo [SPLocalInfoModel shareInstance]

@interface SPLocalInfoModel : NSObject

//Boolean
@property (assign, nonatomic)   Boolean    hasBeenLogin;    //是否已经登录 控制我的页面遮罩层
@property (strong, nonatomic)   JAUserAccount *userModel;     //用户信息model

/**
 全局内存单例
 
 @return 获取单例
 */
+ (instancetype)shareInstance;

@end
