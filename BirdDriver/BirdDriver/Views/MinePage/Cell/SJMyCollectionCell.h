//
//  SJMyCollectionCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseCell.h"
@class SJMyCollectionCell, JAActivityModel;

@protocol SJMyCollectionCellDelegate <NSObject>

- (void)didLongPressed:(SJMyCollectionCell *)collectionCell;

@end

@interface SJMyCollectionCell : SPBaseCell

//活动
@property (nonatomic, strong) JAActivityModel *activityModel;
@property (nonatomic, weak) id<SJMyCollectionCellDelegate> delegate;

@end
