//
//  JADiscRecLabelModel.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/6/5.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"
#import "JABbsLabelModel.h"

@interface JADiscRecLabelModel : JAResponseModel

@property (nonatomic, strong) NSArray<JABbsLabelModel *> *labelList;

@end


