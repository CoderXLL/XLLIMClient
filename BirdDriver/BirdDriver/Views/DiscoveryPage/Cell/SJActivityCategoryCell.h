//
//  SJActivityCategoryCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/25.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseCell.h"
@class JABbsLabelModel;

@interface SJActivityCategoryCell : SPBaseCell

@property (nonatomic, strong) JABbsLabelModel *myTagModel;
@property (nonatomic, assign) BOOL isExpandStatus;
@property (nonatomic, copy) void(^expandBlock)(void);

@end
