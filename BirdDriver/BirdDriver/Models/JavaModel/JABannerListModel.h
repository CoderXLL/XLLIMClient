//
//  JABannerListModel.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/30.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

typedef NS_ENUM(NSInteger, JABannerPlatform) {
    JABannerPlatformPC          = 1,    // PC       主Banner
    JABannerPlatformAPP         = 2,    // H5&APP   主Banner
    JABannerPlatformActivity    = 3,    // 活动
    JABannerPlatformSub         = 4,    // 鸟斯基首页 副Banner
    JABannerPlatformMissWorld   = 1001  // 世界小姐
//    JABannerPlatformSub         = 1002  // 鸟斯基首页 副Banner
};

@class JABannerData,JABannerModel;

@interface JABannerListModel : JAResponseModel

@property (nonatomic, strong) JABannerData *data;

@end

@interface JABannerData : NSObject

@property (nonatomic, assign) NSInteger startRow;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger pages;

@property (nonatomic, assign) NSInteger navigateLastPage;

@property (nonatomic, assign) NSInteger navigateFirstPage;

@property (nonatomic, assign) NSInteger endRow;

@property (nonatomic, assign) BOOL isFirstPage;

@property (nonatomic, assign) NSInteger prePage;

@property (nonatomic, assign) BOOL hasPreviousPage;

@property (nonatomic, assign) NSInteger firstPage;

@property (nonatomic, assign) NSInteger lastPage;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) NSInteger navigatePages;

@property (nonatomic, strong) NSArray<JABannerModel *> *list;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) BOOL isLastPage;

@property (nonatomic, assign) NSInteger nextPage;

@property (nonatomic, assign) BOOL hasNextPage;

@property (nonatomic, strong) NSArray<NSNumber *> *navigatepageNums;

@end

@interface JABannerModel : NSObject

@property (nonatomic, assign) NSInteger jumpPage;

@property (nonatomic, copy) NSString *picUrl;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger Id;

@property (nonatomic, copy) NSString *jumpUrl;

@property (nonatomic, assign) NSInteger showOrder;

@property (nonatomic, assign) JABannerPlatform platform;

@property (nonatomic, copy) NSString *bannerName;

@property (nonatomic, assign) long long createTime;

@end


