//
//  SJSetHeaderView.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/19.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SJSetHeaderView.h"

@implementation SJSetHeaderView

+ (instancetype)createCellWithXib{
    return [[[NSBundle mainBundle] loadNibNamed:@"SJSetHeaderView" owner:nil options:nil] objectAtIndex:0];
}

@end
