//
//  SJNoviceGuideStep2Controller.m
//  BirdDriver
//
//  Created by Soul on 2018/8/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJNoviceGuideStep2Controller.h"

#import "SJNoviceGuideStep3Controller.h"
#import "SJNoviceGuideStep4Controller.h"

#import <PGDatePicker/PGDatePickManager.h>
#import <PGDatePicker/PGDatePicker.h>
#import "SJGradientButton.h"

#import "JAUserPresenter.h"

@interface SJNoviceGuideStep2Controller ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btn_male;
@property (weak, nonatomic) IBOutlet UIButton *btn_female;

@property (weak, nonatomic) IBOutlet UITextField *tf_year;
@property (weak, nonatomic) IBOutlet UITextField *tf_month;
@property (weak, nonatomic) IBOutlet UITextField *tf_day;
@property (weak, nonatomic) IBOutlet UITextField *tf_brief;
@property (weak, nonatomic) IBOutlet SJGradientButton *nextBtn;


//@property (strong, nonatomic) NSDateComponents *birthComponents;

@end

@implementation SJNoviceGuideStep2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个人信息设置";
    self.nextBtn.enabled = NO; self.view.backgroundColor = SP_WHITE_COLOR;
    [self.tf_brief addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //TODO: 页面appear 禁用
    [IQKeyboardManager sharedManager] .previousNextDisplayMode = IQPreviousNextDisplayModeAlwaysHide;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //TODO: 页面Disappear 启用
    [IQKeyboardManager sharedManager] .previousNextDisplayMode = IQPreviousNextDisplayModeDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)textFieldDidChanged:(UITextField *)textField
{
    self.nextBtn.enabled = !kStringIsEmpty(textField.text);
}

- (IBAction)nextAction:(id)sender {
    {
        NSDate *birthday = [NSDate setYear:self.tf_year.text.integerValue
                                     month:self.tf_month.text.integerValue
                                       day:self.tf_day.text.integerValue
                                      hour:8
                                    minute:0];
        NSTimeInterval birthdayTime = [birthday timeIntervalSince1970];
        
        [JAUserPresenter postUpdateUserInfo:SPLocalInfo.userModel.Id
                               WithNickname:nil
                               WithBirthDay:birthdayTime
                                    WithSex:self.btn_male.isSelected?@"1":@"0"
                           WithPersonalSign:self.tf_brief.text
                                     Result:^(JAResponseModel * _Nullable model) {
                                         if (model.success) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 SJNoviceGuideStep4Controller *vc = [[SJNoviceGuideStep4Controller alloc] init];
                                                 [self showViewController:vc
                                                                                        sender:nil];
                                             });
                                         }else{
                                             [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                                             [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                                         }
                                     }];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField == self.tf_brief){
        return YES;
    }else{
        [self setupChoseBirth];
        return NO;
    }
}

- (void)setupChoseBirth{
    LogD(@"唤起生日选择器");
    [self.view endEditing:YES];
    [self.tf_brief resignFirstResponder];
    [self.tf_year resignFirstResponder];
    [self.tf_month resignFirstResponder];
    [self.tf_day resignFirstResponder];
    
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackgroud = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.datePickerType = PGPickerViewType1;
    datePicker.isHiddenMiddleText = false;
    datePicker.datePickerMode = PGDatePickerModeDate;
    datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
    datePicker.maximumDate = [NSDate date];
    
//    //设置线条的颜色
//    datePicker.lineBackgroundColor = [UIColor redColor];
//    //设置选中行的字体颜色
//    datePicker.textColorOfSelectedRow = [UIColor redColor];
//    //设置取消按钮的字体颜色
//    datePickManager.cancelButtonTextColor = [UIColor blackColor];
//    //设置确定按钮的字体颜色
//    datePickManager.confirmButtonTextColor = [UIColor redColor];
    WEAKSELF
    datePicker.selectedDate = ^(NSDateComponents *dateComponents) {
        LogD(@"dateComponents = %@", dateComponents);
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.tf_year.text = [NSString stringWithFormat:@"%ld",dateComponents.year];
            weakSelf.tf_month.text = [NSString stringWithFormat:@"%ld",dateComponents.month];
            weakSelf.tf_day.text = [NSString stringWithFormat:@"%ld",dateComponents.day];
        });
    };
    
    [self presentViewController:datePickManager
                       animated:false
                     completion:nil];
}

- (IBAction)chooseSexAction:(id)sender {
    if (sender == self.btn_male) {
        [self.btn_male setSelected:YES];
        [self.btn_female setSelected:NO];
    }else{
        [self.btn_male setSelected:NO];
        [self.btn_female setSelected:YES];
    }
}


@end
