//
//  JAAddCollectionModel.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

@interface JAAddCollectionModel : JAResponseModel

//屌丝后台新增收藏接口多加的一个字段。。
@property (nonatomic, assign) NSInteger collectionId;

@end
