//
//  SJAccountSettingsViewController.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPViewController.h"
#import "GBTagListView.h"

@interface SJAccountSettingsViewController : SPViewController

@property (weak, nonatomic) IBOutlet UIButton *porImageView;//头像
@property (weak, nonatomic) IBOutlet UIButton *porBtn;//头像修改
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;//昵称
@property (weak, nonatomic) IBOutlet UIButton *genderManBtn;//性别男
@property (weak, nonatomic) IBOutlet UIButton *genderWomanBtn;//性别女
@property (weak, nonatomic) IBOutlet UITextField *describeTextField;//签名
@property (weak, nonatomic) IBOutlet UIButton *interestBtn;//个人爱好
@property (weak, nonatomic) IBOutlet GBTagListView *hobbyTagListView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hobbyHeight;
@property (weak, nonatomic) IBOutlet UIView *hobbyView;



@property(nonatomic, copy)NSString *hobbys;//爱好
@property(nonatomic, assign)BOOL isChange;







@end
