//
//  JAIsReportedModel.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/19.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

@interface JAIsReportedModel : JAResponseModel

/**
 是否举报过
 */
@property (nonatomic, assign) BOOL reported;

@end
