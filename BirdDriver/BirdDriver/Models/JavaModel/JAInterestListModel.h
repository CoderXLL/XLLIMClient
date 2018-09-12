//
//  JAInterestListModel.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/28.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

@class JAInterestListDataModel, JAUserAccountPosList;
@interface JAInterestListModel : JAResponseModel

@property (nonatomic, strong) JAInterestListDataModel *data;

@end

@interface JAInterestListDataModel : SPBaseModel

@property (nonatomic, strong) NSMutableArray <JAUserAccountPosList *>*list;

@end
