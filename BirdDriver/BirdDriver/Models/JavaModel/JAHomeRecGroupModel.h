//
//  JAHomeRecGroupModel.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/31.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"
#import "JAActivityListModel.h"
#import "JABbsLabelModel.h"

@class JARecommendDetailSpolistModel;

/**
 首页推荐"标签+话题" -> 组成的数组Model
 */
@interface JAHomeRecGroupModel : JAResponseModel

@property (nonatomic, strong) NSArray<JARecommendDetailSpolistModel *> *recommendDetailsPOList;

@end


/**
 首页推荐数组里的元素 包括一个标签，以及标签对应的活动列表
 */
@interface JARecommendDetailSpolistModel : JAResponseModel

/**
 标签Model
 */
@property (nonatomic, strong) JABbsLabelModel *labelPO;

/**
 活动帖子组合集合
 */
@property (nonatomic, strong) JAActivityListModel *detailsPO;

@end



