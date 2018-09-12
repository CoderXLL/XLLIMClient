//
//  SJBindingWeChatViewController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//
// 绑定微信

#import "SJBindingWeChatViewController.h"
#import "SJWXSDKManager.h"
#import "JAUserPresenter.h"

@interface SJBindingWeChatViewController ()

@end

@implementation SJBindingWeChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bindingWeChatBtn.customBtnTitle = @"绑定微信";
    self.bindingWeChatBtn.customBtnEnable = YES;
    self.bindingWeChatBtn.customBtnGradientColors = @[HEXCOLOR(@"303850"),HEXCOLOR(@"6E7EAF")];
    self.bindingWeChatBtn.customBtnTitleColor = HEXCOLOR(@"FFBB04");
    self.bindingWeChatBtn.cornerRadius = 22.0f;
    __weak typeof(self)weakSelf = self;
    [self.bindingWeChatBtn customButtonClick:^(UIButton *button) {
         LogD(@"绑定微信");
        [[SJWXSDKManager shareWXSDKManager] WXAuthorizationRequestWithVC:self WxCallBack:^(NSString *wxCode) {
            
            //绑定微信接口
            [JAUserPresenter postBindWeChat:wxCode Result:^(JAResponseModel * _Nullable model) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (model.success) {
                        [SVProgressHUD showSuccessWithStatus:@"绑定微信成功"];
                        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                        
                        SPLocalInfo.userModel.whetherToBindWeiXin = YES;
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    } else {
                        [SVProgressHUD showSuccessWithStatus:model.responseStatus.message];
                        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default*3];
                    }
                });
            }];
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
