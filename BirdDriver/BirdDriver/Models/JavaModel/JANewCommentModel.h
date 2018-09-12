//
//  JANewCommentModel.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/10.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  添加评论返回数据

#import "JAResponseModel.h"

@class JACommentModel;
@interface JANewCommentModel : JAResponseModel

@property (nonatomic, strong) JACommentModel *responseDto;

@end
