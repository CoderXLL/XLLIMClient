//
//  SJChangePhoneViewController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//
// 修改绑定手机号

#import "SJChangePhoneViewController.h"
#import "UIButton+BACountDown.h"
#import "JAUserPresenter.h"
#import "JASendSMSPresenter.h"
#import "JAImageCodePresenter.h"
 

@interface SJChangePhoneViewController ()<UITextFieldDelegate>
{
    NSString *_machineToken;
}

@end

@implementation SJChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.phoneTextField.delegate = self;
    self.graphicVerificationCodeTextField.delegate = self;
    self.verificationCodeTextField.delegate = self;
    [self.verificationCodeBtn addTarget:self action:@selector(getVerificationCodeAction) forControlEvents:UIControlEventTouchUpInside];

    self.bindingPhoneBtn.customBtnTitle = @"立即绑定";
    self.bindingPhoneBtn.customBtnEnable = NO;
    self.bindingPhoneBtn.customBtnGradientColors = @[HEXCOLOR(@"303850"),HEXCOLOR(@"6E7EAF")];
    self.bindingPhoneBtn.customBtnTitleColor = HEXCOLOR(@"FFBB04");
    self.bindingPhoneBtn.cornerRadius = 20.0f;
    [self.bindingPhoneBtn customButtonClick:^(UIButton *button) {
        self.graphicVerificationCodeLabel.text = @"";
        [JAUserPresenter postChangePhone:self.phoneTextField.text VerifyCode:self.verificationCodeTextField.text Result:^(JAResponseModel * _Nullable model) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(model.success){
                    [SVProgressHUD showSuccessWithStatus:@"修改绑定手机号成功"];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                    SPLocalInfo.userModel.mobilePhone = self.phoneTextField.text;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                } else {
                    [SVProgressHUD showSuccessWithStatus:model.responseStatus.message];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                    self.verificationCodeLabel.text = model.responseStatus.message;
                }
            });
        }];
    }];
    [self getMachineVerifyImage];
}

- (void)getMachineVerifyImage
{
    [JAImageCodePresenter postGetTokenSuccess:^(id dataObject) {
        
        self->_machineToken = dataObject[@"Token"];
        [JAImageCodePresenter getImagesCode:dataObject[@"Token"] Success:^(id dataObject) {
            
            [self.graphicVerificationCodeBtn setImage:dataObject forState:UIControlStateNormal];
        } Failure:^(NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        }];
    } Failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
    }];
}

- (IBAction)graphicCodeBtnClick:(id)sender {
    
    [self getMachineVerifyImage];
}

-(void)getVerificationCodeAction{
    if (self.phoneTextField.text.length > 0) {
        [JASendSMSPresenter postSendSMS:self.phoneTextField.text WithSmsCodeType:SmsCodeTypeForgetPwd WithToken:_machineToken WithCode:self.graphicVerificationCodeTextField.text Result:^(JAResponseModel * _Nullable model) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(model.success){
                    [self.verificationCodeBtn startWithTime:60 title:@"获取验证码" countDownTitle:@"s" mainColor:HEXCOLOR(@"FFBB04") countColor:HEXCOLOR(@"FFBB04")];
                } else {
                    [SVProgressHUD showInfoWithStatus:model.responseStatus.message];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                }
            });
        }];
    }
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.graphicVerificationCodeTextField]) {
        self.graphicVerificationCodeLabel.text = @"";
    }else if ([textField isEqual:self.verificationCodeTextField]) {
        self.verificationCodeLabel.text = @"";
    }
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self setButtonState];
}

- (void) setButtonState{
    if (self.phoneTextField.text.length > 0 && self.graphicVerificationCodeTextField.text.length > 0 && self.verificationCodeTextField.text.length > 0) {
        self.bindingPhoneBtn.customBtnEnable = YES;
        self.bindingPhoneBtn.customBtnTitleColor = HEXCOLOR(@"FFBB04");
    } else {
        self.bindingPhoneBtn.customBtnEnable = NO;
        self.bindingPhoneBtn.customBtnTitleColor = [UIColor whiteColor];
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

@end
