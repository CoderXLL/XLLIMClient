//
//  XLLLoginController.m
//  XLLIMChat
//
//  Created by 肖乐 on 2018/4/3.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import "XLLLoginController.h"
#import "XLLBGVideoView.h"
#import "XLLTabBarController.h"
#import "UITextField+XLLLimit.h"

@interface XLLLoginController () <UITextFieldDelegate>

@property (nonatomic, assign) BOOL isFinishAccount;
@property (weak, nonatomic) IBOutlet XLLBGVideoView *videoView;
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation XLLLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    XLLTextConfig *fieldConfig = [[XLLTextConfig alloc] init];
    fieldConfig.maxLimitCount = 11;
    fieldConfig.leftMargin = 0.0;
    self.accountField.fieldConfig = fieldConfig;
    self.accountField.delegate = self;
    
    [self.accountField addObserver:self forKeyPath:@"isGetMaxLimit" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.videoView startToPlay];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.videoView stopPlay];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([object isEqual:self.accountField] && [keyPath isEqualToString:@"isGetMaxLimit"])
    {
        self.isFinishAccount = self.accountField.isGetMaxLimit;
        self.loginButton.enabled = self.accountField.isGetMaxLimit && !IsEmptyValue(self.passwordField.text);
    }
}

- (IBAction)loginBtnClick:(id)sender {
    
//    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
//    EMError *error = [[EMClient sharedClient] loginWithUsername:self.accountField.text password:self.passwordField.text];
//    CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
//    XLLLog(@"%lf秒", endTime - startTime);
//    if (!error) {
    
        XLLTabBarController *tabBarVC = [[XLLTabBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
//        return;
//    }
}

- (IBAction)registerBtnClick:(id)sender {
    
}

- (IBAction)passwordFieldDidChange:(id)sender {
    
    self.loginButton.enabled = self.isFinishAccount && !IsEmptyValue(self.passwordField.text);
}

- (void)dealloc
{
    XLLLog(@"我被销毁了")
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
