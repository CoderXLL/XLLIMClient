//
//  SJLoadingController.h
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/12.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPViewController.h"

@interface SJLoadingController : SPViewController


/**
 生成加载实例

 @return 加载控制器实例
 */
+ (instancetype)shareLoadingController;

/**
 是否正在显示
 @discussion   YES: 正在显示 NO :   未显示
 */
@property (nonatomic, assign) BOOL showing;

@end
