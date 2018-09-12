//
//  SJHobbyTextFieldView.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJHobbyTextFieldView : UIView


@property (weak, nonatomic) IBOutlet UITextField *labelTextField;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

+ (instancetype)createCellWithXib;

@end
