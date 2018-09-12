//
//  SPBaseModel.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  模型基类

#import <Foundation/Foundation.h>

@interface SPBaseModel : NSObject <NSCoding>

/**
 快速获取model实例

 @return model实例
 */
+ (instancetype)model;

@end
