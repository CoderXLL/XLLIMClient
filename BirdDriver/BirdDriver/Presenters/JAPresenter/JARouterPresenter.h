//
//  JARouterPresenter.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/28.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAPresenter.h"
#import "JAConfigModel.h"

@interface JARouterPresenter : JAPresenter

/**
 请求后台接口，更新配置的h5链接
 
 @param retBlock 返回后台配置Model
 */
+ (void)postQueryConfigResult:(void(^)(JAConfigModel *model))retBlock;

/**
 更新本地配置H5
 */
+ (void)updateLocalH5;

@end
