//
//  SJBindingPhoneController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//
// 绑定手机号

#import "SJBindingPhoneController.h"
#import "UIButton+BACountDown.h"
#import "JAUserPresenter.h"
#import "JASendSMSPresenter.h"
#import "JAImageCodePresenter.h"
#import "SJHotActivityController.h"
#import "JAWXLoginInfoModel.h"
 
#import "SJAlertView.h"

@interface SJBindingPhoneController ()<UITextFieldDelegate>
{
    NSString *_machineToken;
}

@property (weak, nonatomic) IBOutlet SJHotNavgationBar *navigationBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeight;
@property (weak, nonatomic) IBOutlet UIButton *machineBtn;
@property (weak, nonatomic) IBOutlet UITextField *machineField;
@property (weak, nonatomic) IBOutlet UILabel *machineTipLabel;

@end

@implementation SJBindingPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNavgationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    self.mobilePhoneLabel.hidden = YES;
    self.verificationCodeLabel.hidden = YES;
    self.machineTipLabel.hidden = YES;
    [self.machineBtn setAdjustsImageWhenHighlighted:NO];
    self.mobilePhoneTextField.delegate = self;
    self.verificationCodeTextField.delegate = self;
    [self.verificationCodeBtn addTarget:self action:@selector(getVerificationCodeAction) forControlEvents:UIControlEventTouchUpInside];
    self.bindingBtn.customBtnTitle = @"绑定";
    self.bindingBtn.customBtnEnable = NO;
    self.bindingBtn.customBtnGradientColors = @[HEXCOLOR(@"303850"),HEXCOLOR(@"6E7EAF")];
    self.bindingBtn.customBtnTitleColor = HEXCOLOR(@"FFBB04");
    self.bindingBtn.cornerRadius = 20.0f;
    [self getImageCode];
    __weak typeof(self)weakSelf = self;
    [self.bindingBtn customButtonClick:^(UIButton *button) {
        
        weakSelf.wxLoginModel.userAccount.mobilePhone = self.mobilePhoneTextField.text;
        [JAUserPresenter postWXModifyUserInfo:self.wxLoginModel.userAuth.ID smsVerificationCode:self.verificationCodeTextField.text userAccount:self.wxLoginModel.userAccount.mj_keyValues Result:^(JALoginModel * _Nullable model) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (model.success)
                {
                    //发送通知
                    [SPLocalInfoModel shareInstance].hasBeenLogin = YES;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_loginSuccess object:nil];
                    [weakSelf dismissToRootViewController];
                } else {
                    
                    if ([model.responseStatus.code isEqualToString:@"U0024"])
                    {
                        SJAlertModel *sureModel = [[SJAlertModel alloc] initWithTitle:@"继续" handler:^(id content) {
                            
                            [JAUserPresenter postWeiXinChangeTiePhone:self.wxLoginModel.userAuth.ID smsVerificationCode:self.verificationCodeTextField.text userAccount:self.wxLoginModel.userAccount.mj_keyValues Result:^(JALoginModel * _Nullable model) {
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    if (model.success)
                                    {
                                        [SPLocalInfoModel shareInstance].hasBeenLogin = YES;
                                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_loginSuccess object:nil];
                                        [weakSelf dismissToRootViewController];
                                    } else {
                                        [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                                        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                                    }
                                });
                            }];
                        }];
                        SJAlertModel *cancelModel = [[SJAlertModel alloc] initWithTitle:@"取消" handler:^(id content) {
                            
                        }];
                        SJAlertView *alertView = [SJAlertView alertWithTitle:@"该手机已关联了其他微信，继续关联将从原微信解除，是否继续?" message:@"" type:SJAlertShowTypeSubTitle alertModels:@[sureModel, cancelModel]];
                        [alertView showAlertView];
                    } else {
                        
                        weakSelf.verificationCodeLabel.hidden = NO;
                        weakSelf.verificationCodeLabel.text = model.responseStatus.message;
                        [UIView animateWithDuration:1.0 animations:^{
                            weakSelf.verificationCodeLabel.alpha = 0.9;
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionCurveLinear
                                             animations:^{
                                                 weakSelf.verificationCodeLabel.alpha = 0;
                                             }
                                             completion:^(BOOL finished) {
                                                 weakSelf.verificationCodeLabel.alpha = 1.0;
                                                 weakSelf.verificationCodeLabel.hidden = YES;
                                             }];
                        }];
                    }
                }
            });
        }];
    }];
}

-(void)dismissToRootViewController
{
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)machineBtnClick:(id)sender {
    
    [self getImageCode];
}

- (void)getImageCode
{
    [JAImageCodePresenter postGetTokenSuccess:^(id dataObject) {
        
        [JAImageCodePresenter getImagesCode:dataObject[@"Token"] Success:^(id image) {
            [self.machineBtn setImage:image forState:UIControlStateNormal];
            self.machineBtn.imageView.contentMode = UIViewContentModeScaleToFill;
            self.machineBtn.imageView.clipsToBounds = YES;
            self->_machineToken = dataObject[@"Token"];
        } Failure:^(NSError *error) {
            [self.machineBtn setImage:[UIImage imageNamed:@"renovate_icon"] forState:UIControlStateNormal];
            self.machineBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            self.machineBtn.imageView.clipsToBounds = YES;
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        }];
    } Failure:^(NSError *error) {
        [self.machineBtn setImage:[UIImage imageNamed:@"renovate_icon"] forState:UIControlStateNormal];
        self.machineBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.machineBtn.imageView.clipsToBounds = YES;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
    }];
}


-(void)getVerificationCodeAction{
    if (self.mobilePhoneTextField.text.length > 0) {
        [JASendSMSPresenter postSendSMS:self.mobilePhoneTextField.text WithSmsCodeType:SmsCodeTypeForgetPwd WithToken:_machineToken WithCode:self.machineField.text Result:^(JAResponseModel * _Nullable model) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(model.success){
                    [self.verificationCodeBtn startWithTime:60 title:@"获取验证码" countDownTitle:@"s" mainColor:HEXCOLOR(@"FFBB04") countColor:HEXCOLOR(@"DCDCDC")];
                } else {
                    if ([model.responseStatus.code isEqualToString:@"WA00006"]) {
                        self.machineTipLabel.text = model.responseStatus.message;
                        self.machineTipLabel.hidden = NO;
                        [UIView animateWithDuration:1.0 animations:^{
                            self.machineTipLabel.alpha = 0.9;
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionCurveLinear
                                             animations:^{
                                                 self.machineTipLabel.alpha = 0;
                                             }
                                             completion:^(BOOL finished) {
                                                 self.machineTipLabel.alpha = 1.0;
                                                 self.machineTipLabel.hidden = YES;
                                             }];
                        }];
                    } else {
                        [SVProgressHUD showInfoWithStatus:model.responseStatus.message];
                        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                    }
                }
            });
        }];
    }
}

- (void)setupNavgationBar {
    self.navigationBar.titleName = self.titleName;
    self.navigationBar.navgationBarStyle = SJHotNavgationBarStyleNone;
    self.navigationBar.backgroundColor = [UIColor whiteColor];
    __weak typeof(self)weakSelf = self;
    self.navigationBar.clickBlock = ^(BOOL isBack) {
        
        if (isBack) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    };
    self.navigationBarHeight.constant = kNavBarHeight;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.mobilePhoneTextField]) {
        self.mobilePhoneLine.backgroundColor = HEXCOLOR(@"FFBB04");
    } else {
        self.mobilePhoneLine.backgroundColor = HEXCOLOR(@"ECECEC");
    }
    
    if ([textField isEqual:self.verificationCodeTextField]) {
        self.verificationCodeLine.backgroundColor = HEXCOLOR(@"FFBB04");
    } else {
        self.verificationCodeLine.backgroundColor = HEXCOLOR(@"ECECEC");
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.mobilePhoneLine.backgroundColor = HEXCOLOR(@"ECECEC");
    self.verificationCodeLine.backgroundColor = HEXCOLOR(@"ECECEC");
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self setButtonState];
}

- (void) setButtonState{
    if (self.mobilePhoneTextField.text.length > 0 && self.verificationCodeTextField.text.length > 0) {
        self.bindingBtn.customBtnEnable = YES;
        self.bindingBtn.customBtnTitleColor = HEXCOLOR(@"FFBB04");
    } else {
        self.bindingBtn.customBtnEnable = NO;
        self.bindingBtn.customBtnTitleColor = [UIColor whiteColor];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
