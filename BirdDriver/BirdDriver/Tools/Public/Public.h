//
//  Public.h
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/12.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  公共类

#import <Foundation/Foundation.h>

@interface Public : NSObject

/**
 显示加载框
 */
+ (void)showLoadingViewInVc:(UIViewController *)vc;

/**
 隐藏加载框
 */
+ (void)hideLoadingView;

@end
