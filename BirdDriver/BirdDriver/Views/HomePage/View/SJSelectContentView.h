//
//  SJSelectContentView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/7.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JAActivityListModel;

@interface SJSelectContentView : UIView

@property (nonatomic, strong) JAActivityListModel *listModel;
@property (nonatomic, copy) void(^leftPullCallBack)(JAActivityListModel *);

@end
