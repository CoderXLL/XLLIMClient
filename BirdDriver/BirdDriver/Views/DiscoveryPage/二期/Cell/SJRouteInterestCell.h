//
//  SJRouteInterestCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  路线感兴趣cell

#import "SPBaseCell.h"

@class SJRouteInterestCell, JARouteListItemModel, JAUserAccountPosList;
@protocol SJRouteInterestCellDelegate <NSObject>

- (void)routeInterestCell:(SJRouteInterestCell *)cell didClickAccount:(JAUserAccountPosList *)posModel;

@end

@interface SJRouteInterestCell : SPBaseCell

@property (nonatomic, weak) id<SJRouteInterestCellDelegate> delegate;
@property (nonatomic, strong) JARouteListItemModel *itemModel;

@end
