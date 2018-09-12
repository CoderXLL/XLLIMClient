//
//  JABannerPresenter.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/30.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAPresenter.h"
#import "JABannerListModel.h"

@interface JABannerPresenter : JAPresenter

+ (void)postQueryBanner:(JABannerPlatform)platform
                 Result:(void (^_Nonnull)(JABannerListModel * _Nullable model))retBlock;

@end
