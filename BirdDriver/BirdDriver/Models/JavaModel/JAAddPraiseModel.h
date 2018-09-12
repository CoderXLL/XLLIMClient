//
//  JAAddPraiseModel.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

@interface JAAddPraiseModel : JAResponseModel

//赞ID
@property (nonatomic, assign) NSInteger praisesRelationId;
//操作的帖子或活动ID
@property (nonatomic, assign) NSInteger detailsId;

@end
