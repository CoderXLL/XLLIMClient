//
//  SJRouteListCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/20.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  路线列表cell

#import "SPBaseCell.h"

@class JARouteListItemModel, SJRouteListCell, JAUserAccountPosList;
@protocol SJRouteListCellDelegate <NSObject>

- (void)routeListCell:(SJRouteListCell *)cell didClickPosModel:(JAUserAccountPosList *)posModel;

@end

@interface SJRouteListCell : SPBaseCell

@property (nonatomic, strong) JARouteListItemModel *itemModel;
@property (nonatomic, copy) void(^clickBlock)(void);
@property (nonatomic, weak) id<SJRouteListCellDelegate>delegate;

@end
