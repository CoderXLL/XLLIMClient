//
//  SJNoviceGuideStep1Controller.m
//  BirdDriver
//
//  Created by Soul on 2018/8/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJNoviceGuideStep1Controller.h"
#import "SJNoviceGuideStep2Controller.h"
#import "SJGradientButton.h"
#import "JAUserPresenter.h"

@interface SJNoviceGuideStep1Controller ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tf_nickName;
@property (weak, nonatomic) IBOutlet SJGradientButton *nextBtn;

@end

@implementation SJNoviceGuideStep1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"新手引导";
    self.view.backgroundColor = SP_WHITE_COLOR;
    self.nextBtn.enabled = NO;
    [self.tf_nickName addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO
                                             animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //昵称限制12个字
    NSString *finanlText = textField.text;
    finanlText = [finanlText stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (textField.text.length+string.length>12) {
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidChanged:(UITextField *)textField
{
    self.nextBtn.enabled = !kStringIsEmpty(textField.text);
}

- (IBAction)nextAction:(id)sender {
    
    
    
    [JAUserPresenter postUpdateUserInfo:SPLocalInfo.userModel.Id
                          WithAvatarUrl:nil
                           WithNickname:self.tf_nickName.text
                            WithAddress:nil
                              WithEmail:nil
                                WithSex:nil
                       WithPersonalSign:nil
                                 WithQq:nil
                             WithWechat:nil
                            WithHobbies:nil
                                 Result:^(JAResponseModel * _Nullable model) {
                                     if (model.success) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             SJNoviceGuideStep2Controller *vc = [[SJNoviceGuideStep2Controller alloc] initWithNibName:@"SJNoviceGuideStep2Controller" bundle:nil];
                                         
                                             [self showViewController:vc
                                                                                    sender:nil];
                                         });
                                     }else{
                                         [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                                         [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                                     }
                                 }];
}


@end
