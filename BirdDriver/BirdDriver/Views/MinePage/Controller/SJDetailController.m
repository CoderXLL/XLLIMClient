//
//  SJActivityDetailController.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/28.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJDetailController.h"
#import "SJPhotoModel.h"
#import <WebKit/WebKit.h>
#import "SJLoginController.h"
#import "SJMyPictureController.h"
#import "SJConcernViewController.h"
#import "SJFansViewController.h"
#import "SJBuildNoteController.h"
 
#import "SJNoDataFootView.h"
#import "SJShareView.h"
#import <WXApi.h>
#import "UIImage+ColorsImage.h"
#import "JABbsPresenter.h"
#import "JAConfigPresenter.h"

typedef NS_ENUM(NSInteger, SJJSNavActionShowType) {
    
    SJJSNavActionShowTypeEnjoy=1, //分享
    SJJSNavActionShowTypeCollection,  //收藏
    SJJSNavActionShowTypeDouble,  //有分享，有收藏
    SJJSNavActionShowTypeNone  //啥也没有
};

typedef NS_ENUM(NSInteger, SJJSNavActionShareType) {
    
    SJJSNavActionShareTypeNote = 1,      //帖子
    SJJSNavActionShareTypeActivity,        //活动
    SJJSNavActionShareTypeMyPage,       //我的主页
    SJJSNavActionShareTypeOtherPage,   //他人主页
    SJJSNavActionShareTypePlayerDetail, //选手详情
    SJJSNavActionShareTypeEnroll,           //报名活动页
    SJJSNavActionShareTypePrize,            //抽奖页面
    SJJSNavActionShareTypeMaotai,         //茅台活动页
    SJJSNavActionShareTypePlayerList,    //选手列表页
    SJJSNavActionShareTypeOther            //其他
};

@interface SJJSNavActionModel : SPBaseModel

@property (nonatomic, assign) SJJSNavActionShowType status;
//收藏ID， 没有被收藏为空
@property (nonatomic, copy) NSString *collectionId;
//ID
@property (nonatomic, copy) NSString *ID;
//1.帖子 2.活动 3.自己主页  4.别人主页
@property (nonatomic, assign) SJJSNavActionShareType type;
//帖子第一张图 或者活动图
@property (nonatomic, copy) NSString *pictureAddress;
//帖子标题或者标题名，活动名
@property (nonatomic, copy) NSString *name;
//要分享的路径
@property (nonatomic, copy) NSString *shareUrl;

#pragma mark - 自定义字段
//是否收藏
@property (nonatomic, assign) BOOL isCollected;

@end

@implementation SJJSNavActionModel

@end

@interface SJJSPurchaseModel : SPBaseModel

//购买数量
@property (nonatomic, assign) NSInteger commodityCount;
//商品ID
@property (nonatomic, assign) NSInteger commodityId;
//商品名称
@property (nonatomic, copy) NSString *commodityName;
//商品图标
@property (nonatomic, copy) NSString *commodityImage;
//赠送对象id
@property (nonatomic, assign) NSInteger nsjUserId;
//id
@property (nonatomic, assign) NSInteger playerId;
//商品价格
@property (nonatomic, assign) NSInteger price;
//投票数
@property (nonatomic, assign) NSInteger vote;

@end

@implementation SJJSPurchaseModel

@end

@interface SJJSInviteModel : SPBaseModel

@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, strong) JAUserAccount *userInfo;

@end

@implementation SJJSInviteModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"JAUserAccount":@"userInfo"
             };
}

@end

@interface SJDetailController () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>
{
    BOOL _isFinishLoad;
}

@property (nonatomic, strong) UIButton *collectionBtn;
@property (nonatomic, strong) UIButton *enjoyBtn;
@property (nonatomic, weak) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) SJNoDataFootView *noDataView;
//navAction js回调数据
@property (nonatomic, strong) SJJSNavActionModel *navActionModel;
//purchase js回调数据
@property (nonatomic, strong) SJJSPurchaseModel *purchaseModel;
//inviteShare js回调数据
@property (nonatomic, strong) SJJSInviteModel *inviteModel;

//登录成功刷新最新url
@property (nonatomic, copy) NSString *webNewUrl;

@end

@implementation SJDetailController

#pragma mark - lazy loading
- (SJNoDataFootView *)noDataView
{
    if (_noDataView == nil)
    {
        _noDataView = [SJNoDataFootView createCellWithXib];
        _noDataView.exceptionStyle = SJExceptionStyleNoNet;
        _noDataView.backgroundColor = [UIColor whiteColor];
        __weak typeof(self)weakSelf = self;
        _noDataView.buttonView.customButtonClickBlock = ^(UIButton *button) {
          
            NSString *dealedStr = [NSString stringWithFormat:@"%@?timestrump=%@", weakSelf.detailStr, @([[NSDate date] timeIntervalSinceReferenceDate])];
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:dealedStr.mj_url];
            [weakSelf.webView loadRequest:request];
        };
    }
    return _noDataView;
}

- (WKWebView *)webView
{
    if (_webView == nil)
    {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [[WKUserContentController alloc] init];
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 0;
        configuration.preferences = preferences;
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.backgroundColor = JMY_BG_COLOR;
        _webView.scrollView.bounces = NO;
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
//        [self.view insertSubview:_webView belowSubview:self.progressView];
        [self.view insertSubview:_webView aboveSubview:self.progressView];
        
        [_webView.configuration.userContentController addScriptMessageHandler:self name:@"testLogin"];
        [_webView.configuration.userContentController addScriptMessageHandler:self name:@"navAction"];
        [_webView.configuration.userContentController addScriptMessageHandler:self name:@"watchUserImgs"];
        [_webView.configuration.userContentController addScriptMessageHandler:self name:@"purchase"];
        [_webView.configuration.userContentController addScriptMessageHandler:self name:@"myAttention"];
        [_webView.configuration.userContentController addScriptMessageHandler:self name:@"myFans"];
        [_webView.configuration.userContentController addScriptMessageHandler:self name:@"toBuildNote"];
        [_webView.configuration.userContentController addScriptMessageHandler:self name:@"inviteShare"];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleName = @"加载中...";
    if (self.canClose) {
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
        closeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 8, 0);
        closeBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        closeBtn.clipsToBounds = YES;
        [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = self.navigationItem.leftBarButtonItems.firstObject;
        closeBtn.size = CGSizeMake(50, 30);
        self.navigationItem.leftBarButtonItems = @[backItem, [[UIBarButtonItem alloc] initWithCustomView:closeBtn]];
    }
    
    self.enjoyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.enjoyBtn.size = CGSizeMake(50, 30);
    [self.enjoyBtn setImage:[UIImage imageNamed:@"mine_share"] forState:UIControlStateNormal];
    [self.enjoyBtn addTarget:self action:@selector(enjoyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.enjoyBtn.hidden = YES;
    UIBarButtonItem *enjoyItem = [[UIBarButtonItem alloc] initWithCustomView:self.enjoyBtn];
    
    self.collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectionBtn.size = CGSizeMake(50, 30);
    [self.collectionBtn setImage:[UIImage imageNamed:@"activity_collection_nor"] forState:UIControlStateNormal];
    [self.collectionBtn setImage:[UIImage imageNamed:@"activity_collection_sel"] forState:UIControlStateSelected];
    [self.collectionBtn addTarget:self action:@selector(collectionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.collectionBtn.hidden = YES;
    UIBarButtonItem *collectionItem = [[UIBarButtonItem alloc] initWithCustomView:self.collectionBtn];
    if ([WXApi isWXAppInstalled]) {
        self.navigationItem.rightBarButtonItems = @[enjoyItem, collectionItem];
    } else {
        self.navigationItem.rightBarButtonItems = @[collectionItem];
    }
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.progress = 0;
    progressView.trackTintColor = [UIColor whiteColor];
    progressView.progressTintColor = [UIColor colorWithHexString:@"2B3248" alpha:1.0];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    NSString *dealedStr = [NSString stringWithFormat:@"%@&timestrump=%@", self.detailStr, @([[NSDate date] timeIntervalSinceReferenceDate])];
    if (![self.detailStr containsString:@"?"]) {
        dealedStr = [NSString stringWithFormat:@"%@?timestrump=%@", self.detailStr, @([[NSDate date] timeIntervalSinceReferenceDate])];
    }
//    NSString *dealedStr = @"<p>只有证件照能用用</p><img src=\"https://m.niaosiji.com/x/1e/4d/f8/42/f9/a1/eb/4a/5f/10/21/f4/be/f9/29/e9_479e240d9b0f5571.jpeg\"/><p>尴尬了，我要冠军</p><img src=\"https://m.niaosiji.com/x/81/11/35/b3/7d/9f/16/dc/70/6f/0b/64/f7/12/c1/28_wx_camera_1517234448497.jpeg\"/><p>为了冠军我就不要脸了</p>";
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:dealedStr.mj_url];
    [self.webView loadRequest:request];
//    [self.webView loadHTMLString:dealedStr baseURL:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kNotify_loginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseSuccess) name:kNotify_purchaseSuccess object:nil];
}

- (void)closeBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)collectionBtnClick
{
    if (!SPLocalInfo.hasBeenLogin) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_Login_Request
                                                            object:nil];
        return;
    }
    
    if (self.navActionModel.isCollected) {
        
        //取消收藏
        [SVProgressHUD show];
        [JABbsPresenter postUpdateCollection:self.navActionModel.collectionId.integerValue detailId:self.navActionModel.ID.integerValue isDeleted:YES Result:^(JAResponseModel * _Nullable model) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (model.success) {
                    self.collectionBtn.selected = NO;
                    self.navActionModel.isCollected = NO;
                    [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                }
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            });
        }];
    } else {
        [SVProgressHUD show];
        //收藏
        [JABbsPresenter postAddCollection:self.navActionModel.ID.integerValue
                          WithDetailsType:JADetailsTypeActivity
                                   Result:^(JAAddCollectionModel * _Nullable model) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (model.success) {
                    self.navActionModel.collectionId = [[NSString alloc] initWithFormat:@"%ld", model.collectionId];
                    self.collectionBtn.selected = YES;
                    self.navActionModel.isCollected = YES;
                    [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                }
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            });
        }];
    }
}

- (void)enjoyBtnClick
{
    SJShareView *shareView = [SJShareView createCellWithXib];
    shareView.clickBlock = ^(SJShareViewActionType actionType) {
        if ([WXApi isWXAppInstalled]) {
            
            WXMediaMessage *message = [WXMediaMessage message];
            switch (self.navActionModel.type) {
                case SJJSNavActionShareTypeNote:
                {
                    //分享帖子
                    [[NSUserDefaults standardUserDefaults] setValue:@"3" forKey:kSJSharePageKey];
                    message.title = self.navActionModel.name;
                    message.description = @"上车，鸟斯基带你飞";
                    UIImage *iconImage = [UIImage dealImage:[UIImage imageNamed:@"default_portrait"] scaleToSize:CGSizeMake(80, 80)];
                    NSData *iconData = UIImagePNGRepresentation(iconImage);
                    [message setThumbData:iconData];
                    if (!kStringIsEmpty(self.navActionModel.pictureAddress)) {
                        
                        NSData *imageData = [NSData dataWithContentsOfURL:self.navActionModel.pictureAddress.mj_url];
                        UIImage *realImage = [UIImage dealImage:[UIImage imageWithData:imageData] scaleToSize:CGSizeMake(80, 80)];
                        [message setThumbData:UIImagePNGRepresentation(realImage)];
                    }
                }
                    break;
                case SJJSNavActionShareTypeActivity:
                {
                    //分享活动
                    [[NSUserDefaults standardUserDefaults] setValue:@"4" forKey:kSJSharePageKey];
                    message.title = self.navActionModel.name;
                    message.description = @"鸟斯基，玩到青春浪漫时~";
                    UIImage *iconImage = [UIImage dealImage:[UIImage imageNamed:@"default_portrait"] scaleToSize:CGSizeMake(80, 80)];
                    NSData *iconData = UIImagePNGRepresentation(iconImage);
                    [message setThumbData:iconData];
                    if (!kStringIsEmpty(self.navActionModel.pictureAddress)) {
                        
                        NSData *imageData = [NSData dataWithContentsOfURL:self.navActionModel.pictureAddress.mj_url];
                        UIImage *realImage = [UIImage dealImage:[UIImage imageWithData:imageData] scaleToSize:CGSizeMake(80, 80)];
                        [message setThumbData:UIImagePNGRepresentation(realImage)];
                    }
                }
                    break;
                case SJJSNavActionShareTypeMyPage:
                {
                    //分享我的主页
                    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:kSJSharePageKey];
                    message.title = [NSString stringWithFormat:@"%@的鸟斯基个人主页", self.navActionModel.name];
                    message.description = @"傲娇的我，等你来撩~";
                    UIImage *iconImage = [UIImage dealImage:[UIImage imageNamed:@"default_portrait"] scaleToSize:CGSizeMake(80, 80)];
                    NSData *iconData = UIImagePNGRepresentation(iconImage);
                    [message setThumbData:iconData];
                    if (!kStringIsEmpty(self.navActionModel.pictureAddress)) {
                        
                        NSData *imageData = [NSData dataWithContentsOfURL:self.navActionModel.pictureAddress.mj_url];
                        UIImage *realImage = [UIImage dealImage:[UIImage imageWithData:imageData] scaleToSize:CGSizeMake(80, 80)];
                        [message setThumbData:UIImagePNGRepresentation(realImage)];
                    }
                }
                    break;
                case SJJSNavActionShareTypeOtherPage:
                {
                    //分享他人主页
                    [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:kSJSharePageKey];
                    message.title = [NSString stringWithFormat:@"%@的鸟斯基个人主页", self.navActionModel.name];
                    message.description = @"傲娇的我，等你来撩~";
                    UIImage *iconImage = [UIImage dealImage:[UIImage imageNamed:@"default_portrait"] scaleToSize:CGSizeMake(80, 80)];
                    NSData *iconData = UIImagePNGRepresentation(iconImage);
                    [message setThumbData:iconData];
                    if (!kStringIsEmpty(self.navActionModel.pictureAddress)) {
                        
                        NSData *imageData = [NSData dataWithContentsOfURL:self.navActionModel.pictureAddress.mj_url];
                        UIImage *realImage = [UIImage dealImage:[UIImage imageWithData:imageData] scaleToSize:CGSizeMake(80, 80)];
                        [message setThumbData:UIImagePNGRepresentation(realImage)];
                    }
                }
                    break;
                case SJJSNavActionShareTypePlayerDetail:
                {
                    //分享选手详情
                    [[NSUserDefaults standardUserDefaults] setValue:@"5" forKey:kSJSharePageKey];
                    message.title = [NSString stringWithFormat:@"%@参加了世界先生大赛，为他助威吧！",  self.navActionModel.name];
                    message.description = @"新西兰豪华尊享之旅，了解一下！";
                    
                    UIImage *iconImage = [UIImage dealImage:[UIImage imageNamed:@"default_picture"] scaleToSize:CGSizeMake(80, 80)];
                    NSData *iconData = UIImagePNGRepresentation(iconImage);
                    [message setThumbData:iconData];
                    if (!kStringIsEmpty(self.navActionModel.pictureAddress)) {
                        
                        NSData *imageData = [NSData dataWithContentsOfURL:self.navActionModel.pictureAddress.mj_url];
                        UIImage *realImage = [UIImage dealImage:[UIImage imageWithData:imageData] scaleToSize:CGSizeMake(80, 80)];
                        [message setThumbData:UIImagePNGRepresentation(realImage)];
                    }
                }
                    break;
                case SJJSNavActionShareTypeEnroll:
                {
                    //分享报名活动页
                    [[NSUserDefaults standardUserDefaults] setValue:@"6" forKey:kSJSharePageKey];
                    message.title = @"2018世界先生中国区总决赛火热开赛，快来报名吧。";
                    message.description = @"马上参与世界先生大赛，最高500w合约+50w现金奖等你来挑战。";
                    UIImage *iconImage = [UIImage dealImage:[UIImage imageNamed:@"share_worldBoy"] scaleToSize:CGSizeMake(80, 80)];
                    NSData *iconData = UIImagePNGRepresentation(iconImage);
                    [message setThumbData:iconData];
                }
                    break;
                case SJJSNavActionShareTypePrize:
                {
                    //分享抽奖7
                    [[NSUserDefaults standardUserDefaults] setValue:@"7" forKey:kSJSharePageKey];
                    message.title = @"做任务，集鸟蛋，抽大奖！";
                    message.description = @"新西兰豪华尊享之旅，幸运男神眷顾你~";
                    UIImage *iconImage = [UIImage dealImage:[UIImage imageNamed:@"share_prize"] scaleToSize:CGSizeMake(80, 80)];
                    NSData *iconData = UIImagePNGRepresentation(iconImage);
                    [message setThumbData:iconData];
                }
                    break;
                case SJJSNavActionShareTypeMaotai:
                {
                    //分享茅台活动页
                    [[NSUserDefaults standardUserDefaults] setValue:@"8" forKey:kSJSharePageKey];
                    message.title = @"你投票，我送酒";
                    message.description = @"鸟斯基携手茅台助力世界先生大赛，为男神干杯。";
                    UIImage *iconImage = [UIImage dealImage:[UIImage imageNamed:@"share_maotai"] scaleToSize:CGSizeMake(80, 80)];
                    NSData *iconData = UIImagePNGRepresentation(iconImage);
                    [message setThumbData:iconData];
                }
                    break;
                case SJJSNavActionShareTypePlayerList:
                {
                    //分享选手列表页
                    [[NSUserDefaults standardUserDefaults] setValue:@"9" forKey:kSJSharePageKey];
                    message.title = @"2018世界先生中国区总决赛火热进行中";
                    message.description = @"来自于内心深处深藏的阳光热量，总有一款撩爆你的少女心~";
                    UIImage *iconImage = [UIImage dealImage:[UIImage imageNamed:@"share_worldBoy"] scaleToSize:CGSizeMake(80, 80)];
                    NSData *iconData = UIImagePNGRepresentation(iconImage);
                    [message setThumbData:iconData];
                }
                    break;
                case SJJSNavActionShareTypeOther:
                {
                    //未定，其他
                    message.title = self.navActionModel.name;
                    message.description = @"最美自拍，等着你来";
                    
                    UIImage *iconImage = [UIImage dealImage:[UIImage imageNamed:@"default_picture"] scaleToSize:CGSizeMake(80, 80)];
                    NSData *iconData = UIImagePNGRepresentation(iconImage);
                    [message setThumbData:iconData];
                    if (!kStringIsEmpty(self.navActionModel.pictureAddress)) {
                        
                        NSData *imageData = [NSData dataWithContentsOfURL:self.navActionModel.pictureAddress.mj_url];
                        UIImage *realImage = [UIImage dealImage:[UIImage imageWithData:imageData] scaleToSize:CGSizeMake(80, 80)];
                        [message setThumbData:UIImagePNGRepresentation(realImage)];
                    }
                }
                    break;
                default:
                    break;
            }
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = self.navActionModel.shareUrl;
            message.mediaObject = ext;
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            req.scene = actionType==SJShareViewActionTypeCircle?WXSceneTimeline:WXSceneSession;
            [WXApi sendReq:req];
        } else {
            [SVProgressHUD showInfoWithStatus:@"检查是否安装微信"];
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        }
    };
    [shareView show];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([object isEqual:self.webView] && [keyPath isEqualToString:@"estimatedProgress"])
    {
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.progressView.progress == 1.0)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
                self.progressView.progress = 0;
            });
        }
    } else if ([object isEqual:self.webView] && [keyPath isEqualToString:@"title"]) {
        //加载完成再替换
        if (_isFinishLoad) {
            self.titleName = self.webView.title;
        }
    }
}


#pragma mark - WKUIDelegate
- (void)webViewDidClose:(WKWebView *)webView
{
    
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:message message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    self.progressView.hidden = NO;
    if (!_isFinishLoad) {
        [Public showLoadingViewInVc:self];
    }
    if (self.noDataView.superview) {
        [self.noDataView removeFromSuperview];
    }
    
    self.titleName = @"加载中...";
    _isFinishLoad = NO;
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [Public hideLoadingView];
    _isFinishLoad = YES;
    if (!self.noDataView.superview) {
        [self.view insertSubview:self.noDataView aboveSubview:webView];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [Public hideLoadingView];
    //修改字体大小 100%
//    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'" completionHandler:nil];
    //注入JS防止放大代码
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
    NSString *jsStr = [NSString stringWithFormat:@"jsBridgeUtils.saveAuthKey('%@')", SPUserDefault.kLastLoginAuthKey];
    [webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        LogD(@"%@-%@", data, error)
    }];
    _isFinishLoad = YES;
    self.titleName = webView.title;
}


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"testLogin"])
    {
        BOOL isJson = [NSJSONSerialization isValidJSONObject:message.body];
        if (isJson) {
            NSString *jsonBody = message.body;
            NSDictionary *dict = jsonBody.mj_JSONObject;
            NSString *newUrl = dict[@"shareUrl"];
            //去除给我返回的自带authkey
            if ([newUrl containsString:@"authkey="]) {
                NSArray *urlArr = [newUrl componentsSeparatedByString:@"authkey="];
                NSString *restUrl = urlArr[1];
                if ([restUrl containsString:@"&"]) {
                    NSRange range = [restUrl rangeOfString:@"&"];
                    restUrl = [restUrl substringFromIndex:range.location+1];
                }
                self.webNewUrl = [NSString stringWithFormat:@"%@%@", urlArr.firstObject, restUrl];
            } else {
                self.webNewUrl = newUrl;
            }
        }
      
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_Login_Request
                                                                object:nil];
    
    } else if ([message.name isEqualToString:@"navAction"]) {
        
        BOOL isJson = [NSJSONSerialization isValidJSONObject:message.body];
        if (isJson) {
            self.navActionModel = [SJJSNavActionModel mj_objectWithKeyValues:message.body];
            switch (self.navActionModel.status) {
                case SJJSNavActionShowTypeEnjoy:
                {
                    self.enjoyBtn.hidden = NO;
                    self.collectionBtn.hidden = YES;
                }
                    break;
                case SJJSNavActionShowTypeCollection:
                {
                    self.enjoyBtn.hidden = YES;
                    self.collectionBtn.hidden = NO;
                }
                    break;
                case SJJSNavActionShowTypeDouble:
                {
                    self.enjoyBtn.hidden = NO;
                    self.collectionBtn.hidden = NO;
                }
                    break;
                case SJJSNavActionShowTypeNone:
                {
                    self.enjoyBtn.hidden = YES;
                    self.collectionBtn.hidden = YES;
                }
                    break;
                    
                default:
                    break;
            }
            self.collectionBtn.selected = !kStringIsEmpty(self.navActionModel.collectionId);
            self.navActionModel.isCollected = !kStringIsEmpty(self.navActionModel.collectionId);
        }
    } else if ([message.name isEqualToString:@"watchUserImgs"]) {
        
        BOOL isJson = [NSJSONSerialization isValidJSONObject:message.body];
        if (isJson) {
            NSString *jsonBody = message.body;
            NSDictionary *dict = jsonBody.mj_JSONObject;
            SJMyPictureController *pictureVC = [[SJMyPictureController alloc] init];
            if (kObjectIsEmpty(dict[@"id"])) {
                pictureVC.userId = SPLocalInfo.userModel.Id;
            } else {
                pictureVC.userId = [dict[@"id"] integerValue];
            }
            [self.navigationController pushViewController:pictureVC animated:YES];
        }
    } else if ([message.name isEqualToString:@"purchase"]) {
        
        if (![WXApi isWXAppInstalled])
        {
            [SVProgressHUD showInfoWithStatus:@"检查是否安装微信"];
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            return;
        }
        BOOL isJson = [NSJSONSerialization isValidJSONObject:message.body];
        if (isJson) {
            
            [JAConfigPresenter postWXKeyWithResult:^(JAWXKeyModel * _Nullable model) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (model.success) {
                        
                        WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
                        launchMiniProgramReq.userName = model.key;
                        /**
                         NSDictionary *dict = @{
                         @"commodityCount":@(1),
                         @"commodityId":@(100004),
                         @"commodityName":@"鲜花",
                         @"commodityImage":@"https://m.niaosiji.com/x/commodity/gif8.png",
                         @"nsjUserId":@(10000035),
                         @"price":@(41800),
                         @"vote":@(5200),
                         @"authkey":SPUserDefault.kLastLoginAuthKey
                         };
                         NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
                         NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                         NSString *path = [NSString stringWithFormat:@"pages/pay/index?params=%@", json];
                         */
                        
                        self.purchaseModel = [SJJSPurchaseModel mj_objectWithKeyValues:message.body];
                        NSString *jsonBody = message.body;
                        NSDictionary *dict = jsonBody.mj_JSONObject;
                        NSMutableString *path = [NSMutableString stringWithString:@"pages/pay/index?"];
                        for (NSString *key in dict) {
                            
                            NSString *value = dict[key];
                            if ([key isEqualToString:@"commodityImage"]) {
                                value = [value stringByReplacingOccurrencesOfString:@"/" withString:@"\\/"];
                            }
                            [path appendFormat:@"%@=%@&", key, value];
                        }
                        [path appendFormat:@"authkey=%@", SPUserDefault.kLastLoginAuthKey];
                        launchMiniProgramReq.path = path;
                        NSString *programType = JA_SERVER_Program;
                        launchMiniProgramReq.miniProgramType = programType.integerValue;
                        [WXApi sendReq:launchMiniProgramReq];
                    } else {
                        [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                    }
                });
            }];
        } else {
            [SVProgressHUD showInfoWithStatus:@"数据异常"];
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        }
    } else if ([message.name isEqualToString:@"myAttention"]) {
        //去关注列表
        SJConcernViewController *concernVC = [[SJConcernViewController alloc] init];
        concernVC.userId = SPLocalInfo.userModel.Id;
        concernVC.titleName = @"我关注的人";
        [self.navigationController pushViewController:concernVC animated:YES];
    } else if ([message.name isEqualToString:@"myFans"]) {
        //去粉丝列表
        SJFansViewController *fansVC = [[SJFansViewController alloc] init];
        fansVC.titleName = @"我的粉丝";
        fansVC.userId = SPLocalInfo.userModel.Id;
        [self.navigationController pushViewController:fansVC animated:YES];
    } else if ([message.name isEqualToString:@"toBuildNote"]) {
    
        if (!SPLocalInfo.hasBeenLogin) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_Login_Request
                                                                    object:nil];
            
        } else {
            SJBuildNoteController *buildNoteVC = [[SJBuildNoteController alloc] init];
            buildNoteVC.titleName = @"新建帖子";
            [self.navigationController pushViewController:buildNoteVC animated:YES];
        }
    } else if ([message.name isEqualToString:@"inviteShare"]) {
        BOOL isJson = [NSJSONSerialization isValidJSONObject:message.body];
        if (isJson) {
            
            self.inviteModel = [SJJSInviteModel mj_objectWithKeyValues:message.body];
            
            SJShareView *shareView = [SJShareView createCellWithXib];
            shareView.clickBlock = ^(SJShareViewActionType actionType) {
                //分享他人主页
                if ([WXApi isWXAppInstalled]) {
                    
                    WXMediaMessage *message = [WXMediaMessage message];
                    
                    //分享选手详情
                    [[NSUserDefaults standardUserDefaults] setValue:@"5" forKey:kSJSharePageKey];
                    message.title = [NSString stringWithFormat:@"%@参加了世界先生大赛，为他助威吧！",  [self.inviteModel.userInfo getShowNickName]];
                    message.description = @"新西兰豪华尊享之旅，了解一下！";
                    UIImage *iconImage = [UIImage dealImage:[UIImage imageNamed:@"default_portrait"] scaleToSize:CGSizeMake(80, 80)];
                    NSData *iconData = UIImagePNGRepresentation(iconImage);
                    [message setThumbData:iconData];
                    if (!kStringIsEmpty(self.inviteModel.userInfo.avatarUrl)) {
                        NSData *imageData = [NSData dataWithContentsOfURL:self.inviteModel.userInfo.avatarUrl.mj_url];
                        UIImage *realImage = [UIImage dealImage:[UIImage imageWithData:imageData] scaleToSize:CGSizeMake(80, 80)];
                        [message setThumbData:UIImagePNGRepresentation(realImage)];
                    }
                    WXWebpageObject *ext = [WXWebpageObject object];
                    ext.webpageUrl = self.inviteModel.shareUrl;
                    message.mediaObject = ext;
                    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                    req.bText = NO;
                    req.message = message;
                    req.scene = actionType==SJShareViewActionTypeCircle?WXSceneTimeline:WXSceneSession;
                    [WXApi sendReq:req];
                    
                } else {
                    [SVProgressHUD showInfoWithStatus:@"检查是否安装微信"];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                }
            };
            [shareView show];
        }
    }
}

#pragma mark - notification
- (void)loginSuccess
{
//    self.webView = nil;
    
    NSString *jsStr = [NSString stringWithFormat:@"jsBridgeUtils.saveAuthKey('%@')", SPUserDefault.kLastLoginAuthKey];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        LogD(@"%@-%@",  data, error)
    }];
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"jsBridgeUtils.replaceLocation('%@')", self.webNewUrl] completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        LogD(@"%@-%@", data, error)
    }];
    return;
    
    if (!kStringIsEmpty(self.webNewUrl)) {
        NSString *detailStr = [NSString stringWithFormat:@"%@&authkey=%@&timestrump=%@", self.webNewUrl, SPUserDefault.kLastLoginAuthKey, @([[NSDate date] timeIntervalSinceReferenceDate])];
        if (![self.webNewUrl containsString:@"?"]) {

            detailStr = [NSString stringWithFormat:@"%@?authkey=%@", self.webNewUrl, SPUserDefault.kLastLoginAuthKey];
        }
        NSString *jsStr = [NSString stringWithFormat:@"reloadHistory('%@','%@')", detailStr, SPUserDefault.kLastLoginAuthKey];
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
             LogD(@"%@-%@", data, error);
        }];
//        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:detailStr.mj_url];
//        [self.webView loadRequest:request];
    } else {
        NSString *detailStr = [[self.detailStr componentsSeparatedByString:@"authkey="] firstObject];
        NSString *dealedStr = [NSString stringWithFormat:@"%@authkey=%@&timestrump=%@", detailStr, SPUserDefault.kLastLoginAuthKey, @([[NSDate date] timeIntervalSinceReferenceDate])];
        NSString *jsStr = [NSString stringWithFormat:@"reloadHistory('%@','%@')", dealedStr, SPUserDefault.kLastLoginAuthKey];
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
             LogD(@"%@-%@", data, error);
        }];
//        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:dealedStr.mj_url];
//        [self.webView loadRequest:request];
    }
}

- (void)purchaseSuccess
{
//    NSString *purchaseUrl = [NSString stringWithFormat:@"%@/worldBoy/userDetail?authkey=%@&playerId=%zd&purchaseNum=%zd&timestrump=%@", JA_SERVER_WEB, SPUserDefault.kLastLoginAuthKey, self.purchaseModel.playerId, self.purchaseModel.price, @([[NSDate date] timeIntervalSinceReferenceDate])];
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:purchaseUrl.mj_url];
//    [self.webView loadRequest:request];
    NSDictionary *dict = @{
                           @"purchaseNum":@(self.purchaseModel.price),
                           };
    NSString *purchaseUrl = [NSString stringWithFormat:@"%@/worldBoy/userDetail/%zd/%zd?timestrump=%@",  JA_SERVER_WEB, self.purchaseModel.playerId, self.purchaseModel.nsjUserId, @([[NSDate date] timeIntervalSinceReferenceDate])];
    NSString *jsStr = [NSString stringWithFormat:@"jsBridgeUtils.replaceHistory('%@','%@')",  purchaseUrl, dict.mj_JSONString];
    LogD(@"%@", jsStr)
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        
        LogD(@"%@-%@", data, error)
    }];
}

#pragma mark - pop
- (void)popToBack
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
//        [self removeAllMessageHnader];
        if (self.isPresent) {
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        [super popToBack];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
    self.webView.height -= iPhoneX?20:0;
    self.progressView.frame = CGRectMake(0, 0, self.view.width, 5);
    self.noDataView.frame = CGRectMake(0, (self.view.height-350)*0.5-50, self.view.width, 350);
}

- (void)dealloc
{
    @try {
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [self.webView removeObserver:self forKeyPath:@"title"];
    } @catch (NSException *exception) {
        @throw exception;
    }
    [self removeAllMessageHnader];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)removeAllMessageHnader
{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"testLogin"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"navAction"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"watchUserImgs"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"purchase"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"myAttention"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"myFans"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"toBuildNote"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"inviteShare"];
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

@end

