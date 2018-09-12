//
//  SJReportChooseCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseCell.h"

@interface SJReportChooseModel : SPBaseModel

@property (nonatomic, copy) NSString *reason;
@property (nonatomic, assign) BOOL isSelected;

@end

@interface SJReportChooseCell : SPBaseCell

@property (nonatomic, strong) NSArray *reportReason;

@end
