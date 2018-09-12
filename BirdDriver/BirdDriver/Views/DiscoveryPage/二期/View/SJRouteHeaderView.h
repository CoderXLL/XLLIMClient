//
//  SJRouteHeaderView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  路线详情头视图

#import <UIKit/UIKit.h>

@class JARouteListItemModel;
@interface SJRouteHeaderView : UIView

+ (instancetype)createCellWithXib;
@property (nonatomic, strong) JARouteListItemModel *itemModel;

@end
