//
//  SJLoginController.m
//  BirdDriver
//
//  Created by Soul on 2018/5/16.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SJLoginController.h"
#import "SJTabBarController.h"
#import "SJDetailController.h"
#import "SJBindingPhoneController.h"
#import "SJNoviceGuideStep1Controller.h"

#import "SJGradientButton.h"
#import "JAUserPresenter.h"
#import "JASendSMSPresenter.h"
#import "JAImageCodePresenter.h"
 
#import "SJNavController.h"
#import "SJWXSDKManager.h"

@interface SJLoginController () <UITextFieldDelegate, UIScrollViewDelegate>
{
    //GCD定时器
    dispatch_source_t _mTimer;
    NSString *_machineToken;
}

//整体滑动视图
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//滑动视图contentSize.height
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentHeight;
@property (weak, nonatomic) IBOutlet UIView *iconView;
@property (weak, nonatomic) IBOutlet SJGradientButton *phoneCodeBtn;

//手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
//手机号下划线
@property (weak, nonatomic) IBOutlet UIView *phoneLine;
//机器验证码
@property (weak, nonatomic) IBOutlet UITextField *machineField;
@property (weak, nonatomic) IBOutlet UIImageView *machineView;

//机器验证码下划线
@property (weak, nonatomic) IBOutlet UIView *machineLine;
//获取验证码按钮
@property (weak, nonatomic) IBOutlet UITextField *phoneCodeField;
@property (weak, nonatomic) IBOutlet UIView *phoneCodeLine;
@property (weak, nonatomic) IBOutlet SJGradientButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *tipBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

//三方登录描述
@property (weak, nonatomic) IBOutlet UILabel *libDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *wxLoginBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipLabelTopCons;

@end

@implementation SJLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//
    self.view.backgroundColor = [UIColor whiteColor];
    self.loginBtn.enabled = NO;
    self.tipBtn.titleLabel.numberOfLines = 0;
    [self.phoneField becomeFirstResponder];
    NSString *originStr = @"登录前请您认真阅读并同意《用户协议》";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:originStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attr addAttribute:NSParagraphStyleAttributeName
                 value:paragraphStyle
                 range:NSMakeRange(0, originStr.length)];
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"2B3248"
                                                                               alpha:1.0],
                          NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                          NSUnderlineColorAttributeName:[UIColor colorWithHexString:@"2B3248"
                                                                              alpha:1.0]}
                  range:[originStr rangeOfString:@"《用户协议》"]];
    [self.tipBtn setAttributedTitle:attr forState:UIControlStateNormal];
//    self.iconView.layer.cornerRadius = 2.0;
//    self.iconView.layer.borderWidth = 1.0;
//    self.iconView.layer.borderColor = [UIColor colorWithHexString:@"DCDCDC" alpha:1.0].CGColor;
    self.phoneCodeBtn.isLogin = YES;
    self.phoneCodeBtn.enabled = NO;
    
    if (![WXApi isWXAppInstalled]) {
        self.scrollContentHeight.constant = kScreenWidth*135/375.0+435+30;
        self.tipLabelTopCons.constant = 50;
        self.wxLoginBtn.hidden = YES;
        self.libDescLabel.hidden = YES;
    } else {
    
        self.scrollContentHeight.constant = kScreenWidth*135/375.0+425+30+12+70+30;
        self.tipLabelTopCons.constant = 147;
        self.wxLoginBtn.hidden = NO;
        self.libDescLabel.hidden = NO;
    }
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(tapGestureClick:)];
    self.machineView.userInteractionEnabled = YES;
    [self.machineView addGestureRecognizer:tapGesture];
    
    [self getMachineImage];
    
    [SJStatisticEventTool umengEvent:Nsj_Event_LR
                               NsjId:@"10010000"
                             NsjName:@"进入登录页面"];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES
                                             animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO
                                             animated:YES];
}

- (void)getMachineImage
{
    __weak typeof(self)weakSelf = self;
    [JAImageCodePresenter postGetTokenSuccess:^(id dataObject) {
        
        [JAImageCodePresenter getImagesCode:dataObject[@"Token"]
                                    Success:^(id image) {
            weakSelf.machineView.image = image;
            weakSelf.machineView.contentMode = UIViewContentModeScaleToFill;
            self->_machineToken = dataObject[@"Token"];
        }
                                    Failure:^(NSError *error) {
            weakSelf.machineView.image = [UIImage imageNamed:@"renovate_icon"];
            weakSelf.machineView.contentMode = UIViewContentModeScaleAspectFit;
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        }];
    }
     
                                      Failure:^(NSError *error) {
        weakSelf.machineView.image = [UIImage imageNamed:@"renovate_icon"];
        weakSelf.machineView.contentMode = UIViewContentModeScaleAspectFit;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
    }];
}

- (void)tapGestureClick:(UITapGestureRecognizer *)tapGesture
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [self getMachineImage];
}

- (IBAction)changeEnv:(id)sender {
    
//    UIAlertAction *
}

- (IBAction)agreeBtnClick:(id)sender {
    
    self.agreeBtn.selected = !self.agreeBtn.selected;
//    self.loginBtn.enabled = !kStringIsEmpty(self.phoneField.text) && !kStringIsEmpty(self.machineField.text) && !kStringIsEmpty(self.phoneCodeField.text);
    
    [SJStatisticEventTool umengEvent:Nsj_Event_LR
                               NsjId:@"10010401"
                             NsjName:@"点击同意注册协议"];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - event
- (IBAction)tipBtnClick:(id)sender {
    SJDetailController *detailVC = [[SJDetailController alloc] init];
    detailVC.detailStr = [NSString stringWithFormat:@"%@/serviceArgement", JA_SERVER_WEB];
    SJNavController *nav = [[SJNavController alloc] initWithRootViewController:detailVC];
    detailVC.isPresent = YES;
    [self presentViewController:nav animated:YES completion:nil];
    
    [SJStatisticEventTool umengEvent:Nsj_Event_LR
                               NsjId:@"10010400"
                             NsjName:@"点击查看注册协议"];
}

- (IBAction)backBtnClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)phoneCodeBtnClick:(UIButton *)sender {
    [self getSmsCode];
    
    [SJStatisticEventTool umengEvent:Nsj_Event_LR
                               NsjId:@"10010300"
                             NsjName:@"注册获取手机验证码"];
}

//微信登录
- (IBAction)wechatBtnClick:(id)sender {
    [SJStatisticEventTool umengEvent:Nsj_Event_LR
                               NsjId:@"10010501"
                             NsjName:@"点击微信登录"];
    
    if (!self.agreeBtn.selected) {
        
        [SVProgressHUD showInfoWithStatus:@"请阅读并勾选鸟斯基用户协议"];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default*2.2];
        return;
    }
    __weak typeof(self)weakSelf = self;
    [[SJWXSDKManager shareWXSDKManager] WXAuthorizationRequestWithVC:self
                                                          WxCallBack:^(NSString *wxCode) {
        
        //调用本公司接口去登录
        [JAUserPresenter postGetWXLoginInfoWithCode:wxCode
                                             Result:^(JAWXLoginInfoModel * _Nullable model) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (model.success) {
                    if (!model.canYouLogin) {
                        //跳到绑定手机号页面
                        SJBindingPhoneController *bindVC = [[SJBindingPhoneController alloc] init];
                        bindVC.titleName = @"绑定手机";
                        bindVC.wxLoginModel = model;
                        [weakSelf presentViewController:bindVC animated:YES completion:nil];
                    } else {
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default*1.5];
                }
            });
        }];
    }];
}

- (IBAction)loginBtnClick:(id)sender {
    [SJStatisticEventTool umengEvent:Nsj_Event_LR
                               NsjId:@"10010500"
                             NsjName:@"点击登录按钮"];
    
    if (!self.agreeBtn.selected) {
        [SVProgressHUD showInfoWithStatus:@"请阅读并勾选鸟斯基用户协议"];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default*2.2];
        return;
    }
    
    [JAUserPresenter postLoginAccount:self.phoneField.text
                          WithSmsCode:self.phoneCodeField.text
                               Result:^(JALoginModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (model.success)
            {
                NSString *nickName = model.userAccount.nickName;
             
                BOOL isRequired = kStringIsEmpty(nickName);
                [self determineNoviceGuidanceIsRequired:isRequired];
            } else {
                //弹窗提示登录失败
                if ([model.responseStatus.code isEqualToString:@"UA00008"]) {
                    [SVProgressHUD showErrorWithStatus:@"手机验证码不正确"];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                    return ;
                }
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            }
        });
    }];
}

//判断是否需要新手引导
- (void)determineNoviceGuidanceIsRequired:(BOOL)isRequired{
       WEAKSELF
    if (isRequired) {
        //进入新手引导
        [weakSelf pushToNoviceGuidance];
    }else{
        //发送通知
        [SPLocalInfoModel shareInstance].hasBeenLogin = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_loginSuccess
                                                            object:nil];
        [weakSelf dismissViewControllerAnimated:YES
                                     completion:nil];
    }
}

- (void)pushToNoviceGuidance{
    SJNoviceGuideStep1Controller *vc = [[SJNoviceGuideStep1Controller alloc] initWithNibName:@"SJNoviceGuideStep1Controller" bundle:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showViewController:vc
                                               sender:nil];
    });
    
}

- (void)startTimer
{
    __block NSInteger mCountdownTimer = 60;
    __weak typeof(self) weakSelf = self;
    self.phoneCodeBtn.enabled = NO;
    _mTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
                                     dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    
    dispatch_source_set_timer(_mTimer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_mTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.phoneCodeBtn setTitle:[NSString stringWithFormat:@"%zds",mCountdownTimer--]
                               forState:UIControlStateDisabled];
            if (mCountdownTimer) return;
            //1秒后停止计时
            [weakSelf stopTime];
        });
    });
    dispatch_resume(_mTimer);
}

- (void)stopTime
{
    dispatch_source_cancel(_mTimer);
    self.phoneCodeBtn.enabled = YES;
    [self.phoneCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
}

- (void)getSmsCode
{
    __weak typeof(self)weakSelf = self;
    [JASendSMSPresenter postSendSMS:self.phoneField.text
                    WithSmsCodeType:SmsCodeTypeLogin
                          WithToken:_machineToken
                           WithCode:self.machineField.text
                             Result:^(JAResponseModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (model.success)
            {
                [weakSelf startTimer];
            } else {
                //失败..
                if ([model.responseStatus.code isEqualToString:@"UA00008"]) {
                    self.tipCodeLabel.hidden = NO;
                    [UIView animateWithDuration:1.0 animations:^{
                        self.tipCodeLabel.alpha = 0.9;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionCurveLinear
                                         animations:^{
                                             weakSelf.tipCodeLabel.alpha = 0;
                                         }
                                         completion:^(BOOL finished) {
                                             weakSelf.tipCodeLabel.alpha = 1.0;
                                             weakSelf.tipCodeLabel.hidden = YES;
                                         }];
                    }];
                    return ;
                }
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            }
        });
    }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.phoneField)
    {
        self.phoneLine.backgroundColor = [UIColor colorWithHexString:@"FFBB04" alpha:1.0];
    } else if (textField == self.machineField) {
        self.machineLine.backgroundColor = [UIColor colorWithHexString:@"FFBB04" alpha:1.0];
    } else if (textField == self.phoneCodeField) {
        self.phoneCodeLine.backgroundColor = [UIColor colorWithHexString:@"FFBB04" alpha:1.0];
    }
}

- (IBAction)textFieldDidChange:(id)sender {
    
    self.loginBtn.enabled = !kStringIsEmpty(self.phoneField.text) && !kStringIsEmpty(self.machineField.text) && !kStringIsEmpty(self.phoneCodeField.text);
    if ([self.phoneCodeBtn.titleLabel.text isEqualToString:@"获取验证码"]) {
        self.phoneCodeBtn.enabled = !kStringIsEmpty(self.phoneField.text) && !kStringIsEmpty(self.machineField.text);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.phoneField)
    {
        self.phoneLine.backgroundColor = [UIColor colorWithHexString:@"ECECEC" alpha:1.0];
    } else if (textField == self.machineField) {
        self.machineLine.backgroundColor = [UIColor colorWithHexString:@"ECECEC" alpha:1.0];
    } else if (textField == self.phoneCodeField) {
        self.phoneCodeLine.backgroundColor = [UIColor colorWithHexString:@"ECECEC" alpha:1.0];
    }
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end

