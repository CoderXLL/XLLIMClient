//
//  SJRouteNavView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJRouteNavView : UIView

@property (nonatomic, assign) CGFloat bgAlpha;
@property (nonatomic, copy) void(^clickBlock)(BOOL isPop);

@end
