//
//  Public.m
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/12.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "Public.h"
#import "AppDelegate.h"
#import "SJLoadingController.h"

@implementation Public

/** 显示加载框 */
+ (void)showLoadingViewInVc:(UIViewController *)vc
{
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    SJLoadingController *loadVC = app.loadingController;
    if (loadVC.showing == NO)
    {
//        UIWindow* rootWindow = app.window;
        loadVC.view.frame = vc.view.bounds;
        [vc.view addSubview:loadVC.view];
        loadVC.showing = YES;
    }
}

/** 隐藏加载框 */
+ (void)hideLoadingView
{
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    SJLoadingController *loadVC = app.loadingController;
    if (loadVC.showing)
    {
        [loadVC.view removeFromSuperview];
        loadVC.showing = NO;
    }
}

@end
