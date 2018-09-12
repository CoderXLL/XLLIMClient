//
//  AppDelegate.m
//  BirdDriver
//
//  Created by Soul on 2018/5/14.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "SJTabBarController.h"
#import "SJNavController.h"
#import "SJLoadingController.h"
#import <WXApi.h>
#import <AFNetworking/AFNetworking.h>
#import <UserNotifications/UserNotifications.h>
#import <JPUSHService.h>
#import "GuidePageViewController.h"
#import "JASendSMSPresenter.h"
#import "JAUserPresenter.h"
#import <Bugtags/Bugtags.h>
#import <UMMobClick/MobClick.h>
#import "SJWXSDKManager.h"
#import "SJNoteDetailController.h"
#import "SJDetailController.h"
#import "SJRouteDetailController.h"
#import "SJFansViewController.h"
#import "SJOtherInfoPageController.h"
#import "JAMessageModel.h"
#import "AppDelegate+SJJump.h"

@interface SJOpenAppModel : SPBaseModel

/**
 类型 webView H5页面  postingDetail  帖子详情 activityeDetail  活动详情  otherHome 他人主页
 */
@property (nonatomic, copy) NSString *type;

/**
 H5地址
 */
@property (nonatomic, copy) NSString *pageUrl;

/**
 帖子或活动ID
 */
@property (nonatomic, copy) NSString *detailId;

/**
 用户ID
 */
@property (nonatomic, copy) NSString *userId;

@end

@implementation SJOpenAppModel

@end


@interface AppDelegate () <JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:kSJSharePageKey];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kSJShareDetailsIdKey];
    //初始化窗口
    [self setupWindow];
    //监听网络
    [self listenNetWorkingPort];
    //注册微信SDK
    [WXApi registerApp:kWeiXin_AppKey];
    //注册bugtags
    [self setupBugTags];
    //自动登录
    [self autologin];
    //引导页
    //    [self setupGuide];
    
//    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if (userInfo) {
//        
//        [self jumpViewController:userInfo];
//    }
    
    //配置极光推送
    [self setupJpush:launchOptions];
    
    //配置友盟统计
    [self setupUmeng];
    
    //后台配置 - H5链接
    //    [GORouterPresenter updateLocalH5];
    return YES;
}


-(void)autologin {
    [JAUserPresenter postAutoLogin:^(JAUserModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (model.success)
            {
                if (!kStringIsEmpty(model.data.nickName)) {
                    [SPLocalInfoModel shareInstance].hasBeenLogin = YES;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_loginSuccess object:nil];
                }
            }
        });
    }];
}

#pragma mark - 监听网络状态
- (void)listenNetWorkingPort
{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // 改变当前网络状态
        switch (status) {
                // WIFI
            case AFNetworkReachabilityStatusReachableViaWiFi:
                // 流量
            case AFNetworkReachabilityStatusReachableViaWWAN:
                // 未知
            case AFNetworkReachabilityStatusUnknown:
            {
                if (!SPLocalInfo.hasBeenLogin) {
                    [self autologin];
                }
            }
                break;
                // 没网
            case AFNetworkReachabilityStatusNotReachable:
            {
                
            }
                break;
                
            default:
                break;
        }
    }];
    
    [mgr startMonitoring];
}

/**
//推送跳入指定页面
- (void)jumpViewController:(NSDictionary *)userInfo
{
    //弹一下
    [self alertUserInfo:userInfo];
    JAMessageModel *messageModel = [JAMessageModel mj_objectWithKeyValues:userInfo];
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (![app.window.rootViewController isKindOfClass:[SJTabBarController class]])
    {
        return;
    }
    SJTabBarController *tabVC = (SJTabBarController *)app.window.rootViewController;
    NSInteger currentIndex = tabVC.selectedIndex;
    SJNavController *nav = tabVC.childViewControllers[currentIndex];
    if (!kDictIsEmpty(userInfo)) {
        
        //点击进入详情
        switch (messageModel.messageType) {
            case 2:
            {
                LogD(@"跳转到帖子或者活动...");
                [self pushToDetails:messageModel.relevanceId];
                break;
            }
            case 3:
            {
                LogD(@"跳转到帖子或者活动...");
                [self pushToDetails:messageModel.relevanceId];
                break;
            }
            case 4:{
                LogD(@"关注产生的消息...");
                [self pushToFansController];
                break;
            }
            case 5:
            {
                LogD(@"跳转到帖子或者活动...");
                [self pushActvityChildController:messageModel.relevanceId];
                break;
            }
            case 6:
            {
                LogD(@"跳转到帖子或者活动...");
                if (messageModel.messageSecType == 2) {
                    [self pushActvityChildController:messageModel.relevanceId];
                }else{
                    [self pushNoteChildController:messageModel.relevanceId];
                }
                break;
            }
            default:
                break;
        }
        return;
        NSString *messageType = userInfo[@"messageType"];
        if (kStringIsEmpty(messageType)) return;
        NSString *relevanceId = userInfo[@"relevanceId"];
        if (kStringIsEmpty(relevanceId)) return;
        if ([messageType isEqualToString:@"2"] || [messageType isEqualToString:@"3"] || [messageType isEqualToString:@"5"]) {
            
            //帖子或活动
            [JABbsPresenter postQueryDetails:relevanceId.integerValue Result:^(JABBSModel * _Nullable model) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    if (model.success) {
                        
                        if (model.detail.detailsType == 1)
                        {
                            // 帖子
                            SJNoteDetailController *detailVC = [[SJNoteDetailController alloc] init];
                            detailVC.noteId = relevanceId.integerValue;
                            detailVC.titleName = @"帖子详情";
                            [nav pushViewController:detailVC animated:YES];
                        }else{
                            //活动
                            SJFootprintDetailsController *detailVC = [[SJFootprintDetailsController alloc] init];
                            detailVC.activityId = relevanceId.integerValue;
                            detailVC.titleName = model.detail.detailsName;
                            [nav pushViewController:detailVC animated:YES];
                        }
                    } else {
                        [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default*1.5];
                    }
                });
            }];
        } else if ([messageType isEqualToString:@"4"]) { //粉丝列表
            SJFansViewController *fansVC = [[SJFansViewController alloc] init];
            fansVC.titleName = @"我的粉丝";
            fansVC.userId = SPLocalInfo.userModel.Id;
            [nav pushViewController:fansVC animated:YES];
        }
        
    }
}
 */

//废弃方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:[SJWXSDKManager shareWXSDKManager]];
}

//废弃方法
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:[SJWXSDKManager shareWXSDKManager]];
}

//新的方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    if ([url.scheme isEqualToString:@"niaosiji"])
    {
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        if ([app.window.rootViewController isKindOfClass:[SJTabBarController class]]) {
            
            SJTabBarController *tabVC = (SJTabBarController *)app.window.rootViewController;
            NSInteger currentIndex = tabVC.selectedIndex;
            SJNavController *nav = [tabVC.childViewControllers firstObject];
            if (tabVC.selectedIndex != 0) {
                tabVC.selectedIndex = 0;
            }
            SJNavController *showVCNav = [tabVC.childViewControllers objectAtIndex:currentIndex];
            [showVCNav popToRootViewControllerAnimated:YES];
            
            NSString *absoluteStr = url.absoluteString;
            NSArray *strArr = [absoluteStr componentsSeparatedByString:@"data="];
            if (!kArrayIsEmpty(strArr))
            {
                //UTF-8反解码
                NSString *jsonStr = [strArr.lastObject stringByRemovingPercentEncoding];
//                NSString *jsonStr = [strArr.lastObject stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                if (kStringIsEmpty(jsonStr))
                    return NO;
                NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&error];
                if (error) {
                    LogD(@"解析失败")
                    return NO;
                }
                SJOpenAppModel *openAppModel = [SJOpenAppModel mj_objectWithKeyValues:jsonDict];
                if ([openAppModel.type isEqualToString:@"webview"])
                {
                    SJDetailController *detailVC = [[SJDetailController alloc] init];
                    detailVC.detailStr = [NSString stringWithFormat:@"%@%@", JA_SERVER_WEB, openAppModel.pageUrl];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [nav showViewController:detailVC sender:nil];
                    });
                } else if ([openAppModel.type isEqualToString:@"postingDetail"]) {
                    //帖子详情
                    SJNoteDetailController *detailVC = [[SJNoteDetailController alloc] init];
                    detailVC.noteId = openAppModel.detailId.integerValue;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [nav showViewController:detailVC sender:nil];
                    });
                } else if ([openAppModel.type isEqualToString:@"activityeDetail"]) {
                    //路线详情
                    SJRouteDetailController *detailVC = [[SJRouteDetailController alloc] init];
                    detailVC.routeId = openAppModel.detailId.integerValue;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [nav showViewController:detailVC sender:nil];
                    });
                } else if ([openAppModel.type isEqualToString:@"otherHome"]) {
                    
                    //个人主页
                    SJOtherInfoPageController *otherVC = [[SJOtherInfoPageController alloc] init];
                    otherVC.userId = openAppModel.userId.integerValue;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [nav showViewController:otherVC sender:nil];
                    });
                }
            }
            
        }
        return YES;
    }
    //微信打开我们的App相关
    return [WXApi handleOpenURL:url delegate:[SJWXSDKManager shareWXSDKManager]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    //极光清除角标
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 窗口
- (void)setupWindow {
    self.loadingController = [SJLoadingController shareLoadingController];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = JMY_BG_COLOR;
    [self.window makeKeyAndVisible];
    [self chooseRootViewController];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)chooseRootViewController {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:@"version"];
    NSString *currentVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    BOOL isNewVersion = ![currentVersion isEqualToString:lastVersion];
    if (isNewVersion) {
        // 存储这次使用的软件版本
        [defaults setObject:currentVersion forKey:@"version"];
        [defaults synchronize];
    }
    // 是否显示引导页
    BOOL showNewFeature = !lastVersion || ([self compareVersion:lastVersion oldVersion:currentVersion] < 0);
    if (showNewFeature) {
        //显示引导页
        GuidePageViewController *viewController = [[GuidePageViewController alloc] initWithImageArray:@[@"GuidePage-1",@"GuidePage-2",@"GuidePage-3"] containsButtons:NO containsPageControl:NO];
        self.window.rootViewController = viewController;
        viewController.guidePageBlock = ^{
            self.window.rootViewController = [[SJTabBarController alloc] init];
        };
    } else {
        self.window.rootViewController = [[SJTabBarController alloc] init];
    }
}

//比较两个版本号
- (NSInteger)compareVersion:(NSString *)lastVersion oldVersion:(NSString *)oldVersion {
    NSArray *leftPartitions = [lastVersion componentsSeparatedByString:@"."];
    NSArray *rightPartitions = [oldVersion componentsSeparatedByString:@"."];
    for (int i = 0; i < leftPartitions.count && i < rightPartitions.count; i++) {
        NSString *leftPartition = [leftPartitions objectAtIndex:i];
        NSString *rightPartition = [rightPartitions objectAtIndex:i];
        if (leftPartition.integerValue != rightPartition.integerValue) {
            return leftPartition.integerValue - rightPartition.integerValue;
        }
    }
    return 0;
}

#pragma mark - 友盟
/**
 集成友盟统计
 */
- (void)setupUmeng
{
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        UMConfigInstance.appKey = kUMeng_key;
        UMConfigInstance.channelId = kUMeng_channel;
        [MobClick setAppVersion:version];
#ifdef DEBUG
        [MobClick setLogEnabled:YES];
#endif
        [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
}

#pragma mark - 极光推送
- (void)setupJpush:(NSDictionary * _Nullable)launchOptions {
    //极光推送
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
    }
    [JPUSHService registerForRemoteNotificationConfig:entity
                                             delegate:self];
    
    [JPUSHService setupWithOption:launchOptions
                           appKey:kJPush_key
                          channel:kJPush_channel
                 apsForProduction:YES];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    LogD(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    LogD(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(nonnull UILocalNotification *)notification completionHandler:(nonnull void (^)(void))completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)(void))completionHandler {
}
#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    LogD(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive )
    {
        [self jumpViewController:userInfo];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [JPUSHService setBadge:0];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0)
    {
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
}

- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler{
    LogD(@"唤醒userActivity : %@",userActivity.webpageURL.description);
    return YES;
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0))
{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        // 收到推送的请求
        UNNotificationRequest *request = notification.request;
        UNNotificationContent *content = request.content; // 收到推送的消息内容
        NSNumber *badge = content.badge;  // 推送消息的角标
        NSString *body = content.body;    // 推送消息体
        UNNotificationSound *sound = content.sound;  // 推送消息的声音
        NSString *subtitle = content.subtitle;  // 推送消息的副标题
        NSString *title = content.title;  // 推送消息的标题
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
            LogD(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
//            [self jumpViewController:userInfo];
        }else {
            // 判断为本地通知
            LogD(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge: %@，\nsound: %@，\nuserInfo: %@\n}",body,title,subtitle,badge,sound,userInfo);
        }
        completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    } else {
        // Fallback on earlier versions
    }
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0))
{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容


    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题


    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        [self jumpViewController:userInfo];
    }else {
        // 判断为本地通知
        LogD(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge: %@，\nsound: %@，\nuserInfo: %@\n}",body,title,subtitle,badge,sound,userInfo);
    }

    completionHandler();  // 系统要求执行这个方法
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData
                                                              options:NSPropertyListImmutable
                                                               format:NULL
                                                                error:nil];
    return str;
}

- (void)setupBugTags {
    BugtagsOptions *options = [[BugtagsOptions alloc] init];
    options.trackingUserSteps = YES;
    [Bugtags startWithAppKey:kBugTags_key
             invocationEvent:BTGInvocationEventBubble];
}

@end

