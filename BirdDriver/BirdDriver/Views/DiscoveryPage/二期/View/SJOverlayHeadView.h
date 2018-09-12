//
//  SJOverlayHeadView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/20.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  重叠头像View

#import <UIKit/UIKit.h>

@class JAUserAccountPosList;
@interface SJOverlayHeadView : UIView

@property (nonatomic, strong) NSArray <JAUserAccountPosList *>*accountList;
@property (nonatomic, copy) void(^clickBlock)(JAUserAccountPosList *);

@end
