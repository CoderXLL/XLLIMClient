//
//  SJBindingPhoneController.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPViewController.h"
#import "SPCustomButtonView.h"

@class JAWXLoginInfoModel;
@interface SJBindingPhoneController : SPViewController

@property (weak, nonatomic) IBOutlet UITextField *mobilePhoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *mobilePhoneLine;
@property (weak, nonatomic) IBOutlet UILabel *mobilePhoneLabel;


@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *verificationCodeLine;
@property (weak, nonatomic) IBOutlet UILabel *verificationCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *verificationCodeBtn;

@property (weak, nonatomic) IBOutlet SPCustomButtonView *bindingBtn;

@property (nonatomic, strong) JAWXLoginInfoModel *wxLoginModel;

@end
