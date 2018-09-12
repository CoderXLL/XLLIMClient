//
//  SJFeedbackFootView.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJFeedbackFootView.h"

@implementation SJFeedbackFootView


+ (instancetype)createCellWithXib{
    return [[[NSBundle mainBundle] loadNibNamed:@"SJFeedbackFootView" owner:nil options:nil] objectAtIndex:0];
}

@end
