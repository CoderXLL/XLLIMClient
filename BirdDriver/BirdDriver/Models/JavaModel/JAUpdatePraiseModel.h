//
//  JAUpdatePraiseModel.h
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/31.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  取消点赞

#import "JAResponseModel.h"

@interface JAUpdatePraiseModel : JAResponseModel

//操作的帖子或活动ID
@property (nonatomic, assign) NSInteger detailsId;

@end
