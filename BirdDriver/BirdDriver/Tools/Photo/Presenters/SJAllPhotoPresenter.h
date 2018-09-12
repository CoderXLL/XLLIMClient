//
//  SJAllPhotoPresenter.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  获取所有相册

#import "SJBasePhotoPresenter.h"
@class SJPhotoModel;

@protocol SJPhotoViewDelegate <NSObject>

@required
- (void)setAllPhotos:(NSMutableArray <SJPhotoModel *>*)allPhotos;

@end

@interface SJAllPhotoPresenter : SJBasePhotoPresenter

/**
 P层代理
 */
@property (nonatomic, weak) id<SJPhotoViewDelegate> delegate;

/**
 获取所有照片数据
 */
- (void)getAllPhotosWithSelectedAssets:(NSArray <SJPhotoModel *>*)selectedAssets;

@end
