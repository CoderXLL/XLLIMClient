//
//  SPWebViewController.m
//  CornucopiaFinancial
//
//  Created by Soul on 2017/9/28.
//  Copyright © 2017年 Soul&Polo. All rights reserved.
//

#import "SPWebViewController.h"
#import "SPNullDataView.h"

#define kWebRequestTimeOut  15.0f

@interface SPWebViewController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>{
    UIBarButtonItem *backItiem;
    UIBarButtonItem *closeItiem;
    NSMutableArray *titleNameArray;
}

@property (strong ,nonatomic) UIProgressView *progressView;
@property (strong ,nonatomic) NSMutableURLRequest *request;
@property (strong ,nonatomic) WKWebViewConfiguration *configuration;
@property (strong ,nonatomic) WKUserContentController *userContentController;

//返回按钮
@property (strong ,nonatomic) UIBarButtonItem *backItem;
//关闭按钮
@property (strong ,nonatomic) UIBarButtonItem *closeItem;
//与H5页面进行交互的响应方法注册者
@property (weak ,nonatomic) UIViewController <WKScriptMessageHandler> *registerViewController;
//与H5页面进行交互的响应方法名
@property (copy ,nonatomic) NSString *methodNameWithH5;
//无数据时的空视图
@property (strong ,nonatomic) SPNullDataView *nullView;

@end

@implementation SPWebViewController

- (void)dealloc{
    if (_webView) {
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
    }
    if (_userContentController && self.registerViewController != nil && self.methodNameWithH5 != nil) {
        [self.userContentController removeScriptMessageHandlerForName:self.methodNameWithH5];
    }
}

- (instancetype)initWithTitle:(NSString *)title
                          Url:(NSString *)urlStr
{
    if (self = [super init]) {
        self.urlstr = urlStr;
        self.title = title;
        self.hidesBottomBarWhenPushed = YES;
        [self factorySetBarItemBackImage:nil
                               backTitle:nil
                              closeImage:nil
                              closeTitle:nil];
        [self addResponseController:nil
                   methodNameWithH5:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

- (void)addResponseController:(id)responseController
             methodNameWithH5:(NSString *)methodNameWithH5{
    self.registerViewController = responseController;
    self.methodNameWithH5 = methodNameWithH5;
}

- (void)factorySetBarItemBackImage:(UIImage *)backImage
                                  backTitle:(NSString *)backTitle
                                 closeImage:(UIImage *)closeImage
                                 closeTitle:(NSString *)closeTitle{
    backItiem = [[UIBarButtonItem alloc] init];
    backItiem.style = UIBarButtonItemStylePlain;
    backItiem.target = self;
    backItiem.action = @selector(popToBack);
    if (backImage || backTitle) {
        backItiem.image = backImage;
        backItiem.title = backTitle;   
    } else {
        backItiem.image = [UIImage imageNamed:@"web_fh"];
    }
    closeItiem = [[UIBarButtonItem alloc] init];
    closeItiem.style = UIBarButtonItemStylePlain;
    closeItiem.target = self;
    closeItiem.action = @selector(close);
    if (closeImage || closeTitle) {
        closeItiem.image = closeImage;
        closeItiem.title = closeTitle;
    } else{
        closeItiem.title = @"关闭";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    titleNameArray = [NSMutableArray array];
    
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.nullView];
    [self.view addSubview:self.progressView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.nullView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.webView);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.webView);
        make.left.equalTo(self.webView);
        make.right.equalTo(self.webView);
        make.height.equalTo(@2);
    }];
    
    [self setBackNavibar];
    [self.webView loadRequest:self.request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SPNullDataView *)nullView{
    if (!_nullView) {
        _nullView = [[SPNullDataView alloc] initWithFrame:self.view.bounds];
        _nullView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
        //创建手势添加到视图上
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(click:)];
        [_nullView addGestureRecognizer:tapGesture];
        _nullView.hidden = YES;
    }
    return _nullView;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds
                                      configuration:self.configuration];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        __weak typeof(self)weakself = self;
        _webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.nullView setHidden:YES];
                [weakself.webView reload];
            });
        }];
        
        [_webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    }
    return _webView;
}

- (WKWebViewConfiguration *)configuration{
    if (!_configuration) {
        //配置环境
        _configuration = [[WKWebViewConfiguration alloc]init];
        _configuration.userContentController = self.userContentController;
    }
    return _configuration;
}

- (WKUserContentController *)userContentController{
    if (!_userContentController) {
        _userContentController =[[WKUserContentController alloc]init];
        //注册方法
        if (self.registerViewController != nil && self.methodNameWithH5 != nil) {
            [_userContentController addScriptMessageHandler:self.registerViewController
                                                       name:self.methodNameWithH5];
        }
    }
    return _userContentController;
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progressView.backgroundColor = JMY_LINE_COLOR;
        _progressView.progressTintColor = JMY_MAIN_COLOR;
        _progressView.frame = CGRectMake(0, 0,self.view.bounds.size.width, 2);
    }
    return _progressView;
}


#pragma mark - 错误页面点击
/** 点击事件*/
- (void)click:(UITapGestureRecognizer *)tapGesture {
    [self.webView loadRequest:self.request];
    self.nullView.hidden = YES;
}

- (NSMutableURLRequest *)request{
    if (!_request) {
        _request = [[NSMutableURLRequest alloc] init];
        _request.timeoutInterval = kWebRequestTimeOut;
        _request.URL = [NSURL URLWithString:self.urlstr];
    }
    return _request;
}

#pragma mark -  进度条监听
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.hidden = NO;
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
    }
    // 加载完成
    if (self.webView.estimatedProgress == 1) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0.0 animated:YES];
    }
}

#pragma mark - 添加关闭按钮
- (void)setBackNavibar {
    self.navigationItem.leftBarButtonItems = @[backItiem];
}

- (void)setCloseNavibar {
    self.navigationItem.leftBarButtonItems = @[backItiem,closeItiem];
}

- (void)popToBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)close{
    if ([_webView canGoBack]) {
        [_webView goBack];
        [titleNameArray removeLastObject];
        self.title = [titleNameArray lastObject];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreashData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webView reload];
    });
}

#pragma mark - WKNavigationDelegate来追踪加载过程

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
//    LogD(@"页面开始加载时调用");
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
//    LogD(@"当内容开始返回时调用");
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    LogD(@"页面加载完成之后调用");
    
    if (webView.title && webView.title.length>1) {
        self.title = webView.title;
        [titleNameArray addObject:webView.title];
    } else {
        [titleNameArray addObject:@""];
    }
    
    [webView.scrollView.mj_header endRefreshing];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    LogD(@"页面加载失败时调用:%@",error);
    if(error.code != -1022){
        self.nullView.hidden = NO;
        self.nullView.desStr = error.localizedDescription;
    }
    [webView.scrollView.mj_header endRefreshing];
}

#pragma mark - WKNavigtionDelegate来进行页面跳转

// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
//    LogD(@"接收到服务器跳转请求之后再执行");
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//    LogD(@"在收到响应后，决定是否跳转");
    
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    
    if ([webView canGoBack]) {
        [self setCloseNavibar];
    }else{
        [self setBackNavibar];
    }
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//    LogD(@"在发送请求之前，决定是否跳转");
    
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark -  WKUIDelegate

////1.创建一个新的WebVeiw
//- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
//    LogD(@"创建一个新的WebVeiw");
//    return [[WKWebView alloc] init];
//}

////2.WebView关闭（9.0中的新方法）
//- (void)webViewDidClose:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0){
//    LogD(@"WebVeiw关闭");
//}

//3.显示一个JS的Alert（与JS交互）
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    LogD(@"显示一个JS的Alert");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

//4.弹出一个输入框（与JS交互的）
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    LogD(@"弹出一个输入框");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

//5.显示一个确认框（JS的）
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    LogD(@"显示一个确认框");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
}

#pragma mark - 清除缓存
+ (void)removeWebCache{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        NSSet *websiteDataTypes= [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeCookies]];
        // All kinds of data
        //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        }];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    } else {
        //先删除cookie
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            [storage deleteCookie:cookie];
        }
        
        NSString *libraryDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleIdentifier"];
        NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
        NSString *webKitFolderInCaches = [NSString
                                          stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
        NSString *webKitFolderInCachesfs = [NSString
                                            stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
        NSError *error;
        /* iOS8.0 WebView Cache的存放路径 */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
        /* iOS7.0 WebView Cache的存放路径 */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
        NSString *cookiesFolderPath = [libraryDir stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&error];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
}

- (void)setUrlstr:(NSString *)urlstr
{
    //长链接直接赋值，短链接拼服务器地址
    NSString *url = [urlstr copy];
    if (url) {
        if ([[urlstr substringToIndex:1]isEqualToString:@"/"]) {
            url = [GO_SERVER_H5 stringByAppendingString:url];
        }
    }
    LogD(@"加载网址...%@",url);
    _urlstr = url;
}

@end
