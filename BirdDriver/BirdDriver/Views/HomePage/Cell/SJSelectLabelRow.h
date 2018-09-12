//
//  SJSelectLabelRow.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/29.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseCell.h"
@class JARecommendDetailSpolistModel, JAActivityModel;

@protocol SJSelectLabelRowDelegate <NSObject>

@optional
- (void)didSelectedRowWithActivityModel:(JAActivityModel *)activityModel;

@end

@interface SJSelectLabelRow : SPBaseCell

//推荐模型数组
@property (nonatomic, strong) NSArray <JARecommendDetailSpolistModel *>*recommendDetailsPOList;
@property (nonatomic, weak) id<SJSelectLabelRowDelegate> delegate;

@end
