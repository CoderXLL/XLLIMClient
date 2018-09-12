//
//  AppDelegate.h
//  BirdDriver
//
//  Created by Soul on 2018/5/14.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SJLoadingController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) SJLoadingController *loadingController;

@end

