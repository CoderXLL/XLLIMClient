//
//  SJAuthenticateViewController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//
// 修改绑定手机号第一步--验证手机号

#import "SJAuthenticateViewController.h"
#import "SJChangePhoneViewController.h"
#import "JAUserPresenter.h"

@interface SJAuthenticateViewController ()

@end

@implementation SJAuthenticateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.numberLabel.text = [NSString stringWithFormat:@"+86 %@", [SPStringHandler replacingPhoneNumCharacters:SPLocalInfo.userModel.mobilePhone]];
    self.nextBtn.customBtnTitle = @"下一步";
    self.nextBtn.customBtnEnable = YES;
    self.nextBtn.customBtnGradientColors = @[HEXCOLOR(@"303850"),HEXCOLOR(@"6E7EAF")];
    self.nextBtn.customBtnTitleColor = HEXCOLOR(@"FFBB04");
    self.nextBtn.cornerRadius = 22.0f;
    [self.nextBtn customButtonClick:^(UIButton *button) {
        if (self.phoneTextField.text.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            return ;
        }
        [JAUserPresenter postOldPhoneCheck:self.phoneTextField.text Result:^(JAResponseModel * _Nullable model) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(model.success){
                    SJChangePhoneViewController *changePhoneVC = [[SJChangePhoneViewController alloc] init];
                    changePhoneVC.titleName = @"修改手机号";
                    [self.navigationController pushViewController:changePhoneVC animated:YES];
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                }
            });
        }];
    }];
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
