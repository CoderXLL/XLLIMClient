//
//  SJRealNameViewController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//
// 实名认证

#import "SJRealNameViewController.h"
#import "UIImage+ColorsImage.h"
#import "JAUserPresenter.h"

@interface SJRealNameViewController ()<UITextFieldDelegate>

@end

@implementation SJRealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.alertLabel.hidden = YES;
    self.nameTextField.delegate = self;
    self.idNumberTextField.delegate = self;
    self.nameTextField.tag = 0;
    self.idNumberTextField.tag = 1;
    
    self.sureBtn.customBtnTitle = @"提交";
    self.sureBtn.customBtnEnable = NO;
    self.sureBtn.customBtnGradientColors = @[HEXCOLOR(@"303850"),HEXCOLOR(@"6E7EAF")];
    self.sureBtn.customBtnTitleColor = HEXCOLOR(@"FFBB04");
    self.sureBtn.cornerRadius = 22.0f;
    [self.sureBtn customButtonClick:^(UIButton *button) {
        [JAUserPresenter postAuthRealName:self.nameTextField.text IdCardNum:self.idNumberTextField.text Result:^(JAResponseModel * _Nullable model) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(model.success){
                    [SVProgressHUD showSuccessWithStatus:@"实名认证成功"];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                    SPLocalInfo.userModel.isIdentityVerified = YES;
                    SPLocalInfo.userModel.realName = self.nameTextField.text;
                    SPLocalInfo.userModel.identityCard = self.idNumberTextField.text;
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                    self.alertLabel.hidden = NO;
                    self.alertLabel.text = model.responseStatus.message;
                }
            });
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self setButtonState];
}

- (void) setButtonState{
    if (self.nameTextField.text.length > 0 && self.idNumberTextField.text.length > 0) {
        self.sureBtn.customBtnEnable = YES;
        self.sureBtn.customBtnTitleColor = HEXCOLOR(@"FFBB04");
    } else {
        self.sureBtn.customBtnEnable = NO;
        self.sureBtn.customBtnTitleColor = [UIColor whiteColor];
    }
}

@end
