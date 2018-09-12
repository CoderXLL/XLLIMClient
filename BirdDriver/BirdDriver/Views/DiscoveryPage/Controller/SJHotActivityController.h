//
//  SJHotActivityController.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/1.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPListViewController.h"
@class JABbsLabelModel, SJBackButton;

typedef NS_ENUM(NSInteger, SJHotNavgationBarStyle) {
    SJHotNavgationBarStyleHotActivity = 1000, //热门活动
    SJHotNavgationBarStyleMessage,             //消息
    SJHotNavgationBarStyleNone        //啥也没有
};

@interface SJHotNavgationBar : UIView

@property (nonatomic, copy) void(^clickBlock)(BOOL isBack);
@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, assign) SJHotNavgationBarStyle navgationBarStyle;

@end

/**
 热门足迹列表页面
 */
@interface SJHotActivityController : SPListViewController

@property (nonatomic, strong) JABbsLabelModel *labelModel;

@end
