//
//  SJChangePhoneViewController.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPViewController.h"
#import "SPCustomButtonView.h"

@interface SJChangePhoneViewController : SPViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *graphicVerificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *graphicVerificationCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *graphicVerificationCodeLabel;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *verificationCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *verificationCodeLabel;
@property (weak, nonatomic) IBOutlet SPCustomButtonView *bindingPhoneBtn;



@end
