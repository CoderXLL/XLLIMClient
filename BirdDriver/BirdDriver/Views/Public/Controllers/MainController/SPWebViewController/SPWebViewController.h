//
//  SPWebViewController.h
//  CornucopiaFinancial
//
//  Created by Soul on 2017/9/28.
//  Copyright © 2017年 Soul&Polo. All rights reserved.
//

#import "SPViewController.h"
#import <WebKit/WebKit.h>

@interface SPWebViewController : SPViewController

@property (copy ,nonatomic)  NSString *urlstr;
@property (strong ,nonatomic) WKWebView *webView;

- (instancetype)initWithTitle:(NSString *)title
                          Url:(NSString *)urlStr;

/**
 添加与H5进行JS交互后的响应者，一般为ViewController

 @param responseController WKScriptMessageHandler的响应者，通过系统代理接收web返回的数据
 @param methodNameWithH5 与H5端约定好的方法名，注册监听接收数据
 */
- (void)addResponseController:(id)responseController
             methodNameWithH5:(NSString *)methodNameWithH5;

/**
 工厂方法设置导航栏返回按钮样式和关闭按钮样式

 @param backImage 返回按钮图案，默认为@"web_fh"
 @param backTitle 返回按钮标题，默认为空
 @param closeImage 关闭按钮图案
 @param closeTitle 关闭按钮标题，默认为”关闭“
 */
- (void)factorySetBarItemBackImage:(UIImage *)backImage
                         backTitle:(NSString *)backTitle
                        closeImage:(UIImage *)closeImage
                        closeTitle:(NSString *)closeTitle;

/**
 刷新页面
 */
- (void)refreashData;

/**
 清除缓存（类方法）
 */
+ (void)removeWebCache;

@end
