//
//  SJActivityTicketCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/25.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//
//  发起足迹(活动)的Cell

#import "SPBaseCell.h"
@class SJBuildNoteModel;

@protocol SJActivityTicketCellDelegate <NSObject>

- (void)didClickAddPicture;

@end

@interface SJActivityTicketCell : SPBaseCell

@property (nonatomic, weak) id <SJActivityTicketCellDelegate> delegate;
@property (nonatomic, strong) SJBuildNoteModel *buildModel;
@property (nonatomic, copy) void(^reloadBlock)(void);

@end
