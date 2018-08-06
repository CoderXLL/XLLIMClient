//
//  XLLRegisterController.m
//  XLLIMChat
//
//  Created by 肖乐 on 2018/4/3.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import "XLLRegisterController.h"
#import "XLLLoginManager.h"
#import "XLLTabBarController.h"

@interface XLLRegisterController ()

@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation XLLRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.size = CGSizeMake(40, 35);
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = XLLFont(16.0);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerBtnClick:(id)sender {
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [[XLLLoginManager shareLoginManager] registerWithUserName:self.accountField.text password:self.passwordField.text successBlock:^{
        
        [UIApplication sharedApplication].keyWindow.rootViewController = [[XLLTabBarController alloc] init];
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
