//
//  SJTabBarController.m
//  BirdDriver
//
//  Created by Soul on 2018/5/16.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SJTabBarController.h"
#import "SJNavController.h"
#import "SJHomeController.h"
#import "SJDiscoveryController.h"
#import "SJMineController.h"
#import "SJLoginController.h"
#import "SJUpdateTipView.h"

 

#import <WRNavigationBar/WRNavigationBar.h>
#import <AFNetworking/AFHTTPSessionManager.h>

#define kMaxHideUpdateTimes         3       //请求x次还不更新就弹框

@interface SJTabBarController ()<UITabBarControllerDelegate>

@end

@implementation SJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    
    [self setUpAllChildController];
    [self configureNavigationBar];
    [self configureTabbar];
    [self configureApplication];
    
    [self checkAppStoreUpdate];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 添加子视图
 */
- (void)setUpAllChildController {
    // 1 - 首页
    SJHomeController *homeVC = [SJHomeController new];
    SJNavController *homeNav = [[SJNavController alloc] initWithRootViewController:homeVC];
    homeVC.tabBarItem.title = @"首页";
    homeVC.tabBarItem.tag = 1;
    homeVC.tabBarItem.image = [[UIImage imageNamed:@"tabbar_home_nor"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_home_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:homeNav];
    
    // 2 - 发现
    SJDiscoveryController *discoveryVC = [SJDiscoveryController new];
    SJNavController *discoveryNav = [[SJNavController alloc] initWithRootViewController:discoveryVC];
    discoveryVC.tabBarItem.title = @"鸟巢";
    discoveryVC.tabBarItem.tag = 2;
    discoveryVC.tabBarItem.image = [[UIImage imageNamed:@"tabbar_more_nor"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    discoveryVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_more_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:discoveryNav];
    
    // 3 - 我的
    SJMineController *mineVC = [SJMineController new];
    SJNavController *mineNav = [[SJNavController alloc] initWithRootViewController:mineVC];
    mineVC.tabBarItem.title = @"我的";
    mineVC.tabBarItem.tag = 3;
    mineVC.tabBarItem.image = [[UIImage imageNamed:@"tabbar_mine_nor"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_mine_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:mineNav];
}

/**
 配置TabBar
 */
- (void)configureTabbar{
    [self setSelectedIndex:0];
    self.tabBar.tintColor       = SJ_MAIN_COLOR;           //字体色
    self.tabBar.barTintColor    = SP_WHITE_COLOR;           //背景色
    self.tabBarController.tabBar.hidden = NO;
}

/**
 配置NavigationBar
 */
- (void)configureNavigationBar{
    [WRNavigationBar wr_widely];
    // 统一设置状态栏样式
    [WRNavigationBar wr_setDefaultStatusBarStyle:UIStatusBarStyleDefault];
    // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:YES];
    // 设置导航栏默认的背景颜色
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:[UIColor whiteColor]];
    // 设置导航栏所有按钮的默认颜色
    [WRNavigationBar wr_setDefaultNavBarTintColor:[UIColor blackColor]];
    // 设置导航栏标题默认颜色
    [WRNavigationBar wr_setDefaultNavBarTitleColor:[UIColor blackColor]];
}

/**
 全局设置app
 */
- (void)configureApplication{
    //设置键盘
    [IQKeyboardManager.sharedManager setToolbarTintColor:JMY_MAIN_COLOR];
    
    //设置Toast
    [SVProgressHUD setFadeInAnimationDuration:0];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    //自动登录
//    [self autoLogin];
    
//    获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
//    //全局错误
//    [center addObserver:self
//               selector:@selector(notice:)
//                   name:@"GlobalError"
//                 object:nil];
//
    //登录已经过期
    [center addObserver:self
               selector:@selector(loginAction)
                   name:kNotify_Login_Request
                 object:self.navigationController];
}

// 接收全局通知
- (void)notice:(NSNotification *)sender{
    LogD(@"接收到全局通知:%@",sender);
}

//接受登陆通知
- (void)loginAction{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SJLoginAction" bundle:nil];
    SJLoginController *loginVC = [storyBoard instantiateViewControllerWithIdentifier:@"SJLoginController"];
    SJNavController *nav = [[SJNavController alloc] initWithRootViewController:loginVC];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:nav
                           animated:YES
                         completion:nil];
    });
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSInteger index = [self.childViewControllers indexOfObject:viewController];
    if (index == 2 && !SPLocalInfo.hasBeenLogin) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SJLoginAction" bundle:nil];
        SJLoginController *loginVC = [storyBoard instantiateViewControllerWithIdentifier:@"SJLoginController"];
        SJNavController *nav = [[SJNavController alloc] initWithRootViewController:loginVC];
        [viewController presentViewController:nav animated:YES completion:nil];
    }
    return YES;
//    if(viewController.tabBarItem.tag == self.selectedIndex+1){
//        return NO;
//    }else{
//        return YES;
//    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    UMengEventId umengId = Nsj_Event_Common;
    NSString *nsjId = @"";
    NSString *nsjDes = @"";
    switch (item.tag) {
        case 1:
            umengId = Nsj_Event_Home;
            nsjId  = @"30010001";
            nsjDes = @"通过Tab1进入首页页面";
            break;
        case 2:
            umengId = Nsj_Event_Discovery;
            nsjId  = @"40010001";
            nsjDes = @"通过Tab2进入发现页面";
            break;
        case 3:
            umengId = Nsj_Event_Mine;
            nsjId  = @"20010001";
            nsjDes = @"通过Tab3进入我的页面";
            break;
            
        default:
            break;
    }
    
    [SJStatisticEventTool umengEvent:umengId
                               NsjId:nsjId
                             NsjName:nsjDes];
}

#pragma mark - 检查更新
- (void)checkAppStoreUpdate{
    //请求服务器，获取最新APP版本
    NSString *path = [[NSString alloc] initWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",kAPPStore_Id];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url
                                                          cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0f];
    [request setHTTPMethod:@"POST"];
    WEAKSELF
    [[AFHTTPSessionManager manager] POST:path
                              parameters:nil
                                progress:^(NSProgress * _Nonnull uploadProgress) {
                                    LogD(@"!!-查询进度:%@",uploadProgress);
                                }
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                     NSDictionary *receiveDic = [responseObject mj_JSONObject];
                                     LogD(@"!!-查询receiveDic is %@",receiveDic);
                                     if ([receiveDic.allKeys containsObject:@"results"]) {
                                         NSDictionary *revDict = receiveDic[@"results"][0];
                                          [weakSelf compareVersion:revDict];
                                     }
                                    
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     LogD(@"!!-查询Error:%@",error);
                                 }];
}

//比对推荐更新版本
- (void)compareVersion:(NSDictionary *)receiveDic{
    NSString *storeVersion = receiveDic[@"version"];
    NSString *localVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    
    NSArray *localArray = [localVersion componentsSeparatedByString:@"."];
    NSArray *versionArray = [storeVersion componentsSeparatedByString:@"."];
    //版本号比较
    if(localArray.count == 2 && versionArray.count == 2){
        if ([localArray[0] intValue] <  [versionArray[0] intValue])
        {
            [self saveStoreVersion:storeVersion];
        }else if ([localArray[0] intValue]  ==  [versionArray[0] intValue]){
            if ([localArray[1] intValue] <  [versionArray[1] intValue])
            {
                [self saveStoreVersion:storeVersion];
            }
        }
    }else if(localArray.count == 2 && versionArray.count == 3){
        if ([localArray[0] intValue] <  [versionArray[0] intValue])
        {
            [self saveStoreVersion:storeVersion];
        }else if ([localArray[0] intValue]  ==  [versionArray[0] intValue]){
            if ([localArray[1] intValue] <  [versionArray[1] intValue])
            {
                [self saveStoreVersion:storeVersion];
            }else if ([localArray[1] intValue] ==  [versionArray[1] intValue]){
                if([versionArray[2] intValue] > 0)
                {
                    [self saveStoreVersion:storeVersion];
                }
            }
        }
    }else if(localArray.count == 3 && versionArray.count == 2){
        if([localArray[0] intValue] <  [versionArray[0] intValue])
        {
            [self saveStoreVersion:storeVersion];
        }else if ([localArray[0] intValue] ==  [versionArray[0] intValue]){
            if ([localArray[1] intValue] <  [versionArray[1] intValue])
            {
                [self saveStoreVersion:storeVersion];
            }
        }
    }else if ((versionArray.count == 3) && (localArray.count == versionArray.count)) {
        if ([localArray[0] intValue] <  [versionArray[0] intValue]) {
            [self saveStoreVersion:storeVersion];
        }else if ([localArray[0] intValue]  ==  [versionArray[0] intValue]){
            if ([localArray[1] intValue] <  [versionArray[1] intValue]) {
                [self saveStoreVersion:storeVersion];
            }else if ([localArray[1] intValue] ==  [versionArray[1] intValue]){
                if ([localArray[2] intValue] <  [versionArray[2] intValue]) {
                    [self saveStoreVersion:storeVersion];
                }
            }
        }
    }
}

- (void)saveStoreVersion:(NSString *)storeVersion{
    //缓存版本号到本地，自增次数
    if (SPUserDefault.kAppStoreVersion) {
        if (SPUserDefault.kAppStoreVersion && [SPUserDefault.kAppStoreVersion isEqualToString:storeVersion]) {
            SPUserDefault.kAppUpdateTips += 1;
        }else{
            SPUserDefault.kAppStoreVersion = storeVersion;
            SPUserDefault.kAppUpdateTips = 1;
        }
    }else{
        SPUserDefault.kAppStoreVersion = storeVersion;
        SPUserDefault.kAppUpdateTips = 0;
    }
    
    //大于kMaxHideUpdateTimes次就弹框
    if (SPUserDefault.kAppUpdateTips >= kMaxHideUpdateTimes) {
         LogD(@"已经提示%ld次要更新%@版本了",SPUserDefault.kAppUpdateTips-kMaxHideUpdateTimes,storeVersion);
        [self showUpdateAlert:storeVersion];
    }else{
        LogD(@"再提示%ld次就弹框更新%@版本了",(kMaxHideUpdateTimes-SPUserDefault.kAppUpdateTips),storeVersion);
    }
}

//弹框“提示更新”
- (void)showUpdateAlert:(NSString *)storeVersion{
#warning Todo 弹框
    SJUpdateTipView *tipView = [SJUpdateTipView getUpdateTipView:storeVersion touchBlock:^{
        
        NSString *appstoreUrlString = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1403770105";
        NSString *appstoreUrlString1 = @"itms-apps://itunes.apple.com/app/id1403770105";
        NSURL * url = [NSURL URLWithString:appstoreUrlString];
        if (@available(iOS 11.0, *)) {
            
            url = [NSURL URLWithString:appstoreUrlString1];
        }
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        } else {
            LogD(@"can not open");
        }
    }];
    [tipView show];
}

@end
