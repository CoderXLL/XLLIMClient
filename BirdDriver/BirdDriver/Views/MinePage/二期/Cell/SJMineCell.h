//
//  SJMineCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseCell.h"
@class SJCellModel;

@interface SJCellModel : SPBaseModel

//cell标题
@property (nonatomic, copy) NSString *title;
//cell配图
@property (nonatomic, copy) NSString *iconName;

@end

@interface SJMineCell : SPBaseCell

@property (nonatomic, strong) SJCellModel *cellModel;

@end
