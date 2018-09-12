//
//  SJRouteBottomView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/9/11.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJRouteBottomView.h"

@implementation SJRouteBottomView

+ (instancetype)createCellWithXib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SJRouteBottomView" owner:nil options:nil] objectAtIndex:0];
}


@end
