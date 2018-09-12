//
//  SJSearchNoDataView.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/29.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJSearchNoDataView.h"

@implementation SJSearchNoDataView

+ (instancetype)createCellWithXib{
    return [[[NSBundle mainBundle] loadNibNamed:@"SJSearchNoDataView" owner:nil options:nil] objectAtIndex:0];
}

@end
