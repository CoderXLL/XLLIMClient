//
//  SJRealNameViewController.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPViewController.h"
#import "SPCustomButtonView.h"

@interface SJRealNameViewController : SPViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;//姓名
@property (weak, nonatomic) IBOutlet UITextField *idNumberTextField;//身份证号
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;//错误提示
@property (weak, nonatomic) IBOutlet SPCustomButtonView *sureBtn;//提交

@end
