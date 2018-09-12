//
//  SJHobbyTextFieldView.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJHobbyTextFieldView.h"

@implementation SJHobbyTextFieldView

+ (instancetype)createCellWithXib{
    return [[[NSBundle mainBundle] loadNibNamed:@"SJHobbyTextFieldView" owner:nil options:nil] objectAtIndex:0];
}

@end
