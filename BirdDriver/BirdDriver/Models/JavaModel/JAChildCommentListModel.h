//
//  JAChildCommentListModel.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/9.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

@class JACommentModel;
@interface JAChildCommentListModel : JAResponseModel

//主体
@property (nonatomic, strong) JACommentModel *entity;
//list
@property (nonatomic, strong) NSArray <JACommentModel *>*childList;

@end
