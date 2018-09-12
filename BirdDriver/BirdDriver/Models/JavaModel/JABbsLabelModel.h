//
//  JABbsLabelModel.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/31.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

/**
 鸟斯基标签Model
 */
@interface JABbsLabelModel : JAResponseModel

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) long long createTime;

@property (nonatomic, copy) NSString *imagesAddress;

@property (nonatomic, copy) NSString *labelName;

@property (nonatomic, copy) NSString *describtion;

#pragma mark - 自定义标签
@property (nonatomic, assign) BOOL isSelected;

@end
