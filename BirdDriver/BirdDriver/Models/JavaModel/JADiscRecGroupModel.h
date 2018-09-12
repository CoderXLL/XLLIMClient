//
//  JADiscRecGroupModel.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/31.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"
#import "JAActivityListModel.h"
#import "JABbsLabelModel.h"

@class JAActivityPostsModel;
@interface JADiscRecGroupModel : JAResponseModel

/**
 活动帖子集合组合
 */
@property (nonatomic, strong) JAActivityPostsModel *detailsPO;

@end

@interface JAActivityPostsModel : NSObject

/**
 活动集合
 */
@property (nonatomic, strong) NSArray<JAActivityModel *> *activitysList;

/**
 帖子集合
 */
@property (nonatomic, strong) NSArray<JAPostsModel *> *postsList;

@end

