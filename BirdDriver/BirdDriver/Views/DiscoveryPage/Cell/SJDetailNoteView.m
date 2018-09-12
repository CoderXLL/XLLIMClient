//
//  SJDetailNoteView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/8.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJDetailNoteView.h"
#import "GBTagListView.h"
#import "JABBSModel.h"

@interface SJDetailNoteView () <UIWebViewDelegate>
{
    BOOL _isFinishLoad;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eyeLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *phraseLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet GBTagListView *tagView;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SJDetailNoteView

+ (instancetype)createCellWithXib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SJDetailNoteView" owner:nil options:nil] objectAtIndex:0];
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.tagView.deleteHide = YES;
    self.tagView.signalTagColor = [UIColor whiteColor];
    
    self.headBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headBtn.imageView.clipsToBounds = YES;
    
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.scrollEnabled = NO;
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
//    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"] && [object isEqual:self.webView.scrollView])
    {
        CGFloat titleHeight = [self.titleLabel sizeThatFits:CGSizeMake(self.titleLabel.width, MAXFLOAT)].height;
        CGFloat totalHeight = 10+self.webView.scrollView.contentSize.height+20+10+30+15+52+20+15+13+21+titleHeight;
        if (self.heightBlock) {
            self.heightBlock(totalHeight);
        }
    }
}

- (IBAction)headBtnClick:(id)sender {
    if (self.userDetailBlock) {
        self.userDetailBlock(self.detailModel);
    }
}

#pragma mark - setter
- (void)setDetailModel:(JABBSModel *)detailModel
{
    _detailModel = detailModel;
    self.titleLabel.text = detailModel.detail.detailsName;
    self.dateLabel.text = [NSString stringWithFormat:@"发布于%@", [SPDateHandler getTimeLongStringFromTimestamp:detailModel.detail.createTime]];
    [self.headBtn sd_setImageWithURL:detailModel.photoSrc.mj_url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    self.nameLabel.text = detailModel.nickName;
    self.eyeLabel.text = [NSString stringWithFormat:@"%zd", detailModel.detail.pageviews];
    self.collectionLabel.text = [NSString stringWithFormat:@"%zd", detailModel.detail.collections];
    self.phraseLabel.text = [NSString stringWithFormat:@"%zd", detailModel.detail.praises];
    self.messageLabel.text = [NSString stringWithFormat:@"%zd", detailModel.detail.comments];
    NSMutableArray *tagArray = [NSMutableArray arrayWithCapacity:detailModel.detailsLabelsList.count];
    for (NSString *tagStr in detailModel.detailsLabelsList) {
        NSString *dealedStr = [tagStr stringByReplacingOccurrencesOfString:@"#" withString:@""];
        [tagArray addObject:dealedStr];
    }
    [self.tagView setTagWithTagArray:tagArray];
    if (!_isFinishLoad && !kStringIsEmpty(detailModel.detail.detailsText))
    {
        NSString *htmlStr = [NSString stringWithFormat:@"<html> \n"
                             "<head> \n"
                             "<style type=\"text/css\"> \n"
                             "body {font-size:15px;}\n"
                             "img {width:100%%;margin:10px auto;display: block;}\n"
                             "p {line-height: 26px; margin: 5px 0; letter-spacing: 1px; font-size:15px; color:#2B3248}\n"
                             "</style> \n"
                             "</head> \n"
                             "<body>"
                             "%@"
                             "</body>"
                             "</html>", detailModel.detail.detailsText];
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
            CGFloat titleHeight = [self.titleLabel sizeThatFits:CGSizeMake(self.titleLabel.width, MAXFLOAT)].height;
            CGFloat webViewHeight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
            CGFloat totalHeight = 10+webViewHeight+20+10+30+15+52+20+15+13+21+titleHeight;
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
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickImageUrl:AllImageArr:)])
        {
            [self.delegate didClickImageUrl:imageUrl AllImageArr:realArr];
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
    self.webView.delegate = nil;
#ifdef DEBUG
    LogD(@"WebView被销毁")
#endif
//    @try {
//        [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
//    } @catch (NSException *exception) {
//        LogD(@"NSException *exception")
//    }
}


@end
