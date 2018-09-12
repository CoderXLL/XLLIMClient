//
//  SJHomeRecViewRow.h
//  BirdDriver
//
//  Created by Soul on 2018/5/17.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseCell.h"

@class JABannerModel;
@interface SJHomeRecViewRow : SPBaseCell

@property (nonatomic, strong) NSArray <JABannerModel *>*bannerList;
@property (nonatomic, copy) void(^detailBlock)(JABannerModel *);

@end
