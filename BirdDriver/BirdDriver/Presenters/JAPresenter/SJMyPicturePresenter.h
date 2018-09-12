//
//  SJMyPicturePresenter.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/25.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JAAtlasModel;

@protocol SJMyPictureDelegate <NSObject>

//结束加载回调
- (void)didEndLoading;
//回调全局相册集
- (void)setPictureLists:(NSMutableArray <JAAtlasModel *>*)pictureLists;
//回调成功删除的图册
- (void)didSucceedDelete:(NSArray <JAAtlasModel *>*)pictureLists;
//成功创建名为name的新相册
- (void)didSucceedCreatePicture:(JAAtlasModel *)lasModel;

@end

@interface SJMyPicturePresenter : NSObject

@property (nonatomic, weak) id<SJMyPictureDelegate> delegate;

/**
 创建新相册

 @param name 新相册名称
 */
- (void)createPictureWithName:(NSString *)name;

/**
 获取所有相册集
 */
- (void)getPicturesWithPage:(NSInteger)page userId:(NSInteger)userId;

/**
 删除相册集

 @param lasList 相册集集合
 */
- (void)deletePictureWithAtlasList:(NSArray <JAAtlasModel *>*)lasList;

@end
