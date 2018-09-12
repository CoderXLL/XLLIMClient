//
//  SJFeedbackFootView.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPCustomButtonView.h"

@interface SJFeedbackFootView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet SPCustomButtonView *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;


+ (instancetype)createCellWithXib;

@end
