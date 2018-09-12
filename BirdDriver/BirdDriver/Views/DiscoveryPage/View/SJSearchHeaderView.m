//
//  SJSearchHeaderView.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/28.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJSearchHeaderView.h"

@implementation SJSearchHeaderView

+ (instancetype)createCellWithXib{
    return [[[NSBundle mainBundle] loadNibNamed:@"SJSearchHeaderView" owner:nil options:nil] objectAtIndex:0];
}
@end
