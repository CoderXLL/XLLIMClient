//
//  Public.m
//  XLLBaseProject
//
//  Created by 肖乐 on 2018/4/2.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import "Public.h"
#import "AppDelegate.h"

@implementation Public

//App名称
+ (NSString *)appName
{
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    return appName;
}

//版本号
+ (NSString *)appVersion
{
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

//build号
+ (NSString *)appBuild
{
    NSString *appBuild = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return appBuild;
}

//收回键盘
+ (void)hideKeyboard
{
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    if(!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
        return;
    }
    UIWindow *keyWindow = [[UIApplicationClass performSelector:@selector(sharedApplication)] valueForKey:@"keyWindow"];
    [keyWindow endEditing:YES];
}

//公共提示框
+ (void)globalTipsVC:(UIViewController *_Nullable)vc tips:(NSString *)tips
{
    if (IsEmptyValue(tips))
    {
        XLLLog(@"为空了")
    }
    UILabel *lable = [[UILabel alloc] initWithFrame:
                      CGRectMake(0, 0, 230, 35)];
    lable.backgroundColor     = [UIColor blackColor];
    lable.textColor           = [UIColor whiteColor];
    lable.alpha               = 0;
    lable.textAlignment       = NSTextAlignmentCenter;
    lable.layer.cornerRadius  = 5;
    lable.layer.masksToBounds = YES;
    lable.text                = tips;
    lable.font                = [UIFont systemFontOfSize:16];
    lable.numberOfLines = 0;
    CGFloat height = [tips boundingRectWithSize:CGSizeMake(lable.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:lable.font} context:nil].size.height;
    height = MAX(height, 35);
    lable.height = height;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    lable.center = app.window.center;
    [app.window addSubview:lable];
    [UIView animateWithDuration:1.0 animations:^{ //动画效果
        lable.alpha = 0.9;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             lable.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [lable removeFromSuperview];
                         }];
    }];
}

@end
