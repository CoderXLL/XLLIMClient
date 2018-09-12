//
//  SJGradientButton.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  项目中色彩渐变基类button(支持IB显示)

#import <UIKit/UIKit.h>

IB_DESIGNABLE;
@interface SJGradientButton : UIButton

/**
 快速初始化实例

 @return 实例
 */
+ (instancetype)gradientButton;

@property (nonatomic, assign) BOOL isLogin;
//设置按钮标题
@property (nonatomic, copy) IBInspectable NSString *titleStr;

@end
