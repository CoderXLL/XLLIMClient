//
//  SJDetailNoteCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/6.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJDetailNoteCell.h"
#import <WebKit/WebKit.h>

static float webViewHeight = 100.0;    //webView初始化高度

@interface SJDetailNoteCell () <UIWebViewDelegate>
{
    BOOL _isFinishLoad;
}

@property (nonatomic, weak) UIWebView *webView;

@end

@implementation SJDetailNoteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupBase];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupBase
{
    /**
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [[WKUserContentController alloc] init];
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 0;
    configuration.preferences = preferences;
     */
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    webView.scrollView.bounces = NO;
    webView.scrollView.scrollEnabled = NO;
    if (@available(iOS 11.0, *)) {
        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
//    [webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.contentView addSubview:webView];
    self.webView = webView;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(@5);
        make.left.mas_equalTo(@15);
        make.centerX.mas_equalTo(self.contentView.mas_centerX).offset(0);
        make.bottom.mas_equalTo(@20);
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"] && [object isEqual:self.webView.scrollView])
    {
//        webViewHeight = self.webView.scrollView.contentSize.height+20+5;
//        if (self.heightBlock) {
//            self.heightBlock(webViewHeight);
//        }
    }
}

- (void)setHtmlString:(NSString *)htmlString
{
    _htmlString = [htmlString copy];
    if (kStringIsEmpty(htmlString))
        return;
    if (_isFinishLoad) {
        
//        @try {
//            [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
//        } @catch (NSException *exception) {
//            LogD(@"NSException *exception")
//        }
        [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(@5);
            make.left.mas_equalTo(@15);
            make.centerX.mas_equalTo(self.contentView.mas_centerX).offset(0);
            make.bottom.mas_equalTo(@20);
        }];
    }
    NSString *htmlStr = [NSString stringWithFormat:@"<html> \n"
                         "<head> \n"
                         "<style type=\"text/css\"> \n"
                         "body {font-size:15px;}\n"
                         "img {width:100%%;margin:10px auto;display: block;}\n"
                         "</style> \n"
                         "</head> \n"
                         "<body>"
                         "%@"
                         "</body>"
                         "</html>", htmlString];
    if (!_isFinishLoad) {
        [self.webView loadHTMLString:htmlStr baseURL:nil];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _isFinishLoad = YES;
    //注入JS防止放大代码
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView stringByEvaluatingJavaScriptFromString:injectionJSString];
    /**
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }";
    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 2*kSJMargin];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    */
    
    
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
                                             
                                             
                                             
                                             //注入自定义的js方法后别忘了调用 否则不会生效（不调用也一样生效了，，，不明白）
                                             
                                             [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    
    if (self.heightBlock) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            webViewHeight = webView.scrollView.contentSize.height+20+5;
            self.heightBlock(webViewHeight);
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
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickImageUrl:AllImageArr:)])
        {
            [self.delegate didClickImageUrl:imageUrl AllImageArr:urlArray];
        }
        return NO;
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (void)dealloc
{
//    @try {
//        [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
//    } @catch (NSException *exception) {
//        LogD(@"NSException *exception")
//    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

//    self.webView.frame = CGRectMake(kSJMargin, 5, self.width-2*kSJMargin, self.height-20-5);
}

@end
