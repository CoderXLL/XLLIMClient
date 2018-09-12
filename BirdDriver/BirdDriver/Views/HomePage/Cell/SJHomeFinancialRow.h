//
//  SJHomeFinancialRow.h
//  BirdDriver
//
//  Created by Soul on 2018/5/17.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseCell.h"
@class JABannerData, JABannerModel;

@protocol SJHomeFinancialRowDelegate <NSObject>

- (void)didSelectedWithBannerModel:(JABannerModel *)bannerModel;

@end

@interface SJHomeFinancialRow : SPBaseCell

@property (nonatomic, strong) JABannerData *subBannerModel;
@property (nonatomic, weak) id <SJHomeFinancialRowDelegate> delegate;

@end
