//
//  SJRouteFooterView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJRouteFooterView.h"

@interface SJRouteFooterView () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SJRouteFooterView

+ (instancetype)createCellWithXib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SJRouteFooterView" owner:nil options:nil] objectAtIndex:0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.scrollEnabled = NO;
    if (@available(iOS 11.0, *)) {
    self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

#pragma mark - setter
- (void)setHtmlStr:(NSString *)htmlStr
{
    _htmlStr = [htmlStr copy];
    NSString *realStr = [NSString stringWithFormat:@"<html> \n"
                         "<head> \n"
                         "<style type=\"text/css\"> \n"
                         "body {font-size:14px;}\n"
                         "img {width:100%%;margin: 10px auto;display: block;border-radius:4px;}\n"
                         //margin: 5px auto;
                         "p {line-height: 26px; letter-spacing: 1px; font-size:14px; color:#2B3248}\n"
                         "</style> \n"
                         "</head> \n"
                         "<body>"
                         "%@"
                         "</body>"
                         "</html>", htmlStr];
    [self.webView loadHTMLString:realStr baseURL:nil];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //注入JS防止放大代码
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView stringByEvaluatingJavaScriptFromString:injectionJSString];
    //js方法遍历图片添加点击事件 返回图片个数
    static  NSString * const jsGetImages = @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src;\
    };\
    };\
    return objs.length;\
    };";
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    //注入自定义的js方法后别忘了调用 否则不会生效
    [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    if (self.heightBlock) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            CGFloat webViewHeight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
            if (webViewHeight>10000) {
                CGFloat addMargin = iPhoneX?30:10;
                webViewHeight+=addMargin;
            }
            CGFloat totalHeight = webViewHeight+45+25+60;
            self.heightBlock(totalHeight);
        });
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //将url转换为string
    NSString *requestString = [[request URL] absoluteString];
    if ([requestString hasPrefix:@"myweb:imageClick:"])
    {
        static  NSString * const jsGetImages =
        @"function getImages(){\
        var objs = document.getElementsByTagName(\"img\");\
        var imgScr = '';\
        for(var i=0;i<objs.length;i++){\
        imgScr = imgScr + objs[i].src + '+';\
        };\
        return imgScr;\
        };";
        
        [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
        NSString *urlResult = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
        NSArray *urlArray = [NSMutableArray arrayWithArray:[urlResult componentsSeparatedByString:@"+"]];
        NSMutableArray *realArr = [NSMutableArray array];
        for (NSString *imageUrl in urlArray) {
            if (!kStringIsEmpty(imageUrl)) {
                
                [realArr addObject:imageUrl];
            }
        }
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        //回执..
        
        return NO;
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (void)dealloc
{
    self.webView.delegate = nil;
#ifdef DEBUG
    LogD(@"WebView被销毁")
#endif
}


@end
