//
//  JAPostChildCommentModel.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/9/3.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

@class JACommentVOModel, SJPostChildCommentDataModel;
@interface JAPostChildCommentModel : JAResponseModel

@property (nonatomic, strong) JACommentVOModel *superComment;
@property (nonatomic, strong) SJPostChildCommentDataModel *data;

@end

@interface SJPostChildCommentDataModel : SPBaseModel

@property (nonatomic, strong) NSMutableArray <JACommentVOModel *>*list;

@end
